require 'date'

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
      system("ssh-add /Users/joel/var/secrets/id_rsa_joel\@private.joelmccracken.com; /Users/joel/bin/rsync_backup.rb run")
      db.add_backup_run Date.today
      db.save
    end
  end
end
