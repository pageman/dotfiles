#!/usr/bin/env bash
export PATH="/usr/local/bin:$PATH"
source ~/.paths

export GIT_EDITOR='emacsclient -s server'
export EDITOR=$GIT_EDITOR

git-on-branch () {
    git stash
    ORIGINAL_BRANCH=`git branch | grep \* | sed 's/\*[[:space:]]//'`
    git checkout $1
    $2
    git checkout $ORIGINAL_BRANCH
    git stash pop
}

alias vesh="cd ~/vagrant-environment/apangea; vagrant ssh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

shopt -s extglob

function aalias {
    mkdir -p ~/.bash_it/custom/
    echo "alias ${1}='${@:2}'" >> ~/.bash_it/custom/aliases.bash
    source ~/.bash_it/custom/aliases.bash
}

function on-branch {
    local original_branch=$(git branch | sed -n '/\* /s///p')
    git checkout $1 && \
        bash && \
        git checkout $original_branch
}
