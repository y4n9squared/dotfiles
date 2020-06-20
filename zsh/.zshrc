export EDITOR="hx"
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

# Create yy shell wrapper that provides ability to change current working
# directory upon exitig yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function pkill() {
  ps aux | fzf-tmux -p --reverse -w75% -h80% --prompt="Select process to kill: " | awk '{print $2}' | xargs -r sudo kill
}

function glog() {
    git lg | fzf-tmux -p --reverse -w75% -h80% --ansi --no-sort \
        --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % git show % --color=always' \
        --preview-window=right:50%:wrap --height 100% \
        --bind 'enter:execute(echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % sh -c "git show % | nvim -c \"setlocal buftype=nofile bufhidden=wipe noswapfile nowrap\" -c \"nnoremap <buffer> q :q!<CR>\" -")' \
        --bind 'ctrl-e:execute(echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs -I % sh -c "gh browse %")'
}


# Set up fzf key bindings and fuzzy completion
export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p -xC -yC -w80% -h75%"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!*_pb2*' -g '!*.pyi'"
export FZF_CTRL_T_COMMAND="rg --files --hidden -g'!*_pb2*' -g '!*.pyi'"
export FZF_ALT_C_COMMAND=
source <(fzf --zsh)


_fzf_complete_docker() {
  ARGS="$@"

  if [[ $ARGS == 'docker tag'* || $ARGS == 'docker run'* || $ARGS == 'docker push'* ]]; then
    _fzf_complete "--multi --header-lines=1" "$@" < <(
      docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}"
    )
  elif [[ $ARGS == 'docker rmi'* ]]; then
    _fzf_complete "--multi --header-lines=1" "$@" < <(
      docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}"
    )
  elif [[ $ARGS == 'docker build -t'* ]]; then
    _fzf_complete "--multi --header-lines=1 " "docker build . --build-arg POETRY_HTTP_BASIC_FGROVEP_USERNAME=aws --build-arg POETRY_HTTP_BASIC_FGROVEP_PASSWORD=\$(aws codeartifact get-authorization-token --domain-owner 815949584095 --domain fgrovep --query 'authorizationToken' --output text) -t " < <(
      docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}"
    )
  fi
}

_fzf_complete_docker_post() {
  # Post-process the fzf output to keep only the command name and not the explanation with it
  awk '{print $1}'
}

[ -n "$BASH" ] && complete -F _fzf_complete_docker -o default -o bashdefault docker


eval "$(starship init zsh)"

if (( $+commands[zoxide] )); then
  alias cd='z'
fi

if (( $+commands[eza] )); then
  alias ll='eza --icons -lab'
  alias lt='eza --icons -lab -T'
fi

if (( $+commands[bat] )); then
  alias cat='bat'
fi

alias tf='terraform'
alias k='kubecolor'
alias K='k9s'
alias vim='hx'
alias G='lazygit'
alias g='git'

alias top='bpytop'

source <(kubectl completion zsh)
source <(rpk generate shell-completion zsh)

eval "$(zoxide init zsh)"

# Automatically start tmux if not running
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux a || tmux
fi
