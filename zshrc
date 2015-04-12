### OS Detection
UNAME=`uname`

# Fallback info
CURRENT_OS='Linux'
DISTRO=''

if [[ $UNAME == 'Darwin' ]]; then
  CURRENT_OS='OS X'
else
  # Must be Linux, determine distro
  if [[ -f /etc/redhat-release ]]; then
    # CentOS or Redhat?
    if grep -q "CentOS" /etc/redhat-release; then
      DISTRO='CentOS'
    else
      DISTRO='RHEL'
    fi
  fi
fi

### Antigen Configuration

# Load Antigen
source ~/dotfiles/antigen.zsh

# PATH Settings
PATH=/opt/boxen/homebrew/bin:$PATH

# Load various lib files
antigen bundle robbyrussell/oh-my-zsh lib/

# Antigen Theme
antigen theme jdavis/zsh-files themes/jdavis

# Antigen bundles
antigen bundle git
antigen bundle tmuxinator
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle heroku
antigen bundle command-not-found
antigen bundle rbenv

# Os specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
antigen bundles <<EOBUNDLES
  brew
  brew-cask
  gem
  osx
  sudo
  node
  atom
  meteor
  rails
  vi-mode
  aws
  ruby
  nvm
  npm
  vagrant
    
  unixorn/git-extra-commands
  unixorn/autoupdate-antigen.zshplugin
EOBUNDLES

  PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

elif [[ $CURRENT_OS == 'Linux' ]]; then

  if [[ $DISTRO == 'CentOS' ]]; then
    antigen bundle centos
  fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
  antigen bundle cygwin
fi

# Fish-like bundles
antigen bundle zsh-users/fizsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle tarruda/zsh-autosuggestions


# Ensure languages are set
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Exports & Functions
source ~/dotfiles/exports
source ~/dotfiles/functions

# Command line helpers
if [[ -d "/usr/local/share/zsh-completions"  ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

