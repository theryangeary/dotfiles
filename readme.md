# My Dotfiles

Read for inspiration

## Deploying

GNU `stow` and `make` are needed in order to deploy

```
git clone --recurse-submodules git@github.com:theryangeary/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

## Conflicts

Stow will not overwrite files that already exist in the filesystem, and will
abort if such conflicts arise. They must be resolved manually.

## Testing

The [Dockerfile](./Dockerfile) can be used to test that deploying the dotfiles
works properly. It does not make such strong guarantees that your system will
work perfectly.
