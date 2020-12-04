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

# PATH Settings

### Antibody Configuration

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
  antibody bundle < ~/.dotfiles/zsh_plugins_osx.txt
  PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

elif [[ $CURRENT_OS == 'Linux' ]]; then
  if [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  fi
  alias ll='ls -l'
  alias l='ls -la'
  alias ls='ls --color=always'
  if [[ $DISTRO == 'CentOS' ]]; then
    antibody bundle centos
  fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
  antibody bundle cygwin
fi

# Load Antibody
source <(antibody init)
ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
antibody bundle < ~/.dotfiles/zsh_plugins.txt

if [[ -d ~/.bash-my-aws ]]; then
  autoload bashcompinit
  bashcompinit
  source ~/.bash-my-aws/aliases
  source ~/.bash-my-aws/bash_completion.sh
fi

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	autoload -Uz compinit
	compinit
fi
DISABLE_AUTO_UPDATE=true

# Powerline Go
  function powerline_precmd() {
    PS1="$(powerline-go -error $? -shell zsh -modules "venv,user,host,ssh,node,docker,kube,aws,cwd,perms,git,jobs,exit,root")"
  }

  function install_powerline_precmd() {
    for s in "${precmd_functions[@]}"; do
      if [ "$s" = "powerline_precmd" ]; then
        return
      fi
    done
    precmd_functions+=(powerline_precmd)
  }

  if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
  fi

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

if [[ $(command -x lsd) ]] ; then
  alias ls='lsd'
  alias ll='ls -l'
  alias l='ls -la'
elif [[ -a /usr/local/bin/gls ]] ; then
  alias ls='gls --color=always'
fi

# https://github.com/nvbn/thefuck
alias fuck='$(thefuck $(fc -ln -1))'

# Initialize anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH=$HOME/.anyenv/bin:$PATH
  eval "$(anyenv init - zsh)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# Initialize goenv
if [ -d $HOME/.goenv ] ; then
  export GOENV_ROOT="$HOME/.goenv"
  export GOPATH=$HOME/go/bin
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  export GOROOT="/home/alake/go/$(goenv version | awk {'print $1'})"
  PATH=$HOME/bin:$PATH:/usr/local/opt/go/libexec/bin:$GOPATH
fi

# history management
setopt inc_append_history
setopt share_history

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# Enable `aws` tab completion
if [ -x /home/linuxbrew/.linuxbrew/bin/aws_completer ]; then
  complete -C '/home/linuxbrew/.linuxbrew/bin/aws_completer' aws
fi
