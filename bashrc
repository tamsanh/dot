# http://bashrcgenerator.com/
# export PS1="\[\033[38;5;39m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;6m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# ls
alias ls="ls -G"
alias l="ls -l"
alias ll="ls -l"
alias lll="ls -l"

# git
alias g="git"
alias gr="git reset"
alias gg="git grep"
alias gpo="git push origin"
alias gch="git checkout"
alias gcm="git commit -m"
alias gc="git commit"
alias gca="git commit --amend"
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias gpl="git pull origin"
alias gst="git stash"
alias gsp="git stash pop"

# Open Pull Requests after creating new remote branches
# https://tighten.com/insights/open-github-pull-request-from-terminal/
function gpr() {
	github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/')
	branch_name=$(git symbolic-ref HEAD | cut -d"/" -f 3,4)
	pr_url=$github_url"/compare/main..."$branch_name
	open $pr_url
}

# Generate git ignore files
function gi {
	curl https://www.toptal.com/developers/gitignore/api/$1
}

function hlog {
	git log --date-order --all --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s" $@
}

alias hl="hlog"

# thefuck
which thefuck >/dev/null
if [ $? -e 0 ]; then
	eval $(thefuck --alias)
	alias lol="fuck -y"
else
	alias lol="echo please install thefuck"
fi

# LESS with color
alias lc="less -R"

# Paste buffer into jq
alias pbj="pbpaste | jq"

# View a json blob in the paste buffer using jq in color
alias pbjl="pbpaste | jq -C | less -R"

# Format an unformatted blob in the json buffer
alias pbjc="pbpaste | jq | pbcopy"
