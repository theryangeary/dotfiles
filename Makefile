default: stow vim tmux

stow:
	find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	  | grep -v .git \
	  | xargs stow

vim:
	stow vim
	vim -c 'VundleInstall' -c 'qa'

tmux:
	stow tmux
	tmux new '~/.tmux/plugins/tpm/bin/install_plugins'

.PHONY: stow vim tmux
