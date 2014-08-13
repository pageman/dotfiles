#!/bin/bash

set -e

if [[ "$EDB_SECRET" != "" && -f "$EDB_SECRET" ]]; then
  ln -s "$EDB_SECRET" ./encrypted_data_bag_secret || true
fi

/opt/chef/bin/chef-solo -c solo.rb -j solo.json $@
chown -R $SUDO_USER:staff ./*
