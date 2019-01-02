# Overview

My opinionated collection of dotfiles, your mileage my vary. This has been tested on MacOS, Ubuntu and CentOS. To get the most value out of these ZSH is the preferred shell, little to no customization for Bash.

I recommend forking this Repo and modifying to your needs, specifically `gitconfig` and `Brewfile`.

# Installation

```bash
$ curl -Lo- https://raw.github.com/aaronlake/dotfiles/master/bootstrap.sh | bash

# Optional Homebrew Bundle
$ cd ~/.dotfiles && brew bundle install
```

# Details

## Homebrew (MacOS)

Again, opinionated list of applications to install on a fresh MacOS build.

```bash
$ cd ~/.dotfiles && brew bundle install
```

# ZSH

Uses [https://github.com/getantibody/antibody](Antibody) shell plugin manager to install a dozen or so OS and language specific plugins.

# Git

Modify the gitconfig with your information.
