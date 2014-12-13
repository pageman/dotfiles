require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

def dir_exists? dir
  Dir.exists? File.expand_path(dir)
end

