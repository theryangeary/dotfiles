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
#export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

export BEMENU_OPTS="-l 20 -p '' -n -i --fn 'Source Code Pro 12'"
export BAT_THEME="Solarized (light)"

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

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

# set PATH so it includes gem if it exists
if [ -d "$HOME/.gem/ruby/2.5.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"
fi

# set PATH so it includes gem if it exists
if [ -d "$HOME/.gem/ruby/2.6.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
fi

# set PATH so it includes gem if it exists for vimgolf
if [ -d "$HOME/.gem/ruby/2.7.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
fi

# set PATH so it includes flamegraph if it exists
if [ -d "$HOME/repos/flamegraph" ] ; then
  export PATH="$HOME/repos/flamegraph:$PATH"
fi

if [ -d "$HOME/.poetry/bin" ] ; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
  export PATH="$HOME/go/bin:$PATH"
fi

if [ -d "$HOME/../linuxbrew" ] ; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [ -f "/opt/homebrew/bin/brew" ] ; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

##
# Your previous /Users/rgeary/.zprofile file was backed up as /Users/rgeary/.zprofile.macports-saved_2022-07-08_at_09:37:01
##

# MacPorts Installer addition on 2022-07-08_at_09:37:01: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2022-07-08_at_09:37:01: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.

