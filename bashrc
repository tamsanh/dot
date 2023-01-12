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
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/main..."$branch_name
  open $pr_url;
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
eval $(thefuck --alias)
alias lol="fuck -y"

# fix mac repeat keys
# defaults write -g ApplePressAndHoldEnabled -bool false

alias imi="iex -S mix"

alias gw="./gradlew"

# Less with colors
alias lr="less -R"

# Paste buffer into jq
alias pbj="pbpaste | jq"

# View a json blob in the paste buffer using jq
alias pbjl="pbpaste | jq -C | less -R"

# Format an unformatted blob in the json buffer
alias pbjc="pbpaste | jq | pbcopy"

# Convert a pascalcase json blob into a snakec ase json blob
function pascal_to_snake {
    cat - | python -c """
from typing import Dict, Any

from string import ascii_uppercase

_upper_chars = set(ascii_uppercase)


def _pascal_to_snake(pascal_case: str) -> str:
    out = [pascal_case[0]]
    prev_cap = False
    for c in pascal_case[1:]:
        if c in _upper_chars and not prev_cap:
            out.append('_')
            prev_cap = True
        if c not in _upper_chars:
            prev_cap = False
        out.append(c)
    return ''.join(out).lower()


def pascal_dict_to_snake_dict(d: Dict[str, Any]) -> Dict[str, Any]:
    def _handle_value(value):
        if type(value) is dict:
            return pascal_dict_to_snake_dict(value)
        elif type(value) is list:
            return [_handle_value(val) for val in value]
        return value

    return {_pascal_to_snake(k): _handle_value(v) for k, v in d.items()}

if __name__ == '__main__':
    import sys
    import json
    data = sys.stdin.read()
    d = json.loads(data)
    print(json.dumps(pascal_dict_to_snake_dict(d), indent=2))
"""
}
