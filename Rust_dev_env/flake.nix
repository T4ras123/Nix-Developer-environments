{
  description = "Rust Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        # Choose a specific Rust toolchain
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ 
            "rust-src"  # Rust source code
            "rustfmt"   # Rust formatter
            "clippy"    # Rust linter
            "rust-analysis"  # Rust analyzer support
          ];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Rust toolchain
            rustToolchain

            # Development tools
            pkgs.rust-analyzer
            pkgs.cargo
            pkgs.rustc
            pkgs.cargo-watch
            pkgs.cargo-edit
            pkgs.cargo-release
            pkgs.cargo-flamegraph

            # Build and system dependencies
            pkgs.pkg-config
            pkgs.openssl

            # Version control
            pkgs.git
            pkgs.lazygit

            # Additional useful tools
            pkgs.tmux
            pkgs.neovim
            pkgs.direnv
            pkgs.just  # Command runner similar to make
            pkgs.ripgrep
            pkgs.fd

            # Debugging and profiling
            pkgs.gdb
            pkgs.lldb
            pkgs.valgrind
          ];

          # Shell setup and environment variables
          shellHook = ''
            echo "🦀 Rust Development Environment Activated 🚀"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"

            # Set up some helpful aliases
            alias cb='cargo build'
            alias cr='cargo run'
            alias ct='cargo test'
            alias cc='cargo check'
            alias cl='cargo clippy'
            alias cfmt='cargo fmt'

            # Optional: Create a project-specific directory for builds
            mkdir -p .cargo-target
            export CARGO_TARGET_DIR="$PWD/.cargo-target"

            # Print out available commands
            echo "🛠️ Available commands:"
            echo "  cb  - cargo build"
            echo "  cr  - cargo run"
            echo "  ct  - cargo test"
            echo "  cc  - cargo check"
            echo "  cl  - cargo clippy"
            echo "  cfmt - cargo fmt"
          '';
        };
      }
    );
}
