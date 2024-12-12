{
  description = "Comprehensive C/C++ Development Environment";

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
            # Compilers
            pkgs.gcc
            pkgs.clang
            pkgs.clang-tools
            pkgs.llvm
            
            # Build tools
            pkgs.cmake
            pkgs.ninja
            pkgs.cmake
            pkgs.autoconf
            pkgs.automake
            pkgs.libtool
            pkgs.pkg-config

            # Debuggers and profilers
            pkgs.gdb
            pkgs.valgrind
            pkgs.ltrace
            pkgs.strace

            # Version control
            pkgs.git
            pkgs.lazygit

            # Additional development tools
            pkgs.tmux
            pkgs.neovim
            pkgs.direnv
            
            # Helpful utilities
            pkgs.just
            pkgs.ripgrep
            pkgs.fd

            # Common libraries
            pkgs.zlib
            pkgs.libffi
            pkgs.openssl

            # Language servers and formatters
            pkgs.ccls
            pkgs.clang-tools
            pkgs.cppcheck
            pkgs.llvmPackages.libcxx
          ];

          shellHook = ''
            echo "🖥️ C/C++ Development Environment Activated 🚀"
            echo "GCC version: $(gcc --version | head -n 1)"
            echo "Clang version: $(clang --version | head -n 1)"

            # Set up helpful aliases
            alias cb='cmake -B build && cmake --build build'
            alias cbr='cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build'
            alias cbd='cmake -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build'
            alias ctest='cd build && ctest && cd ..'
            alias format='find . -regex ".*\.\(cpp\|hpp\|c\|h\)" -exec clang-format -i {} \;

            # Create build directory
            mkdir -p build

            # Set up some environment variables
            export CC=clang
            export CXX=clang++

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  cb   - Basic CMake build"
            echo "  cbr  - Release build"
            echo "  cbd  - Debug build"
            echo "  ctest - Run tests"
            echo "  format - Format all source files"
          '';

          # Allow breaking into a shell with these libraries
          LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
      }
    );
}
