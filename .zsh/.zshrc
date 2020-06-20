export CLICOLOR=1  # Enable terminal colors

HISTFILE=~/.cache/zsh/.zhistory   # Save history 
HISTSIZE=2000
SAVEHIST=1000                   # Save the 1000 most recent commands

# Do not save these common commands into our history
HISTORY_IGNORE='([bf]g *|cd|cd *|l[alsh]#( *)#|less *|vim# *)'

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

# Enable reverse history search. Not enabled in zsh by default
bindkey -e
bindkey '^R' history-incremental-search-backward

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

alias nbstrip="jq --indent 1 \
    '(.cells[] | select(has(\"outputs\")) | .outputs) = []  \
    | (.cells[] | select(has(\"execution_count\")) | .execution_count) = null  \
    | .metadata = {\"language_info\": {\"name\": \"python\", \"pygments_lexer\": \"ipython3\"}} \
    | .cells[].metadata = {} \
    '"

alias dotconfig='git --git-dir=${HOME}/dotfiles/ --work-tree=$HOME'

# If we detect 'hub' on our PATH, alias 'git' to it.
HUB=$(command -v hub)
if [[ ! -z $HUB ]]; then
  eval "$(hub alias -s)"
fi

fpath+=("${ZDOTDIR}/pure")

# Enable pure prompt
autoload -U promptinit; promptinit
prompt pure

fpath+=("${ZDOTDIR}/completions")

# Enable zsh completions
autoload -Uz compinit && compinit -d ~/.cache/zsh/.zcompdump

mkdir -p ~/.cache/zsh
_Z_DATA=~/.cache/zsh/.z
source "${ZDOTDIR}/z.sh"
