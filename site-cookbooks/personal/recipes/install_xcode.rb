
#
# install xcode
#

secret = SecretSource.autofind
xcode_url = Chef::EncryptedDataBagItem.load("default", "default", secret)["xcode_url"]

dmg_package "XCode Tools" do
  source xcode_url
  action :install
end
