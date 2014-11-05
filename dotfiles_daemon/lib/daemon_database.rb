require 'yaml'
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
