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
source ~/.dotfiles/antigen.zsh

# PATH Settings
PATH=/opt/boxen/homebrew/bin:/User/alake/bin:$PATH

# Load various lib files
antigen bundle robbyrussell/oh-my-zsh lib/

# Antigen Theme
antigen theme blinks

# Antigen bundles
antigen bundle git
antigen bundle tmuxinator
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle heroku
antigen bundle command-not-found
antigen bundle rbenv
antigen bundle psprint/zsh-cmd-architect
antigen bundle psprint/zsh-navigation-tools
antigen bundle edkolev/tmuxline.vim

# Os specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
antigen bundles <<EOBUNDLES
  brew
  brew-cask
  gem
  osx
  sudo
  node
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

  # bd implementation in zsh
  Tarrasch/zsh-bd

  # Base-16 iTerm2
  chriskempson/base16-iterm2

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
source ~/.dotfiles/exports
source ~/.dotfiles/functions

# Command line helpers
if [[ -d "/usr/local/share/zsh-completions"  ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi

SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi

alias tmux='tmux -2'
alias ls='gls --color=always'

# TMUX - Autostart
# if [[ -z $TMUX ]]; then
  # # Attempt to discover a detached session and attach it, else create a new session
  # CURRENT_USER=$(whoami)
  # if tmux has-session -t $CURRENT_USER 2>/dev/null; then
    # tmux -2 attach-session -t $CURRENT_USER
  # else
    # tmux -2 new-session -s $CURRENT_USER
  # fi
# else
  # # If inside tmux session then print MOTD
  # MOTD=/etc/motd.tcl
  # if [ -f $MOTD ]; then
    # $MOTD
  # fi
# fi

# https://github.com/nvbn/thefuck
alias fuck='$(thefuck $(fc -ln -1))'

export NVM_DIR="/Users/alake/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
