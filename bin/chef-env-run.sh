#!/bin/bash

# necessary for the chef-version of ruby not to
# be confused about locations of files,
# at least on my system. YMMV
unset GEM_HOME
unset GEM_PATH

# make sure to put the omnibus-installed version of chef at
# the front of the path
PATH="/opt/chef/bin:/opt/chef/embedded/bin:$PATH"

exec "$@"
