#!/usr/bin/env bash
export PATH="/usr/local/bin:$PATH"
# add emacs
export PATH=/Applications/Emacs.app/Contents/MacOS:$PATH
# add emacsclient, etc
export PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/bin:$PATH
export PATH=~/dotfiles/backup/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="/Users/joel/.cask/bin:$PATH"
export PATH="/Users/joel/Dropbox/Projects/emacs-js/emsdk_portable:/Users/joel/Dropbox/Projects/emacs-js/emsdk_portable/clang/3.2_64bit/bin:/Users/joel/Dropbox/Projects/emacs-js/emsdk_portable/node/0.10.18_64bit /bin:/Users/joel/Dropbox/Projects/emacs-js/emsdk_portable/emscripten/1.7.1:$PATH"

# export PATH="/Users/joel/.rvm/gems/ruby-1.9.3-p327-falcon/bin:$PATH"
export PATH="/usr/local/Cellar/ruby20/2.0.0-p481/bin:$PATH"

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


function alerts_prompt {
    cat ~/var/alerts/number
}

function alerts {
    cat ~/var/alerts/alerts
}

function jnm_prompt_command {
    PS1="\n$(alerts_prompt) ${yellow}$(ruby_version_prompt) ${purple}\h ${reset_color}in ${green}\w\n${bold_cyan}$(scm_char)${green}$(scm_prompt_info) ${green}→${reset_color} "
}
PROMPT_COMMAND=jnm_prompt_command;
