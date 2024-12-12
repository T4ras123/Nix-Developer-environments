{
  description = "Comprehensive ML Development Environment";

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

            # Python and core ML packages
            pkgs.python312
            pkgs.python312Packages.pip
            pkgs.python312Packages.virtualenv
            pkgs.python312Packages.numpy 
            pkgs.python312Packages.pandas
            pkgs.python312Packages.scikit-learn
            pkgs.python312Packages.matplotlib
            pkgs.python312Packages.torch
            pkgs.python312Packages.torchvision
            pkgs.python312Packages.transformers
            
            # ML and Data Science Additional Packages
            pkgs.python312Packages.scipy
            pkgs.python312Packages.seaborn
            pkgs.python312Packages.plotly
            pkgs.python312Packages.keras

            # Development Tools
            pkgs.poetry
            pkgs.git
            pkgs.lazygit
            pkgs.tmux
            pkgs.neovim
            pkgs.bash

            # Python Development Tools
            pkgs.python312Packages.black
            pkgs.python312Packages.isort
            pkgs.python312Packages.pylint
            pkgs.python312Packages.pytest
            pkgs.python312Packages.mypy

            # Jupyter and Interactive Development
            pkgs.python312Packages.jupyter
            pkgs.python312Packages.ipython
            pkgs.python312Packages.notebook

            # Additional Utilities
            pkgs.wget
            pkgs.curl
            pkgs.zip
            pkgs.unzip

          ];

          shellHook = ''
            echo "🚀 ML Development Environment Activated 🧠"
            echo "Python version: $(python --version)"
            echo "Pip version: $(pip --version)"
            
            # Create and activate virtual environment
            if [ ! -d "ML" ]; then
              python -m venv ML
            fi
            source ML/bin/activate

            # Optional: Set up some helpful aliases
            alias jlab='jupyter lab'
            alias jpynb='jupyter notebook'
            alias lint='pylint **/*.py'
            alias format='black . && isort .'

            # Print out some helpful information
            echo "🔧 Available tools:"
            echo "  - Jupyter Lab/Notebook"
            echo "  - Poetry for dependency management"
            echo "  - Black for formatting"
            echo "  - Pylint for linting"
            echo "  - Pytest for testing"
          '';
        };
      }
    );
}
