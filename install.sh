#!/bin/sh

rm -rf ~/.vim \
       ~/.vimrc \
       ~/.bashrc \
       ~/.bash_profile \
       ~/.bash_logout \
       ~/.bash_history \
       ~/.profile \
       ~/.tmux \
       ~/.tmux.conf \
       ~/.gitconfig \
       ~/.gitignore \
       ~/.zsh \
       ~/.zshrc \
       ~/.zshenv \
       ~/.zprofile \
       ~/.zcompdump \
       ~/.gdbinit

ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore ~/.gitignore
ln -sf ~/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

mkdir -p ~/.zsh
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
