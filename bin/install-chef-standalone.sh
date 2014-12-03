#!/bin/bash

if [ "$DOTFILES_TEST" == "true" ];
then
    function sudo_fn {
        echo vagrant | sudo -S "$@"
    }
else
    function sudo_fn {
        sudo "$@"
    }
fi

curl -LO https://www.opscode.com/chef/install.sh
sudo_fn bash install.sh
rm -rf install.sh
sudo_fn bash -c 'chown -R $SUDO_USER:staff /opt/chef/*'
