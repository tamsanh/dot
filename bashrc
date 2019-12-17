# http://bashrcgenerator.com/
# export PS1="\[\033[38;5;39m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# ls
alias ls="ls -G"
alias l="ls -l"
alias ll="ls -l"
alias lll="ls -l"

# git
alias g="git"
alias gg="git grep"
alias gpo="git push origin"
alias gco="git checkout"
alias gch="git checkout"
alias gcm="git commit -m"
alias gc="git commit"
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias gl="git pull origin"

function hlog {
  git log --date-order --all --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s" $@
}

alias hl="hlog"

export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL=
