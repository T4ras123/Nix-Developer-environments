{
  description = "Haskell Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    haskellNix.url = "github:input-output-hk/haskell.nix";
  };

  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ haskellNix.overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Haskell compiler and tools
            pkgs.haskellPackages.ghc
            pkgs.haskellPackages.cabal-install
            pkgs.haskellPackages.stack

            # Development tools
            pkgs.haskellPackages.haskell-language-server
            pkgs.haskellPackages.hlint
            pkgs.haskellPackages.stylish-haskell
            pkgs.haskellPackages.hoogle

            # Version control
            pkgs.git
            pkgs.lazygit
            pkgs.neovim
            pkgs.tmux
            pkgs.direnv

            # Helpful utilities
            pkgs.just
            pkgs.ripgrep
            pkgs.fd
          ];

          shellHook = ''
            echo "💎 Haskell Development Environment Activated 🚀"
            echo "GHC version: $(ghc --version)"
            echo "Cabal version: $(cabal --version | head -n 1)"
            echo "Stack version: $(stack --version)"

            # Set up helpful aliases
            alias hc='hoogle server --local --port=8080'
            alias cb='cabal build'
            alias cr='cabal run'
            alias ct='cabal test'
            alias clint='hlint .'
            alias cfmt='stylish-haskell -i **/*.hs'

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  hc    - Start Hoogle server"
            echo "  cb    - cabal build"
            echo "  cr    - cabal run"
            echo "  ct    - cabal test"
            echo "  clint - hlint ."
            echo "  cfmt  - stylish-haskell"
          '';
        };
      }
    );
}