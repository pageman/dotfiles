#!/bin/bash




echo verify that emacs exists

test -n "`which emacs`" || {
    echo no emacs
    exit 1
}


emacs --version | grep 'Emacs 24.*' > /dev/null || {
    echo emacs reports wrong version
    exit 2
}



echo emacs successfully verified
echo emacs should work successfully on system according to test

exit 0
