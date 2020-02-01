# screen
export TERM="xterm-256color"
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$HOME/bin:$PATH
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time virtualenv)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

POWERLEVEL9K_MODE='nerdfont-complete'
# google cloud platform
#export GOOGLE_APPLICATION_CREDENTIALS="/Users/dylanchi/dev/auto-tagging/cw-it-lab-service_account.json"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
###############
##   alias   ##
###############
# ssh into cw-it-auto-tagging gce
alias dkn='docker ps -a --format="{{.Names}}"'
alias din='docker images --format="{{.Repository}}"'
alias lzd='lazydocker'
#######################
##  coding settings  ##
#######################
export PATH=$HOME/.composer/vendor/bin:$PATH

# download google drive using hash
# usage: gdload <google drive file id> <tofile.ext>
function gdload () {
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}
export EDITOR=vim
export VISUAL="$EDITOR"
