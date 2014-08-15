#!/bin/bash

set -e


function debug
{
    if [ "$DEBUG" == "true" ] ;
    then
        echo DEBUG: $1
    fi
}


dotfiles_dir=${DOTFILES_DIR:-~/dotfiles}

if [ -d "$dotfiles_dir" ]; then
    echo "Error: Dotfiles directory already exists"
    exit 1
fi

tmpdir=`mktemp -d /tmp/install-dotfiles.XXXX`

debug $tmpdir

cd $tmpdir

curl -LO https://github.com/joelmccracken/dotfiles/archive/${1:-master}.zip

unzip master.zip

debug successfully unzipped


mv dotfiles-master $dotfiles_dir


echo Done! You are now ready to run the chef installer.
