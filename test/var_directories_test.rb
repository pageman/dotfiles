
require 'minitest/autorun'
require 'minitest/pride'

describe "directories" do
  it "has a ~/var directory" do
    assert dir_exists?("~/var")
  end
  it "has a secrets directory" do
    assert dir_exists?("~/var/secrets")
  end
  it "has a secrets directory" do
    assert dir_exists?("~/var/secrets")
  end
end

describe "apps" do
  it "has emacs" do
    assert dir_exists?("/Applications/Emacs.app")
  end

  it "has firefox" do
    assert dir_exists?("/Applications/Firefox.app")
  end
end

def dir_exists? dir
  Dir.exists? File.expand_path(dir)
end
