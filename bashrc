CURR_DIR=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

# Vim as default
export VISUAL=vim
export EDITOR="$VISUAL"

# ls aliases
alias ls="ls --color=auto"
alias l="ls -l"
alias ll="ls -l"
alias lll="ls -l"

# hlog alias
function hlog {
  git log $@ --date-order --all --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s"
}

# virtualenv creator
# Creates a virtual environment for the current director inside of an env
# director

function vsrc {
  homedir=$(cd ~; pwd)
  c=`pwd | sed 's#'$homedir'/dev/##g'`
  vd=$homedir/dev/env/$c
  if [ -d $vd ]
  then
      source $homedir/dev/env/$c/bin/activate
  else
      mkdir -p $homedir/dev/env 2> /dev/null
      cd $homedir/dev/env
      virtualenv --python=python3 $c
      source $homedir/dev/env/$c/bin/activate
      cd -
  fi
  if [ -e env.sh ]
  then
      source env.sh
  fi
}

# gitignore creator
function gi() {
  query=`echo $@ | sed 's/ /%2C/g'`
  result=`curl --silent "https://www.gitignore.io/api/$query"`
  echo "$result"
}

# django shortcut
function dm {
  if [ -e "manage.py" ]
  then
    python manage.py $@
  else
    echo "Not a Django Project"
  fi
}

DNAME=tam-desc.json

# folder description
function d {
  dfile="$DNAME"
  if [ -z "$1" ]
  then
    if [ -e $dfile ]
    then
      cat $dfile | jq 1>&2
    else
      echo "No Description" 1>&2
    fi
  else
    if [ ! -e $dfile ]
    then
      echo "[]" > $dfile
    fi
    description="${@}"
    python3 -c "import json; f = open('$dfile'); rf=f.read(); f.close(); previousd = json.loads(rf); f = open('$dfile', 'w'); f.write(json.dumps(previousd + [{'date': '`date`', 'desc': '$description'}])); f.close();"
    cat $dfile | jq 1>&2
  fi
}

# last folder description
function lastd {
  dfile="$DNAME"
  if [ -e $dfile ]
  then
    cat $dfile | jq ".[-1]" 1>&2
  else
    echo "No Description" 1>&2
  fi
}

# Copy to clipboard
function cl {
  cat - | xclip -selection c
}

# Paste from clipboard
alias pl="xclip -o -selection c"

# Copy path to clipboard
function p {
  if [ -z "$1" ]
  then
    pwd | tr -d '\n' | cl
    echo `pl`
  else
    python3 -c "import os; print(os.path.join('`pwd`', '$1'))" | tr -d '\n' | cl
    echo `pl`
  fi
}


# Youtube-dl shortcut
alias you='youtube-dl -o "%(title)s -- %(uploader)s"'

# Upload to iOS VLC
function to_vlc {
  ios_url=${IOS_URL:-http://Tams-iPhone.local}
  curl -# -F file=@"$1" $ios_url/upload.json > /dev/null
}

# Download from YouTube, Upload to VLC
function youvlc {
  youtube_url="$1"
  tempdir=`mktemp -d`
  cd $tempdir
  you $youtube_url
  if [ "$?" -ne 0 ]
  then
    echo "Error Downloading Occured" 1>&2
    exit 1
  fi
  for filename in *;
  do
    echo "Uploading '$filename' to iOS VLC..." 1>&2
    to_vlc "$filename"
    if [ "$?" -ne 0 ]
    then
      echo "Error Uploading Occured" 1>&2
      exit 1
    fi
  done
  cd - 2>&1 > /dev/null
  rm -r $tempdir
  echo "Completed Upload of '$filename' to iOS VLC." 1>&2
}

# Vim Alias
alias v='vim'

# Vim Edit Alias
alias vv="vim $CURR_DIR/vimrc"

# Bash Reload Alias
alias sb='source ~/.bashrc'

# Bash Edit Alias
alias vb="vim $CURR_DIR/bashrc"

# Git Aliases
alias g='git'
alias gc='g commit'
alias gcm='g commit -m'
alias gch='g checkout'
alias gd='g diff'
alias ga='g add'
alias gg='g grep'
alias gl='g log'
alias gs='g diff --stat && g status --short | grep "??"'
alias hl='hlog'

# Ruby Version Manager
source ~/.rvm/scripts/rvm
