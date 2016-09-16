FROM ubuntu:14.04
MAINTAINER Yegor <to.yegor@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        curl \
        git \
        libbz2-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        python-dev \
        python3-dev \
        vim \
        wget \
        xz-utils \
        zlib1g-dev \
        zsh

RUN useradd --create-home --shell $(which bash) yegor \
    && echo 'yegor:123' | chpasswd \
    && adduser yegor sudo
USER yegor
WORKDIR /home/yegor

# add vimrc
RUN git clone https://github.com/y3g0r/.dotfiles.git && ./.dotfiles/install.sh
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe \
    && cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive
RUN vim +PluginInstall +qall
RUN cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
ENV TERM=xterm-256color
CMD bash
