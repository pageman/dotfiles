# run on a current system to ensure everything is running as expected
require_relative 'test_helper'


describe "dotfiles daemon" do
  it "has run & logged recently" do
    require 'date'
    f = File.open File.expand_path("~/dotfiles/dotfiles_daemon/log/development.log")
    last = nil; f.each_line { |line| last = line }
    last_log_time = DateTime.parse(last.split(/ dotfiles/)[0])
    # recover from strange UTC parsing problem
    last_log_time = last_log_time.to_time + 5*60*60

    five_mins_ago = (Time.now - 5*60)
    (five_mins_ago...Time.now).cover?(last_log_time).must_equal true
  end
end
