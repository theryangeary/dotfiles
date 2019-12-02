
export ZSH="/home/ryan/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
ENABLE_CORRECTION="true"

plugins=(
	git
	docker
	pass
	zsh-autosuggestions
	zsh-syntax-highlighting
)

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

bindkey \^U backward-kill-line
bindkey -s \^L 'clear && clear\n'

export SAVEHIST=500000
export EDITOR="nvim"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

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
alias docker="sudo docker"
alias gp!="$(gp |& grep git)"
alias k="killall"
alias python="$(which python3)"
alias reset_audio="systemctl status | grep \"/usr/bin/pulseaudio\" | grep -o \"[[:digit:]]\\+\" | head -1 | xargs kill -9"
alias sshap="ssh -p 58354 ryan@antoninus-pius.duckdns.org"
alias sw="telnet towel.blinkenlights.nl"
alias weather="curl wttr.in | grep -v @igor_chubin"
alias vim="nvim"
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias tmuxrc="$EDITOR ~/.tmux.conf && tmux source-file ~/.tmux.conf"
alias swayrc="$EDITOR ~/.config/sway/config"
alias i3statusrc="$EDITOR ~/.config/i3status/config"

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

function z() {
  _z 2>&1 $@
  if [ $# -ne 0 ]; then
    pwd
    lsA
  fi
}
alias z="z"

cdpath=( ~/repos ~/school/2019fall ~/ctf )

if [ -z "$TMUX" ]; then
  exec tmux
fi
