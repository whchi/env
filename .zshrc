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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
###############
##   alias   ##
###############
alias dkn='docker ps -a --format="{{.Names}}"'
alias din='docker images --format="{{.Repository}}"'
alias drm='docker ps -a | grep Exit | cut -d " " -f 1 | xargs docker rm'
alias drmi='docker rmi $(docker images -f "dangling=true" -q)'
alias drmv='docker volume rm $(docker volume ls -qf dangling=true)'
alias lzd='lazydocker'
alias minienv='eval $(minikube docker-env)'
alias minienvexit='eval $(minikube docker-env -u)'
alias kc="kubectl"
alias kca="kubectl apply"
alias kcA="kubectl attach"
alias kcaf="kubectl apply -f"
alias kcaF="kubectl apply -R -f"
alias kcC="kubectl config"
alias kcc="kubectl create"
alias kcD="kubectl delete"
alias kcd="kubectl describe"
alias kce="kubectl edit"
alias kcg="kubectl get"
alias kcl="kubectl logs"
alias kcp="kubectl port-forward"
alias kcP="kubectl proxy"
alias kcr="kubectl run"
alias kcx="kubectl exec"
alias kcX="kubectl expose"

# download google drive using hash
# usage: gdload <google drive file id> <tofile.ext>
function gdload () {
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}
# delete images using prefix
# usage: drmis <prefix> [-f]
function drmis() {
  docker rmi $2 $(docker images | grep '^'$1 | tr -s ' ' | cut -d ' ' -f 3)
}

export EDITOR=vim
export VISUAL="$EDITOR"
