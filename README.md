# dotfiles

Collection of dotfiles.

What is present at the moment:

- Artifacts for the `$ZSH_CUSTOM` folder
- Script to import artifacts to `$ZSH_CUSTOM`
- Script to combine artifacts as `bash_aliases`
- Git configuration with embedded aliases

The `custom` folder supports aliases and functions for the following CLIs:

- Git
- Python
- Docker
- Maven

These extensions and others can be found by inspecting the `zsh` files.

**Note:** Using these commands reduces your risk for carpal-tunnel.

## Usage

If you are using `oh-my-zsh`:

1. Run `bash bootstrap.sh` to install these files to `$ZSH_CUSTOM`
2. Create a clean terminal instance to load the new aliases in

If you are using plain `bash`:

1. Run `bash combine.sh` to generate a `bash_aliases` file
2. Upload the `bash_aliases` file to anywhere you like

### Assumptions

`bootstrap.sh` assumes the following about your setup:

- `oh-my-zsh` is installed on your local machine
- `ZSH_CUSTOM` is set to `~/.oh-my-zsh/custom`

`combine.sh` assumes the following about your setup:

- `bash` is installed on your local machine
- `.bashrc` exists in your home directory
- `.bash_aliases` is imported inside your `.bashrc`

## Inspiration

- https://github.com/robbyrussell/oh-my-zsh
- https://github.com/mathiasbynens/dotfiles
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/zsh-users/antigen
