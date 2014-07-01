
actions :install
default_action :install

attribute :name,    :kind_of => String, :name_attribute => true
attribute :replace, :kind_of => String, :required => true
attribute :with,    :kind_of => String, :required => true

def with_path
  ::File.expand_path(with)
end

def replace_path
  ::File.expand_path(replace)
end

def replace_exists?
  ::File.exists?(replace_path)
end

def with_exists?
  ::File.exists?(with_path)
end

def replace_empty?
  # remove both '.' and '..'
  Dir.new(replace_path).entries.reject(&method(:entry_is_meta)).count == 0
end

def replace_is_link_to_with?
  ::File.symlink?(replace_path) and
    ::File.readlink(replace_path) == with_path
end

def files_in_replace
  ::Dir.entries(::File.join replace_path).reject(&method(:entry_is_meta))
end

def file_exists_in_replace?(file)
  ::File.exists? ::File.join(with_path, file)
end

private
def entry_is_meta entry
  entry =~ /^\.\.?$/
end
