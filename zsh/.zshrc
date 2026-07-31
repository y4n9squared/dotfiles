export EDITOR="hx"
export CLICOLOR=1  # Enable terminal colors
export COLORTERM=truecolor
export PGPASSFILE=~/.config/postgresql/.pgpass
export PYTHON_HISTORY=~/.cache/python/.python_history

HISTFILE=~/.cache/zsh/.zhistory   # Save history
HISTSIZE=10000
SAVEHIST=10000                   # Save the 10000 most recent commands

# Do not save these common commands into our history
HISTORY_IGNORE='([bf]g|cd|cd *|l[alsht]|l[alsht] *|less|hx|hx *|vim|vim *|vi|vi *|nvim|nvim *|exit|clear|z|tmux)'

# History Options
#
# http://zsh.sourceforge.net/Doc/Release/Options.html#History
setopt HIST_SAVE_NO_DUPS HIST_NO_FUNCTIONS HIST_NO_STORE HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST

unsetopt beep nomatch  # no bell; unmatched globs pass through

# Make Ctrl-U work like bash
bindkey \^U backward-kill-line

if (( $+commands[fzf] )); then
  # Set up fzf key bindings and fuzzy completion
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
fi

# Must be called after FPATH is fully built
fpath+=~/.zfunc
autoload -U compinit && compinit

zstyle ':completion:*' menu select

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

if (( $+commands[btop] )); then
  alias top='btop'
fi

alias cloc='cloc --quiet --hide-rate --by-file'
alias k='kubectl'
alias ll='eza --icons -lab'
alias lt='eza --icons -lab -T --git-ignore'
alias tf='terraform'

if (( $+commands[atuin] )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi
