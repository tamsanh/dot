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
  git log --date-order --all --graph --format="%C(green)%h %Creset%C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset %s"
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

# folder description
function d {
  dname=.tam-description.json
  dfile="$1/$dname"
  if [ -z "$2" ]
  then
    if [ -e $1 ] && [ -d $1 ]
    then
      if [ -e $dfile ]
      then
        cat $dfile | jq 1>&2
      else
        echo "No Description" 1>&2
      fi
    else
      echo "$1 is not a directory" 1>&2
    fi
  else
    if [ ! -e $dfile ]
    then
      echo "[]" > $dfile
    fi
    python3 -c "import json; f = open('$dfile'); rf=f.read(); f.close(); previousd = json.loads(rf); f = open('$dfile', 'w'); f.write(json.dumps(previousd + [{'date': '`date`', 'desc': '$2'}])); f.close();"
    cat $dfile | jq 1>&2
  fi
}

