#!/bin/bash


set -e
set -u
set -o pipefail


inst() {

    echo cding to script dir..
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $SCRIPT_DIR
    
    echo opening dmg
    open Emacs-pretest-24.0.94-universal-10.6.8.dmg 
    echo done opening dmg...
    
    echo sleeping for 5 secs so that volume can finish up and dont get a no such dir errorx..
    sleep 5
    
    cd /Volumes/Emacs/
    
    
    echo copying emacs into /Applications/
    cp -r Emacs.app /Applications/
    cd -
    
    
    echo unmounting dmg
    umount /Volumes/Emacs/


    echo now verifying or adding stuff for dot profile...


    # make sure that .profile exists...
    touch ~/.profile
    
    if grep "#AUTOMATICALLY INSERTED EMACS INSTALL LINES" ~/.profile; then
	      echo 'found inserted content for profile '
	      echo 'remove and rerun if you think that this should be changed'
    else
	      echo 'did not find content, adding to profile'

	      cat >> ~/.profile <<EOF

#AUTOMATICALLY INSERTED EMACS INSTALL LINES
# dont edit any of this mannually. Well, you could, but if you do, 
# the script that put it here wont know anything about it

# add "Emacs" to path
export PATH=/Applications/Emacs.app/Contents/MacOS:\$PATH

# add alias for easier stuff 
alias emacs=Emacs

# add other stuff, like emacsclient to path
export PATH=/Applications/Emacs.app/Contents/MacOS/bin:\$PATH

# set editor to emacs..
export EDITOR=emacs

#here ends automatically inserted line
EOF
	
    fi;
	
	
}



undo_inst(){
    echo rming emacs app
    rm -r /Applications/Emacs.app
}


case $1 in 

    install)
	      inst
	      ;;

    undo_install)
	      undo_inst
	      ;;

    *)
	      inst
	      ;;
esac;
