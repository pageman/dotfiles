
#
# default recipe
#

home_dir = Dir.home(node['username'])

directory File.join(home_dir, "var") do
  owner node['username']
  group node['username']
  mode "0755"
  recursive true
  action :create
end

directory File.join(home_dir, "var", "secrets") do
  owner node['username']
  group node['username']
  mode "0700"
  recursive true
  action :create
end
