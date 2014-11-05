#encoding: utf-8
# Change this file to be a wrapper around your daemon code.



require 'backup_runner'
require 'daemon_database'
require 'update_alerts'

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




