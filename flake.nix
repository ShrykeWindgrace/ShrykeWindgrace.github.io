{
  description = "pesonal blog @ github.io";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        with pkgs; {
          devShells.default = (mkShell.override { stdenv = stdenvNoCC; }) {
            buildInputs = [
              stack
              gnumake
              fd
              dos2unix
              poppler-utils # pdftocairo
              (texlive.combine {
                inherit (texlive)
                  scheme-basic
                  standalone # standalone.cls
                  pgfplots # tikz library intersections
                  xcolor

                  tkz-euclide
                  tikz-layers
                  xpatch
                  amsmath
                  ;
              })
            ];
            shellHook = "
    ";
          };
        }
      );
}

