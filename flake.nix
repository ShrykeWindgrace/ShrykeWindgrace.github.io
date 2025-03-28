{
  description = "pesonal blog @ github.io";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ghc = "ghc984";
          packagePostOverrides = pkg: with pkgs.haskell.lib.compose; pkgs.lib.pipe pkg [
            disableExecutableProfiling
            disableLibraryProfiling
            dontBenchmark
            dontCoverage
            dontDistribute
            dontHaddock
            dontHyperlinkSource
            doStrip
            enableDeadCodeElimination
            justStaticExecutables

            dontCheck
          ];
          blog = packagePostOverrides (
            pkgs.haskell.packages.${ghc}.callCabal2nix "blog" self { }
          );
        in
        with pkgs; {
          devShells.default = (mkShell.override { stdenv = stdenvNoCC; }) {
            buildInputs = [
              # the engine itself
              blog

              # task runners
              gnumake
              just

              # formatting utilities
              fd
              dos2unix

              # LaTeX and friends
              poppler-utils # pdftocairo
              (texlive.combine {
                inherit (texlive)
                  scheme-basic
                  standalone# standalone.cls
                  pgfplots# tikz library intersections
                  xcolor

                  tkz-euclide
                  tikz-layers
                  xpatch
                  amsmath
                  ;
              })
            ];
          };
        }
      );
}

