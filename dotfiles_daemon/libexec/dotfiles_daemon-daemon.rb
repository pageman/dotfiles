# Change this file to be a wrapper around your daemon code.

require 'yaml'
require 'date'

class DaemonDatabase
  def backup_runs
    data[:backup_runs] ||= []
  end

  def add_backup_run date
    backup_runs << date
  end

  def save
    File.write(filename, YAML.dump(data))
  end

  def filename
    File.expand_path "~/var/dotfiles-daemon-database.yml"
  end

  def data
    @data ||=
      begin
        if File.exists? filename
          YAML.load_file(filename)
        else
          {}
        end
      end
  end
end

class BackupRunner
  def already_ran_today? db
    db.backup_runs.include? Date.today
  end

  def go db
    unless already_ran_today?(db)
      perform_backup db
    end
  end

  def perform_backup db
    Dir.chdir (File.expand_path "~") do
      system({"BUNDLE_GEMFILE" => nil}, *%W(backup perform --trigger ttm_mbp))
      db.add_backup_run Date.today
      db.save
    end
  end
end


class UpdateAlerts
  class GitRepo
    def initialize(repo_path, obj)
      @repo_path = repo_path
      @obj = obj
    end
    def check
      check_stash
      check_branches
      check_dirty
    end

    def check_stash
      git_cmd("stash list").split("\n").each do |stash|
        @obj.add_message "stash in #{@repo_path}: #{stash}"
      end
    end

    def check_branches
      branches = git_cmd("branch --list").split("\n").map(&:strip)
      branches.each do |branch|
        branch = filter_current_asterisk branch
        num = num_remote_branches_containing branch
        if num == 0
          @obj.add_message "branch in #{@repo_path} not pushed: #{branch}"
        end
      end
    end

    def check_dirty
      it = git_dirty_or_untracked


      @obj.add_message "#{@repo_path} has untracked files (#{it.untracked})" if it.untracked > 0
      @obj.add_message "#{@repo_path} has files with unstaged changes (#{it.unstaged})" if it.unstaged > 0
      @obj.add_message "#{@repo_path} has files with staged, uncommitted changes (#{it.staged})" if it.staged > 0
    end

    def num_remote_branches_containing branch
      git_cmd("branch -r --contains #{branch}").split("\n").count
    end

    def filter_current_asterisk branch
      if match_data = branch.match(/\* (.*)/)
        match_data[1]
      else
        branch
      end
    end
    def git_cmd rest
      `cd #{@repo_path}; git #{rest}`
    end

    def git_dirty_or_untracked
      @git_dirty_or_untracked ||= GitDirtyOrUntracked.new(@repo_path)
    end

  end

  class GitDirtyOrUntracked < Struct.new(:repo_path)
    def output
      @output ||= `cd #{repo_path}; git status --porcelain`
    end
    def parsed
      unless @parsed
        @parsed = output.split("\n").map do |line|
          line.split
        end
      end
      @parsed
    end

    def staged
      number_with_first_as "A"
    end

    def unstaged
      number_with_first_as "M"
    end

    def untracked
      number_with_first_as "??"
    end

    def number_with_first_as first_value
      parsed.select do |line|
        line.first == first_value
      end.length
    end
  end

  class IncomingDirectory
    attr_accessor :incoming_path
    def initialize(incoming_path, obj)
      @incoming_path = incoming_path
      @obj = obj
    end
    def check
      Dir.chdir(File.expand_path @incoming_path) do
        content = Dir["*"]
        content.each do |c|
          @obj.add_message "File in #{@incoming_path}: #{c}"
        end
      end
    end
  end

  def locations
    [{
       type: :git,
       at: "~/vagrant-environment/apangea/"
     },
     {
       type: :incoming,
       at: "~/Inbox"
     },
     {
       type: :incoming,
       at: "~/Desktop"
     },
     {
       type: :git,
       at: "~/emacs/"
     },
     {
       type: :git,
       at: "~/dotfiles/"
     }]
  end

  def add_message msg
    @messages << msg
  end

  def initialize
    @messages = []
  end

  def go
    puts "detecting loose ends on system..."

    locations.each do |location|
      to_check = case location[:type]
                 when :git then GitRepo.new(location[:at], self)
                 when :incoming then IncomingDirectory.new(location[:at], self)
                 end
      to_check.check
    end

    File.write(File.expand_path("~/var/alerts/number"), @messages.count)
    File.open(File.expand_path("~/var/alerts/alerts"), "w") do |f|
      @messages.each do |msg|
        f.puts msg
      end
    end
  end
end



# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  config.trap( 'INT' ) do
    # do something clever
  end
  config.trap( 'TERM', Proc.new { puts 'Going down' } )
end

database = DaemonDatabase.new

# Sample loop to show process
loop do
  DaemonKit.logger.info "I'm running"

  BackupRunner.new.go database

  UpdateAlerts.new.go

  sleep 60
end




