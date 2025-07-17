export ZSH="$HOME/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
ENABLE_CORRECTION="true"
DISABLE_AUTO_UPDATE="true"

plugins=(
  git
  docker
)

[[ -r "$HOME/.zsh/z.sh" ]] && source $HOME/.zsh/z.sh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

CORRECT_IGNORE="*./..."

bindkey \^U backward-kill-line
bindkey -s \^L 'clear && clear\n'

export SAVEHIST=500000
export EDITOR="nvim"
export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border'
export LESS="-F -X $LESS"

if [ $(uname) != "Darwin" ]; then
    open () {xdg-open $* &}
fi
alias o="open"

if [ $(uname) = "Linux" ]; then
    # pacman
    alias i="sudo pacman -S"
    alias s="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -r sudo pacman -S --noconfirm"
    alias list_installed="comm -23 <(pacman -Qqett | sort) <(pacman -Qqg base -g base-devel | sort | uniq)"
    alias r="sudo pacman -Rs"
    alias u="sudo pacman -Syu && yay -Syu"
fi

alias bc="bc -lq"
alias cat=bat
alias claude="/Users/ryan/.claude/local/claude"
alias d="docker"
alias dc="docker-compose"
alias e="search"
alias edit="$EDITOR"
alias go="nocorrect go"
alias k="killall"
alias psag="ps aux | grep"
alias reset_audio="systemctl status | grep \"/usr/bin/pulseaudio\" | grep -o \"[[:digit:]]\\+\" | head -1 | xargs kill -9"
alias sshap="ssh -p 58354 ryan@antoninus-pius.duckdns.org"
alias sw="telnet towel.blinkenlights.nl"
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias weather="curl wttr.in | grep -v @igor_chubin"
alias grd="./gradlew"
alias sleep="gsleep"

alias vim="$EDITOR"
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias tmuxrc="$EDITOR ~/.tmux.conf && tmux source-file ~/.tmux.conf"
alias swayrc="$EDITOR ~/.config/sway/config"
alias i3statusrc="$EDITOR ~/.config/i3status/config"
alias alacrittyrc="$EDITOR ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml"

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

cdpath=( $SRC ~/src ~/repos ~/.talon/user )

function search() {
  vim +$(rg --line-number '.' | sed -e 's/:/ /; s/:/ /' | awk '{if ($2>20) { $2 = $2 " " $2-20} else { $2 = $2 " " 0}; print $0}' | fzf --height=100% --preview "bat -r {3}: --highlight-line {2} --style=numbers,changes --color always {1}" | awk '{print $2 " " $1}')
}

if [ -f ~/.zshrc_lyft ]; then
    source ~/.zshrc_lyft
fi

eval "$(starship init zsh)"

if [ -z "$TMUX" ] && [ $TERM_PROGRAM != "vscode" ]; then
    tmux attach -t $(tmux list-sessions -F "#S #{session_attached}" | grep -E "(\d+) 0" | cut -d ' ' -f 1) || exec tmux new-session && exit;
fi

declare -A z_auto_fzf=(
    [buffer]="z"
    [opts_cmd]="z 2>/dev/null | sort -rn | choose -1 | choose -f / -1"
    [fzf_cmd]="fzf --height=40% --no-sort"
)
declare -A gco_auto_fzf=(
    [buffer]="gco"
    [opts_cmd]="git branch"
    [fzf_cmd]="fzf --height=40%"
)

declare -a auto_fzf=(
    z_auto_fzf
    gco_auto_fzf
)

z-fzf-enhanced-widget() {
    local current_buffer="$BUFFER"
    local cursor_pos="$CURSOR"

    for af in $auto_fzf; do
        local -A entry=("${(Pkv@)af}")
        if [[ "$current_buffer" == "${entry[buffer]}" && "$cursor_pos" -eq ${#entry[buffer]} ]]; then
            # Get directories, handling different possible z outputs
            local opts
            # N.B. this assumes the prefix is a valid command in its own right
            if command -v ${entry[buffer]} >/dev/null 2>&1; then
                opts=$(eval "${entry[opts_cmd]}")
            else
                echo "opt command not found"
                break
            fi

            # Check if we got any directories
            if [[ -z "$opts" ]]; then
                echo "No inputs found"
                BUFFER=""
                CURSOR=0
                zle reset-prompt
                return
            fi

            # Use fzf with better options
            local fzf_selection=$(echo "$opts" | eval "${entry[fzf_cmd]}")

            if [[ -n "$fzf_selection" ]]; then
                BUFFER="${BUFFER} $fzf_selection"
                CURSOR=${#BUFFER}
                zle accept-line
            fi

            zle reset-prompt
        fi
    done

    # failure case - treat space as normal input. this means our success case MUST return early
    # Insert regular space
    BUFFER="${BUFFER} "
    CURSOR=$((CURSOR + 1))
}

# Uncomment the following lines to use the enhanced version instead:
zle -N z-fzf-enhanced-widget
bindkey ' ' z-fzf-enhanced-widget
