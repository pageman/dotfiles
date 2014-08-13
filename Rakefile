task :build do
  system(*%W{emacs -q -l lib/dotfiles/tangle-file.el --batch --tangle filename})
end




task :default => :build
