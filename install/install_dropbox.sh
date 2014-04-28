#!/bin/bash


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR




inst (){
    test -e dropbox.dmg || {
        wget -O dropbox.dmg http://www.dropbox.com/download?plat=mac
    }
    open dropbox.dmg
    cd /Volumes/Dropbox\ Installer/
    cp -r Dropbox.app /Applications/
    umount /Volumes/Dropbox\ Installer/
}


case $1 in
    clean)
        # dont really want to remove this..
        #rm dropbox.dmg
        ;;

    install)
        inst
        ;;

    *)
        inst
        ;;
esac;


