require 'rake/testtask'

Dir["lib/tasks/*.rb"].each do |f|
  require_relative f
end

desc "run the tangle system on the org files."
task :tangle do
  system(*%W{emacs -q -l lib/dotfiles/tangle-file.el --batch --tangle})
end

desc "run a web server for displaying this project"
task :serve => :tangle do
  require 'webrick/httpserver'
  web = WEBrick::HTTPServer.new :Port => 8888, :DocumentRoot => "./"
  trap('INT') { web.shutdown }
  web.start
end

namespace :test do
  Rake::TestTask.new do |t|
    t.name = :all
    t.test_files = FileList['test/**/*_test.rb']
  end

  task :matching do
    raise "must provide a name=/regex/" unless ENV['name']
    system "ruby -Ilib:test test/**/*_test.rb name=#{ENV['name']}"
  end
end

# desc "runs tests. TEST=<path> to run a file, regex=/regex/ to match test names"
# task :test do
# end

task :default => :tangle
