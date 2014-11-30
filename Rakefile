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


task :default => :tangle
