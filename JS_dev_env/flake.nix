{
  description = "Go Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Go compiler and tools
            pkgs.go
            pkgs.gopls
            
            # Development tools
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
            echo "🐹 Go Development Environment Activated 🚀"
            echo "Go version: $(go version)"
            
            # Set GOPATH
            export GOPATH="$PWD/go"
            mkdir -p "$GOPATH"
            
            # Set up helpful aliases
            alias gb='go build'
            alias gr='go run'
            alias gt='go test'
            alias gf='go fmt ./...'
            
            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  gb - go build"
            echo "  gr - go run"
            echo "  gt - go test"
            echo "  gf - go fmt"
          '';
        };
      }
    );
}