targets := $(shell find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -v .git)

default: $(targets)

$(targets):
	stow $@

vim:
	stow vim
	vim -c 'VundleInstall' -c 'qa'
	pip3 install neovim
	gem install --user neovim
	npm install neovim

tmux:
	stow tmux
	tmux new '~/.tmux/plugins/tpm/bin/install_plugins'

.PHONY: $(targets)
