#!/bin/bash

# originally was http://github.com/opscode/chef-repo/tarball/master
# but I cloned it in case anything changes upstream

curl -LO http://github.com/joelmccracken/chef-repo/tarball/master
tar -zxf master

# this would be opscode-chef-repo*
# if you use the opscode repository

mv joelmccracken-chef-repo* chef-repo
rm master
cd chef-repo
git init .
# this file will be deleted later anyway, 
# but it is easier to delete it rght now
rm cookbooks/README.md
git add .
git commit -m 'initial import from opscode/chefrepo'
cd ../
cp -r chef-repo/{*,.*} .
rm -rf chef-repo
/opt/chef/bin/knife cookbook create personal
git add .chef/knife.rb
git add Cheffile
git add create-personal-chef-repo.sh
git add install-chef-standalone.sh
git add dotfiles-chef.org
git add run-chef.sh
git add site-cookbooks
git add solo.json
git add solo.rb
git add finishing.sh

git commit -m 'include tangled output files'
echo -e "\ncookbooks\n" >> .gitignore
echo -e "tmp\n" >> .gitignore
git add .gitignore

git commit -m 'librarian-chef gitignores'
