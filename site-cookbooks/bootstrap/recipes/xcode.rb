
#
# install xcode
#

# this version of xcode tools is for mavericks
secret = SecretSource.autofind
xcode_url = Chef::EncryptedDataBagItem.load("default", "default", secret)["yosemite_xcode_url"]

dmg_package "XCode Tools" do
  source xcode_url
  action :install
  type 'pkg'
  accept_eula true
  volumes_dir "Command\ Line\ Developer\ Tools"
  app "Command Line Tools (OS X 10.10)"
end
