# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export SCREENSHOT_PREFIX="/tmp/screenshot-"

export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

export BEMENU_OPTS="-l 20 -p '' -n -i --fn 'Source Code Pro 12'"

#export XDG_RUNTIME_DIR="/tmp"
export XDG_RUNTIME_DIR="/tmp/xdg_runtime_dir"
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes cargo bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes gem if it exists for vimgolf
if [ -d "$HOME/.gem/ruby/2.7.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
fi

# set PATH so it includes flamegraph if it exists
if [ -d "$HOME/repos/flamegraph" ] ; then
  export PATH="$HOME/repos/flamegraph:$PATH"
fi

dbus-update-activation-environment DISPLAY XAUTHORITY
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  sway
fi
