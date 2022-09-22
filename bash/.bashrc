#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias test='echo'
PS1='[\u@\h \W]\$ '
source '/Users/rgeary/src/awsaccess/awsaccess2.sh' # awsaccess
source '/Users/rgeary/src/awsaccess/oktaawsaccess.sh' # oktaawsaccess
export PS1="\$(ps1_mfa_context)$PS1" # awsaccess
