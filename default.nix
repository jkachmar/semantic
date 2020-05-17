{ ghcVersion ? "ghc881" }:

let
  sources = import ./nix/sources.nix;
  haskell-nix = import sources.haskell-nix {};

  # Helper function to construct an overlay that pins the haskell.nix Hackage
  # and Stackage sources to the ones pinned by 'nix/sources.json'.
  haskellNixOverlays = _self: super: {
    haskell-nix = super.haskell-nix // {
      hackageSrc = sources.hackage-nix;
      stackageSrc = sources.stackage-nix;
    };
  };
  
  # All the haskell.nix overlays + any additional overlays we might like to
  # to include.
  #
  # To add additional overlays, append them as a list (be cautious and remember
  # that order of application matters with overlays).
  overlays = haskell-nix.overlays ++ [ haskellNixOverlays ];
  
  # Arguments to apply to a given nixpkgs set with all the overlays applied.
  #
  # `inherit overlays;` is shorthand for `overlays = overlays;`.
  pkgsArgs = haskell-nix.nixpkgsArgs // { inherit overlays; };
  pkgsSrc = haskell-nix.sources.nixpkgs-default;

  # pkgs = import sources.nixpkgs (pkgsArgs);
  pkgs = import pkgsSrc (pkgsArgs);

  # Import 
  inherit (pkgs.haskell-nix) cabalProject;
  inherit (pkgs.haskell-nix.haskellLib) cleanGit;

in

cabalProject {
  compiler-nix-name = ghcVersion;
  index-state = "2020-05-16T00:00:00Z";

  src = cleanGit { 
    name = "semantic";
    src = ./.;
  };
}
