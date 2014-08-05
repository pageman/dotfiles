#!/bin/bash

# include reset environment code
# necessary for the chef-version of ruby not to
# be confused about locations of files,
# at least on my system. YMMV
unset GEM_HOME
unset GEM_PATH

# make sure to put the omnibus-installed version of chef at
# the front of the path
PATH="/opt/chef/bin:/opt/chef/embedded/bin:$PATH"

if [[ "$EDB_SECRET" != "" && -f "$EDB_SECRET" ]]; then
  ln -s "$EDB_SECRET" ./encrypted_data_bag_secret
fi

/opt/chef/bin/chef-solo -c solo.rb -j bootstrap.json $@

/opt/chef/embedded/bin/librarian-chef install --verbose
/opt/chef/bin/chef-solo -c solo.rb -j solo.json $@
chown -R $SUDO_USER:staff ./*
