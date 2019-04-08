# dotfiles

Collection of dotfiles.

What is present at the moment:

- Shortcuts for command-line tools
- Script to move `custom` artifacts to `$ZSH_CUSTOM`
- Script to move `custom` artifacts to `$ALIAS_PATH`
- Custom Git configuration for personal/project use
- Custom Python configuration for `pip` binary

**Note:** Using the shortcuts above should reduce your risk for [Carpal Tunnel Syndrome](https://orthoinfo.aaos.org/en/diseases--conditions/carpal-tunnel-syndrome/). :-)

## Getting started

If you are using `oh-my-zsh`:

1. Run `bash bootstrap.sh` to install these files to `$ZSH_CUSTOM`
2a. Create a new `zsh` shell to load the new aliases
2b. Otherwise, source your `~/.zshrc` to load the new aliases

If you are using plain `bash`:

1. Run `bash combine.sh` to generate a `bash_aliases` file
2. Move `bash_aliases` to wherever you like

## Project inspiration

This effort was inspired by the following repos:

- https://github.com/robbyrussell/oh-my-zsh
- https://github.com/mathiasbynens/dotfiles
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/zsh-users/antigen
