# dotfiles

Collection of dotfiles. What is present at the moment:

- [x] Plugins for the `$ZSH_CUSTOM` folder
- [x] Git configuration

## Usage

If you are using `oh-my-zsh`:

1. Run `bash bootstrap.sh` to install these files to `$ZSH_CUSTOM`
2. Create a clean terminal instance to load the new aliases in

If you are using plain `bash`:

1. Run `bash combine.sh` to generate a `bashrc` file
2. Upload the `bashrc` file to anywhere you like

## Assumptions

Currently, `bootstrap.sh` assumes the following about your setup:

- `oh-my-zsh` is installed on your local machine
- `ZSH_CUSTOM` is set to `~/.oh-my-zsh/custom`

## Inspiration

- https://github.com/robbyrussell/oh-my-zsh
- https://github.com/mathiasbynens/dotfiles
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/zsh-users/antigen
