{-# LANGUAGE TypeFamilies, UndecidableInstances #-}
module Data.Abstract.Located where

import Control.Abstract.Addressable
import Control.Effect
import Control.Monad.Effect.Reader
import Data.Abstract.Address
import Data.Abstract.Origin
import Prologue

data Located location term = Located { location :: location, origin :: !(SomeOrigin term) }

deriving instance (Eq location, Eq (Base term ())) => Eq (Located location term)
deriving instance (Ord location, Ord (Base term ())) => Ord (Located location term)
deriving instance (Show location, Show (Base term ())) => Show (Located location term)

instance (Location location, Ord (Base term ())) => Location (Located location term) where
  type Cell (Located location term) = Cell location

instance ( Addressable location effects
         , Member (Reader (SomeOrigin term)) effects
         , Ord (Base term ())
         )
      => Addressable (Located location term) effects where
  derefCell (Address (Located loc _)) = raise . lower . derefCell (Address loc)

  allocLoc name = raise (lower (Located <$> allocLoc name <*> raise ask))
