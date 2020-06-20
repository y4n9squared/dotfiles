export ZDOTDIR="${HOME}/.zsh"

export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=0

PATH="${PATH}:${HOME}/.venv/conan/bin"
PATH="${PATH}:${HOME}/.venv/aws/bin"

export PATH
