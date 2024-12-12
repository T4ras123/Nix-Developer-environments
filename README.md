# Nix Developer Environments

Welcome to the Nix Developer Environments repository! This collection provides ready-to-use development environments for various programming languages, all managed with Nix flakes. Say goodbye to setup headaches and start coding faster.

## Available Environments

- **Go**
- **Java**
- **JavaScript**
- **Haskell**
- **C/C++**
- **Rust**
- **Zig**
- **Machine Learning (Python)**

Each environment includes essential tools and libraries to help you hit the ground running.

## Getting Started 🏁

### Prerequisites

- **Install Nix**: Follow the instructions [here](https://nixos.org/download.html).
- **Enable Flakes**: Add the following line to your `~/.config/nix/nix.conf`:

  ```nix
  experimental-features = nix-command flakes
  ```

### Clone the Repository

```sh
git clone https://github.com/Vover/Nix-Developer-environments.git
```

### Using `dev-cli`

`dev-cli` simplifies environment setup with an interactive CLI.

#### Setup

```sh
cd Nix-Developer-environments/dev-cli 
cargo build --release                             # build the project
export DEV_REPO_PATH=/path/to/this/repo           # to help find your nix declarations
cp target/release/dev-cli ~/.local/bin/dev-cli    # copy the compiled binary to path
dev-cli <environment> [--repo /path/to/repo]      # use!! 
```

#### Example

```sh
dev-cli rust
```

### Enter the Development Shell

If not using `dev-cli`, manually enter the shell:

```sh
cd Nix-Developer-environments/Rust_dev_env
nix develop
```

## Modifying the Environments 

Each environment is defined in its respective `flake.nix` file. To customize:

1. Open the desired `flake.nix`.
2. Add or remove packages in the `buildInputs` section.
3. Modify `shellHook` for environment-specific configurations.

## Tweak to Your Preference 

- **Aliases**: Customize or add new aliases in `shellHook`.
- **Environment Variables**: Set additional variables as needed.
- **Tools**: Add new development tools by including them in `buildInputs`.

## Contributing 

Contributions are welcome! Open an issue or submit a pull request with your improvements or additional environments.

## License 

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---
Happy coding! 🎉
