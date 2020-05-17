{ ghcVersion ? "ghc881" }:

let
  sources = import ./nix/sources.nix;
  haskell-nix = import sources.haskell-nix {};
  
  # All the haskell.nix overlays + any additional overlays we might like to
  # to include.
  #
  # To add additional overlays, append them as a list (be cautious and remember
  # that order of application matters with overlays).
  overlays = haskell-nix.overlays;
  
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
  ghc = pkgs.buildPackages.haskell-nix.compiler.${ghcVersion};

in

cabalProject {
  inherit ghc;
  index-state = "2020-05-16T00:00:00Z";

  src = cleanGit { 
    name = "semantic";
    src = ./.;
  };
}
