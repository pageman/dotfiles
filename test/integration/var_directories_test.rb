require_relative './test_helper'

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

end
