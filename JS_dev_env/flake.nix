{
  description = "JavaScript Development Environment";

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
            # Node.js and package managers
            pkgs.nodejs
            pkgs.yarn
            pkgs.npm

            # JavaScript tools
            pkgs.typescript
            pkgs.eslint
            pkgs.prettier

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
            echo "📦 JavaScript Development Environment Activated 🚀"
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo "Yarn version: $(yarn --version)"

            # Set up helpful aliases
            alias ns='npm start'
            alias nb='npm run build'
            alias nl='npm run lint'
            alias nf='npm run format'

            # Create node_modules directory if it doesn't exist
            mkdir -p node_modules

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  ns - npm start"
            echo "  nb - npm run build"
            echo "  nl - npm run lint"
            echo "  nf - npm run format"
          '';
        };
      }
    );
}