require_relative './test_helper'
MOZREPL_PORT = 4242
FX_LOCATION = File.expand_path "~/Applications/Firefox.app/Contents/MacOS/firefox"

describe "firefox" do
  it "runs firefox & can connect to mozrepl" do
    pid = spawn(*%W{#{FX_LOCATION} -P Testing})
    sleep 5
    begin
      require 'socket'
      tcp = TCPSocket.new 'localhost', MOZREPL_PORT
      read_ready, write_ready = IO.select([tcp], [], [], 5)
      read_ready.first.gets # move past newline
      read_ready.first.gets.must_match /MozRepl/
    ensure
      Process.kill "KILL", pid
    end
  end
  it "has firefox" do
    assert dir_exists?(FX_LOCATION)
  end
end
