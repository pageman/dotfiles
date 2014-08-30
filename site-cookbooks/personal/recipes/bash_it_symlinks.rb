
home_dir = Dir.home(node[:current_user])
dotfiles_dir = File.expand_path(File.join(File.expand_path(__FILE__), "../../../../"))

link "bash_it profile" do
  target_file File.join(home_dir, ".bash_it", "custom", "profile.bash")
  to File.join(dotfiles_dir, "actual-dotfiles", "profile.bash")
  action :create
  owner node['current_user']
  group "staff"
end

link "bash_it aliases" do
  target_file File.join(home_dir, ".bash_it", "custom", "aliases.bash")
  to File.join(dotfiles_dir, "actual-dotfiles", "aliases.bash")
  action :create
  owner node['current_user']
  group "staff"
end
