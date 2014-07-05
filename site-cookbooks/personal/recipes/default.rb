
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

shadow_directory "Downloads -> Inbox" do
  replace File.expand_path("~/Downloads")
  with    File.expand_path("~/Inbox")
end

expand_file = ->(name){
  ::File.expand_path ::File.join(__FILE__, "../../files/default", name)
}

hashed_pw = ::File.read(::File.expand_path "~/var/secrets/fx-last-pass-pw-hash")
lastpass_encoded_pw = %Q{user_pref("extensions.lastpass.loginpws", "mccracken.joel%40gmail.com=#{hashed_pw}");}

personal_firefox_profile "Personal" do
  owner node[:username]
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
