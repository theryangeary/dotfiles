targets := $(shell find . -mindepth 1 -maxdepth 1 -type d | choose -f / 1 | grep -v .git)

default: $(targets)

list:
	echo $(targets)

$(targets):
	stow $@

vim:
	stow vim
	pip3 install neovim
	gem install --user neovim
	npm install neovim

tmux:
	stow tmux
	tmux new '~/.tmux/plugins/tpm/bin/install_plugins'

.PHONY: $(targets)
