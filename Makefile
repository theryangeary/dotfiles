default: stow vim

stow:
	find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	  | grep -v .git \
	  | xargs stow

vim:
	stow vim
	vim -c 'VundleInstall' -c 'qa'

.PHONY: stow vim
