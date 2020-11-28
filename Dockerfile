# test this repo against an install on ubuntu
FROM ubuntu

# install dependencies
RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y \
    git \
    gcc \
    libncurses5-dev \
    make \
    stow

# install most current vim
RUN git clone http://github.com/vim/vim.git && cd vim && cd src && make && make install

# create a non-root user for a more typical /home directory structure
RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

# remove conflicting files, users will need to sort them themselves
RUN rm .bashrc

# get sources
RUN git clone --recurse-submodules http://github.com/theryangeary/dotfiles
WORKDIR dotfiles

# stow dotfiles
RUN make
