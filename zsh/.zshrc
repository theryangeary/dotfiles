
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
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

NEWLINE=$'\n'
PROMPT="$PROMPT${NEWLINE}> "

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey \^U backward-kill-line
bindkey -s \^L 'clear && clear\n'

export SAVEHIST=500000
export EDITOR="nvim"
export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border'
export LESS="-F -X $LESS"

if [ $(uname) != "Darwin" ];
  then
    open () {xdg-open $* &}
fi
alias o="open"

# pacman
alias i="sudo pacman -S"
alias s="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -r sudo pacman -S --noconfirm"
alias list_installed="comm -23 <(pacman -Qqett | sort) <(pacman -Qqg base -g base-devel | sort | uniq)"
alias r="sudo pacman -Rs"
alias u="sudo pacman -Syu && yay -Syu"

alias bc="bc -lq"
alias cat=bat
alias d="docker"
alias dc="docker-compose"
alias e="search"
alias edit="$EDITOR"
alias k="killall"
alias psag="ps aux | grep"
alias reset_audio="systemctl status | grep \"/usr/bin/pulseaudio\" | grep -o \"[[:digit:]]\\+\" | head -1 | xargs kill -9"
alias sshap="ssh -p 58354 ryan@antoninus-pius.duckdns.org"
alias sw="telnet towel.blinkenlights.nl"
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias weather="curl wttr.in | grep -v @igor_chubin"
alias vim="$EDITOR"
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias tmuxrc="$EDITOR ~/.tmux.conf && tmux source-file ~/.tmux.conf"
alias swayrc="$EDITOR ~/.config/sway/config"
alias i3statusrc="$EDITOR ~/.config/i3status/config"
alias grd="./gradlew"
alias sleep="gsleep"

function after() {
    (sleep $1 && $@[2,-1])&
}
alias a="after"

function pomodoro() {
    after 25m say -a 73 -v Bubbles e e, e e
}
alias pom="pomodoro"

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

function gcll() {
  builtin pushd ~/src && git clone git@github.com:lyft/$1 && builtin popd
}

function gpp() {
  $(git push |& grep "git push")
}

function gpa() {
    gh pr review $1 --approve
}

function gdo() {
    set -x
    git add -u && git commit --message "$@" && git push
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
alias empid="echo 023968"

function bk() {
  cp $1 $1.bk
}

function ubk() {
  cp $1.bk $1
}

export description_file=~/.description.md

function _dynamex-create() {
  desc=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.stdin.read()))" < $description_file)
  emulate -LR zsh
  service_name=$1
  var=$2
  var_type=$3
  default_value=$4
  builtin cd ~/src/marketplaceconfig/data/$service_name
  git checkout master
  git reset --hard origin/master
  git clean -fd
  git pull
  branch="create-$var"
  git branch -D $branch
  git checkout -b $branch
  dynamex marketplaceconfig $service_name <<< "create $var $var_type $default_value"
  git add $var
  git commit -m "create $var"
  git push --set-upstream origin $branch
  gh pr create -F $description_file -f
  gh pr view --web
  git checkout master
  builtin cd -
}

function _dynamex-update() {
  desc=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.stdin.read()))" < $description_file)
  emulate -LR zsh
  service_name=$1
  var=$2
  env=$3
  value=$4
  region=$5
  builtin cd ~/src/marketplaceconfig/data/$service_name
  git checkout master
  git reset --hard origin/master
  git clean -fd
  git pull
  branch=$(branch_name $var $env $value $region)
  echo $branch
  git branch -D $branch
  git checkout -b $branch
  if [[ -z $region ]]
  then
    dynamex marketplaceconfig $service_name <<< "update $var $env $value"
  else
    echo $env
    if [ $env = "staging" ]
    then
      echo "override $var $env region $value --region $region"
      dynamex marketplaceconfig $service_name <<< "override $var $env region $value --region $region"
    else
      echo "update $var region $value --region $region"
      dynamex marketplaceconfig $service_name <<< "update $var region $value --region $region"
    fi
  fi
  git diff
  git add $var
  if [[ -z $region ]]
  then
    git commit -m "$env $value $var"
  else
    git commit -m "$region $value $var"
  fi
  git push --set-upstream origin $branch
  gh pr create -F $description_file -f
  gh pr view --web
  git checkout master
  builtin cd -
}

function branch_name() {
  var=$1
  env=$2
  value=$3
  region=$4
  if [[ -z $region ]]
  then
      echo "set-$var-$env-$value"
  else
      echo "set-$var-$env-$region-$value"
  fi
}

function dynamex_create() {
    vim $description_file
    service_name=$1
    var=$2
    var_type=$3
    value=$4
    _dynamex-create $service_name $var $var_type $value
}

function dynamex_update() {
    vim $description_file
    service_name=$1
    var=$2
    env=$3
    value=$4
    region=$5
    _dynamex-update $service_name $var $env $value $region
}

function rollout() {
  vim $description_file
  service_name=$1
  var=$2
  env=$3
  values=$4
  region=$5
  for value in $(echo ${values//,/ })
  do
    _dynamex-update $service_name $var $env $value $region
  done
  for value in $(echo ${values//,/ })
  do
    gh pr list --head $(branch_name $var $env $value $region) --json url | jq '.[0].url' | tr -d '"' | sed -e 's/^/gh pr review --approve /'
  done
}

function rollout_update() {
  emulate -LR zsh
  service_name=$1
  var=$2
  env=$3
  value=$4
  region=$5
  builtin cd ~/src/marketplaceconfig/data/$service_name
  git checkout master
  git reset --hard origin/master
  git clean -fd
  git pull
  branch=$(branch_name $var $env $value $region)
  git checkout $branch
  git rebase -Xtheirs origin/master
  git push --force-with-lease
  git checkout master
  builtin cd -
}

function pr() {
  vim $description_file
  desc=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.stdin.read()))" < $description_file)
  gpp
  gh pr create --web --assignee @me --body-file "${description_file}"
}

cdpath=( ~/src ~/repos ~/school/2019fall ~/ctf )

function search() {
  vim +$(rg --line-number '.' | sed -e 's/:/ /; s/:/ /' | awk '{if ($2>20) { $2 = $2 " " $2-20} else { $2 = $2 " " 0}; print $0}' | fzf --height=100% --preview "bat -r {3}: --highlight-line {2} --style=numbers,changes --color always {1}" | awk '{print $2 " " $1}')
}

export PATH="/opt/homebrew/opt/gnupg@2.2/bin:$PATH"

fpath+=${ZDOTDIR:-~}/.zsh_functions

eval "$(direnv hook zsh)"

if [ -z "$TMUX" ]; then
  exec tmux
fi
