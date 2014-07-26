#
# install xcode
#



# this version of xcode tools is for mavericks
if node[:platform] == "mac_os_x" && node[:platform_version] =~ /10\.9\.\d+/
  secret = SecretSource.autofind
  xcode_url = Chef::EncryptedDataBagItem.load("default", "default", secret)["xcode_url"]

  dmg_package "XCode Tools" do
    source xcode_url
    action :install
    type 'pkg'
    accept_eula true
  end
end
