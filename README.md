# Sam's dotfiles

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/huangsam/dotfiles/ci.yml)](https://github.com/huangsam/dotfiles/actions)
[![License](https://img.shields.io/github/license/huangsam/dotfiles)](https://github.com/huangsam/dotfiles/blob/main/LICENSE)

Collection of dotfiles to boost productivity on macOS. 🚀

Using them will reduce your risk for [Carpal Tunnel](https://orthoinfo.aaos.org/en/diseases--conditions/carpal-tunnel-syndrome/).

## Getting started

For first-time setup, run:

```shell
# Setup system tools and configurations
zsh setup_system.zsh

# Setup OpenJDK symlinks for macOS
zsh setup_openjdk.zsh
```

For regular maintenance and upkeep:

```shell
# Generate .zsh_aliases file at the home directory
zsh combine_aliases.zsh

# Copy all dotfiles to the home directory
zsh copy_configs.zsh
```

[Click here](./custom/) to see what gets populated in `.zsh_aliases`.

## Credits

Special thanks to the following repositories for inspiration and resources:

- [amix/vimrc](https://github.com/amix/vimrc) - Collection of vimrc configurations for a better Vim experience.
- [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core) - Main repository for Homebrew formulae.
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) - Dotfiles to personalize macOS or Linux environment.
- [robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) - Community-driven framework for managing zsh configuration.
- [unixorn/awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) - Frameworks and other resources for Zsh.
