export EDITOR="vim"
export CLICOLOR=1  # Enable terminal colors

HISTFILE=~/.cache/zsh/.zhistory   # Save history
HISTSIZE=2000
SAVEHIST=1000                   # Save the 1000 most recent commands

# Do not save these common commands into our history
HISTORY_IGNORE='([bf]g|cd|l[alsh]|less|vim|vim *|vi|vi *|exit|clear|z|tmux)'

# History Options
#
# http://zsh.sourceforge.net/Doc/Release/Options.html#History
setopt HIST_SAVE_NO_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY_TIME

set bell-style none  # diable beep

unsetopt nomatch  # make globbing work by default

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto --exclude-dir=.git'
    alias fgrep='fgrep --color=auto --exclude-dir=.git'
    alias egrep='egrep --color=auto --exclude-dir=.git'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

function activate() {
  local selected_env
  selected_env=$(ls ~/.venv/ | fzf-tmux -p --reverse)

  if [ -n "$selected_env" ]; then
    source "$HOME/.venv/$selected_env/bin/activate"
  fi
}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p -xC -yC -w80% -h75%"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!*_pb2*' -g '!*.pyi'"
export FZF_CTRL_T_COMMAND="rg --files --hidden -g'!*_pb2*' -g '!*.pyi'"

eval "$(starship init zsh)"

if (( $+commands[zoxide] )); then
  alias cd='z'
fi

if (( $+commands[exa] )); then
  alias ll='exa --icons -lab'
fi

if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
fi

alias tf='terraform'
alias k='kubecolor'
alias K='k9s'
alias vim='hx'
alias G='lazygit'

source <(kubectl completion zsh)
source <(rpk generate shell-completion zsh)

eval "$(zoxide init zsh)"
