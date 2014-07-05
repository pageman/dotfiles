
actions :install
default_action :install

attribute :profile_name,       :kind_of => String, :name_attribute => true
attribute :extensions, :kind_of => Array, :default => []
attribute :location,   :kind_of => String
attribute :owner,      :kind_of => String
attribute :group,      :kind_of => String
attribute :prefs,      :kind_of => Array, :default => []

def location_exists?
  ::File.exists? ::File.expand_path(::File.join(location, "/prefs.js"))
end

def extension_exists? extension
  ::File.exists? ::File.expand_path(::File.join(location, "/extensions/", extension))
end
