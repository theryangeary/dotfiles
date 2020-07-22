# My Dotfiles

Read for inspiration

## Deploying

GNU stow is needed in order to deploy

```
git clone git@github.com:theryangeary/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
stow *
```
