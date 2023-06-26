alias ls="ls -G"
alias lll="ls -la"
alias ll="ls -la"
alias l="ls -la"
if [ -f ~/.dot-files/.git-completion.bash ]; then
    . ~/.dot-files/.git-completion.bash
fi
set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    # Add a bright white exit status for the last command
    PS1="$White\$? "
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Checkmark "
    else
        PS1+="$Red$FancyX "
    fi
    PS1+="$White\@ "
    ## If root, just print the host in red. Otherwise, print the current user
    ## and host in green.
    #if [[ $EUID == 0 ]]; then
    #    PS1+="$Red\\h "
    #else
    #    PS1+="$Green\\u@\\h "
    #fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Blue\\w$Reset "
    PS1+='$(b=$(git branch 2>/dev/null| grep \* | cut -c 3-);\
    if [ $? -eq 0 ]; then \
      echo "$(echo `git status 2>/dev/null` | grep "nothing to commit" > /dev/null 2>&1; \
      if [ "$?" -eq "0" ]; then \
        # @4 - Clean repository - nothing to commit
        echo "'$Green'"$b; \
      else \
        # @5 - Changes to working tree
        echo "'$Red'"$b; \
      fi) '$Reset$Yellow$Reset'\$ "; \
    else \
      # @2 - Prompt when not in GIT repo
      echo "'$Reset$Yellow$Reset'\$ "; \
    fi)'
}
PROMPT_COMMAND='set_prompt'

alias hlog='git log --date-order --all --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s"'
alias xlog='git log --date-order --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s"'
alias gw='./gradlew'

export PATH=$PATH:/usr/local/bin/
export PATH=$PATH:/Users/tamn/BASH_PATH/
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/

alias ent='tree -C | less -R'
