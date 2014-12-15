require 'minitest/autorun'
require 'pry'

def dir_exists? dir
  Dir.exists? File.expand_path(dir)
end

