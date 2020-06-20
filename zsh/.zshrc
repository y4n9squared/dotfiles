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
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY_TIME

set bell-style none  # diable beep

unsetopt nomatch  # make globbing work by default

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

if (( $+commands[fzf] )); then
  # Set up fzf key bindings and fuzzy completion
  export FZF_CTRL_R_OPTS="--reverse"

  export FZF_CTRL_T_OPTS="
    --walker-skip .git,__pycache__
    --preview 'cat -n {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  export FZF_TMUX_OPTS="-p -xC -yC -w80% -h75%"
  export FZF_ALT_C_COMMAND=

  # Options for path completion (e.g. vim **<TAB>)
  export FZF_COMPLETION_PATH_OPTS="
    --walker file,dir,follow,hidden
    --walker-skip .git,__pycache__
    --preview 'cat -n {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # Options for directory completion (e.g. cd **<TAB>)
  export FZF_COMPLETION_DIR_OPTS="
    --walker dir,follow
    --walker-skip .git,__pycache__"

  source <(fzf --zsh)

  if (( $+commands[docker] )); then
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
  fi
fi

if (( $+commands[brew] )); then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# Must be called after FPATH is fully built
autoload -U +X compinit && compinit

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[zoxide] )); then
  alias cd='z'
  eval "$(zoxide init zsh)"
fi

if (( $+commands[eza] )); then
  alias ll='eza --icons -lab'
  alias lt='eza --icons -lab -T'
fi

if (( $+commands[btop] )); then
  alias top='btop'
fi

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
fi

if (( $+commands[rpk] )); then
  source <(rpk generate shell-completion zsh)
fi

source ~/.config/op/plugins.sh

. "$HOME/.local/bin/env"
