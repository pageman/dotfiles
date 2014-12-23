
#
# default recipe
#

require 'pry' # i use it all the time
home_dir = Dir.home(node[:current_user])
dotfiles_dir = File.expand_path(File.join(File.expand_path(__FILE__), "../../../../"))

directory File.join(home_dir, "var") do
  owner node['current_user']
  group node['current_user']
  mode "0755"
  recursive true
  action :create
end

directory File.join(home_dir, "var", "secrets") do
  owner node['current_user']
  group node['current_user']
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

link "Backup" do
  target_file File.join(home_dir, "Backup")
  to File.join dotfiles_dir, "Backup"
  action :create
  owner "joel"
  group "staff"
end

shadow_directory "Downloads -> Inbox" do
  replace File.expand_path("~/Downloads")
  with    File.expand_path("~/Inbox")
  owner   node[:current_user]
  group   "staff"
end

package "ruby"
package "git"
package "ispell"

# hack to get gem backup to install
execute "symlink gcc to gcc-4.2" do
  command "sudo ln -s /usr/bin/gcc /usr/bin/gcc-4.2"
  not_if "test -e /usr/bin/gcc-4.2"
end

gem_package "backup" do
  version '4.0.4'
  gem_binary "/usr/local/bin/gem"
end

gem_package "pry" do
  gem_binary "/usr/local/bin/gem"
end

gem_package "bundler" do
  gem_binary "/usr/local/bin/gem"
end

execute "chown -R #{node[:current_user]}:#{node[:current_group]} /opt/homebrew-cask"

homebrew_cask "omnifocus"
homebrew_cask "racket"

include_recipe "sprout-osx-apps::evernote"
include_recipe "sprout-osx-apps::emacs"
include_recipe "sprout-osx-apps::firefox"
include_recipe "sprout-osx-apps::flux"


unless ENV["INTEGRATION_TEST"] == "true"
  include_recipe "sprout-osx-apps::virtualbox"
  include_recipe "sprout-osx-apps::vagrant"
end

expand_file = ->(name){
  ::File.expand_path ::File.join(__FILE__, "../../files/default", name)
}


secret = SecretSource.autofind
data_bag_item = Chef::EncryptedDataBagItem.load("default", "default", secret)
hashed_pw = data_bag_item["lastpass_hashed_pw"]
lastpass_encoded_pw = %Q{user_pref("extensions.lastpass.loginpws", "mccracken.joel%40gmail.com=#{hashed_pw}");}



class Chef::EncryptedDataBagItem
  def keys
    @enc_hash.keys
  end

  def each_encrypted_item &block
    @enc_hash.select{ |k,v| v.is_a? Hash }.each do |k, v|
      block.call k, self[k]
    end
  end
end

# write secrets directory
file ::File.expand_path("~/var/secrets/encrypted_data_bag_secret") do
  owner node[:current_user]
  group node[:current_group]
  content SecretSource.autofind
end


data_bag_item.each_encrypted_item do |name, val|
  file ::File.expand_path("~/var/secrets/#{name}") do
    owner node[:current_user]
    group node[:current_group]
    content val
  end
end

personal_firefox_profile "Personal" do
  owner node[:current_user]
  group "staff"

  location File.expand_path("~/var/FirefoxProfiles/Personal")

  extensions ["mozrepl-1.1.2-fx.xpi",
              "firebug-addon-1843-latest.xpi",
              "lastpass-addon-8542-latest.xpi",
              "pinboard.xpi",
              "pocket.xpi"
             ].map &expand_file

  prefs ['user_pref("extensions.mozrepl.autoStart", true);',

         #lastpass
         'user_pref("extensions.lastpass.ffhasloggedinsuccessfully", true);',
         'user_pref("extensions.lastpass.rememberPassword", true);',
         'user_pref("extensions.lastpass.rememberUsername", true);',
         lastpass_encoded_pw,
         '"user_pref("extensions.lastpass.loginusers", "mccracken.joel%40gmail.com")',
        ]

end

personal_firefox_profile "Testing" do
  owner node[:current_user]
  group "staff"

  location File.expand_path("~/var/FirefoxProfiles/Testing")

  extensions ["mozrepl-1.1.2-fx.xpi",
              "firebug-addon-1843-latest.xpi",
              "lastpass-addon-8542-latest.xpi",
              "pinboard.xpi",
              "pocket.xpi"
             ].map &expand_file

  prefs ['user_pref("extensions.mozrepl.autoStart", true);',
         #lastpass
         'user_pref("extensions.lastpass.ffhasloggedinsuccessfully", true);',
         'user_pref("extensions.lastpass.rememberPassword", true);',
         'user_pref("extensions.lastpass.rememberUsername", true);',
         lastpass_encoded_pw,
         '"user_pref("extensions.lastpass.loginusers", "mccracken.joel%40gmail.com")',
        ]
end

include_recipe "personal::bash_it_symlinks"
