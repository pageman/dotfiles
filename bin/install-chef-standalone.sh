#!/bin/bash

curl -LO https://www.opscode.com/chef/install.sh
sudo bash install.sh
rm -rf install.sh
sudo chown joel:staff -R /opt/chef
/opt/chef/embedded/bin/gem install librarian-chef
/opt/chef/embedded/bin/gem install knife-solo
/opt/chef/embedded/bin/gem install knife-solo_data_bag
