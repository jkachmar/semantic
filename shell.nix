args@{...}:

let
  sources = import ./nix/source.nix;
  niv = (import sources.niv{}).niv;

  default = (import ./default.nix args);
  inherit (default.project) mkShell;
in

mkShell {
  buildInputs = [
    niv
    nix-prefetch-git
  ];
}
