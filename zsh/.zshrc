
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
ENABLE_CORRECTION="true"

plugins=(
  git
  docker
  pass
)

[[ -r "$HOME/.zsh/z.sh" ]] && source $HOME/.zsh/z.sh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey \^U backward-kill-line
bindkey -s \^L 'clear && clear\n'

export SAVEHIST=500000
export EDITOR="nvim"
export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border'
export LESS="-F -X $LESS"

open () {xdg-open $* &}
alias o="open"

# pacman
alias i="sudo pacman -S"
alias s="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -r sudo pacman -S --noconfirm"
alias list_installed="comm -23 <(pacman -Qqett | sort) <(pacman -Qqg base -g base-devel | sort | uniq)"
alias r="sudo pacman -Rs"
alias u="sudo pacman -Syu && yay -Syu"

alias bc="bc -lq"
alias cat=bat
alias e="search"
alias k="killall"
alias psag="ps aux | grep"
alias python="$(which python3)"
alias reset_audio="systemctl status | grep \"/usr/bin/pulseaudio\" | grep -o \"[[:digit:]]\\+\" | head -1 | xargs kill -9"
alias sshap="ssh -p 58354 ryan@antoninus-pius.duckdns.org"
alias sw="telnet towel.blinkenlights.nl"
alias weather="curl wttr.in | grep -v @igor_chubin"
alias vim="$EDITOR"
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias tmuxrc="$EDITOR ~/.tmux.conf && tmux source-file ~/.tmux.conf"
alias swayrc="$EDITOR ~/.config/sway/config"
alias i3statusrc="$EDITOR ~/.config/i3status/config"
alias grd="./gradlew"

function lsA() {
  if [ $PWD = $HOME ];
  then
    ls
  else
    ls -A
  fi
}

function cd() {
  emulate -LR zsh
  builtin cd $@ && lsA
}

function pushd() {
  emulate -LR zsh
  builtin pushd $@ && lsA
}

function popd() {
  emulate -LR zsh
  builtin popd $@ && lsA
}

function mkcdir() {
  mkdir -p $1
  cd $1
}

unalias gco
function gco() {
  if [ $# -ne 0 ]; then
    git checkout $@
  else
    git branch | fzf | xargs git checkout
  fi
}

function gpp() {
  $(git push |& grep git)
}

function z() {
  _z 2>&1 $@
  if [ $# -ne 0 ]; then
    pwd
    lsA
  fi
}
alias z="z"

function bt() {
  rfkill unblock bluetooth
  bluetoothctl -- power on
  bluetoothctl --timeout 5 -- connect 00:FA:21:81:BB:0E
}
alias galaxy-buds="bt"

function bt-wh() {
  rfkill unblock bluetooth
  bluetoothctl -- power on
  bluetoothctl --timeout 5 -- connect 38:18:4C:BD:A0:65
}
alias sony="bt-wh"

function bak() {
  cp $1 $1.bak
}

cdpath=( ~/repos ~/school/2019fall ~/ctf )

function search() {
  vim +$(rg --line-number '.' | sed -e 's/:/ /; s/:/ /' | awk '{if ($2>20) { $2 = $2 " " $2-20} else { $2 = $2 " " 0}; print $0}' | fzf --height=100% --preview "bat -r {3}: --highlight-line {2} --style=numbers,changes --color always {1}" | awk '{print $2 " " $1}')
}

if [ -z "$TMUX" ]; then
  exec tmux
fi
