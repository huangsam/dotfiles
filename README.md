# dotfiles

Collection of dotfiles.

What is present at the moment:

- Shortcuts for CLI tools in `custom`
- Script for moving `custom` shortcuts to `$ZSH_CUSTOM`
- Script for moving `custom` shortcuts to `$ALIAS_PATH`
- Custom configuration for `git` CLI
- Custom configuration for `pip` CLI

**Note:** Using the shortcuts above should reduce your risk for [Carpal Tunnel Syndrome](https://orthoinfo.aaos.org/en/diseases--conditions/carpal-tunnel-syndrome/). :smile:

## Getting started

For `oh-my-zsh` users:

- Run `bash bootstrap.sh` to install these files to `$ZSH_CUSTOM`
- Reload your `.zshrc` to load the new aliases
- You can export `$ZSH_CUSTOM` before running `bootstrap.sh`

For `bash` users:

- Run `bash combine.sh` to generate a `bash_aliases` file
- Move `bash_aliases` to wherever you like
- You can export `$ALIAS_PATH` before running `combine.sh`

## Project inspiration

This effort was inspired by the following repos:

- https://github.com/robbyrussell/oh-my-zsh
- https://github.com/mathiasbynens/dotfiles
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/zsh-users/antigen
