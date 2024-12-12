{
  description = "Java Development Environment";

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
            # Java Development Kit
            pkgs.openjdk11  # Or pkgs.openjdk17 for Java 17

            # Build tools
            pkgs.maven
            pkgs.gradle

            # Development tools
            pkgs.eclipse-mat  # Java Development Tools
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
            echo "☕ Java Development Environment Activated 🚀"
            echo "Java version: $(java -version 2>&1 | head -n 1)"
            echo "Maven version: $(mvn --version | head -n 1)"
            echo "Gradle version: $(gradle --version | grep Gradle)"

            # Set up helpful aliases
            alias mb='mvn compile'
            alias mt='mvn test'
            alias mr='mvn exec:java'
            alias gb='gradle build'
            alias gr='gradle run'
            alias gt='gradle test'

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  Maven:"
            echo "    mb - mvn compile"
            echo "    mt - mvn test"
            echo "    mr - mvn exec:java"
            echo "  Gradle:"
            echo "    gb - gradle build"
            echo "    gr - gradle run"
            echo "    gt - gradle test"
          '';
        };
      }
    );
}