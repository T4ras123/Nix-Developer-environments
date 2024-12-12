{
  description = "Zig Development Environment";

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
            # Zig compiler and tools
            pkgs.zig
            pkgs.zls  # Zig Language Server
            
            # Build and system tools
            pkgs.cmake
            pkgs.ninja
            pkgs.pkg-config

            # Version control and development
            pkgs.git
            pkgs.lazygit

            # Additional development tools
            pkgs.tmux
            pkgs.neovim
            pkgs.direnv

            # Debugging and profiling
            pkgs.gdb
            pkgs.lldb
            pkgs.valgrind

            # Helpful utilities
            pkgs.just  # Command runner
            pkgs.ripgrep
            pkgs.fd

            # Cross-compilation support
            pkgs.clang
            pkgs.lld  # LLVM linker
          ];

          shellHook = ''
            echo "🥷 Zig Development Environment Activated 🚀"
            echo "Zig version: $(zig version)"

            # Set up helpful aliases
            alias zb='zig build'
            alias zr='zig run'
            alias zt='zig test'
            alias zf='zig fmt'

            # Create project directories if they don't exist
            mkdir -p .zig-cache
            export ZIG_GLOBAL_CACHE_DIR="$PWD/.zig-cache"

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  zb  - zig build"
            echo "  zr  - zig run"
            echo "  zt  - zig test"
            echo "  zf  - zig fmt"

            # Optional: Set up some environment variables for cross-compilation
            export CC=zig
            export CXX=zig
          '';

          # Configure some environment variables
          shellPath = "${pkgs.bash}/bin/bash";
        };
      }
    );
}
