
task :tangle do
  system(*%W{emacs -q -l lib/dotfiles/tangle-file.el --batch --tangle})
end

task :serve => :tangle do
  require 'webrick/httpserver'
  web = WEBrick::HTTPServer.new :Port => 8888, :DocumentRoot => "./"
  trap('INT') { web.shutdown }
  web.start
end


task :default => :tangle
