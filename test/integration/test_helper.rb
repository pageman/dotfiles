require 'minitest/autorun'
require 'pry'

def dir_exists? dir
  Dir.exist? File.expand_path(dir)
end

