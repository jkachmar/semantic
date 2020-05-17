args@{...}:

let
  sources = import ./nix/source.nix;
  niv = (import sources.niv{}).niv;

  default = (import ./default.nix args);
in

default.project.shellFor {
  buildInputs = [
    niv
  ];
}
