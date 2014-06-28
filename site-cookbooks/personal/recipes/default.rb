
#
# default recipe
#

home_dir = Dir.home(node['username'])
dotfiles_dir = File.expand_path(File.join(File.expand_path(__FILE__), "../../../../"))

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

link "bin" do
  target_file File.join(home_dir, "bin")
  to File.join dotfiles_dir, "bin"
  action :create
  owner "joel"
  group "staff"
end

link "lib" do
  target_file File.join(home_dir, "lib")
  to File.join dotfiles_dir, "lib"
  action :create
  owner "joel"
  group "staff"
end

Dir[File.join dotfiles_dir, "profile/*"].each do |file|
  link file do
    target_file File.join(home_dir, file)
    to File.join dotfiles_dir, "profile", file
    action :create
    owner "joel"
    group "staff"
  end
end
