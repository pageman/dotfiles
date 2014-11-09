#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'minitest/spec'
require 'ostruct'

class Settings
  def user_at_host
    "joel@private.joelmccracken.com"
  end
  def target_directory
    "/home/joel/rsync/"
  end
  def source_directory
    "/Users/joel/Sync/"
  end
end


require 'forwardable'

class Integrations
  def initialize(settings)
    @settings = settings
  end

  def rsync
    system "rsync -a -b --suffix=.tmp-backup -v #{source_directory} #{user_at_host}:#{target_directory}"
  end

  def file_listing
    run_in_target_directory("ls #{target_directory}")
      .split("\n")
      .reject{|path| path == "." or path == ".." }
  end

  def run_in_target_directory cmd
    r, w = IO.pipe
    this_cmd = "ssh joel@private.joelmccracken.com 'cd #{target_directory}; #{cmd}'"
    puts "running: ", this_cmd
    system this_cmd, :out => w
    w.close
    r.read
  end

  private
  extend Forwardable
  def_delegators :@settings, :target_directory, :user_at_host, :source_directory
end

class BackupVersionSorter
  def actions(file_list)
    file_list.select { |file|
      file.split(".").last == "tmp-backup"
    }.map { |file|
      "mv #{file} #{next_file_name file, file_list}"
    }
  end

  def next_file_name file, file_list
    other_files = file_list.reject {|other| other == file}

    pieces = file.split(".")
    filename = pieces[0]
    suffix = pieces[1...-1]
    match_regex = /#{filename}(|-(\d+))\.#{Regexp.escape suffix.join(".")}/

    maximum = other_files.map { |name|
      if match = name.match(match_regex)
        if match[2]
          match[2].to_i
        else
          -1
        end
      else
        nil
      end
    }.concat([-1]).compact.max
    ["#{filename}-#{sprintf('%05d', maximum + 1)}", suffix.join('.')].reject(&:empty?).join '.'
  end
end


class RsyncBackupRunner
  attr_reader :settings, :integrations
  def initialize settings, integrations
    @settings = settings
    @integrations = integrations
  end

  def run
    integrations.rsync
    files = integrations.file_listing
    BackupVersionSorter.new.actions(files).each do |action|
      integrations.run_in_target_directory action
    end
  end
end


class RsyncBackupMain
  def main
    settings = Settings.new
    integrations = Integrations.new(settings)
    runner = RsyncBackupRunner.new(settings, integrations)
    runner.run
  end
end

describe "Backup version sorter" do
  it "correctly renames a single file that needs renamed after a first revision" do
    fake_list = %w{
      file.pdf
      file.pdf.tmp-backup
    }
    BackupVersionSorter.new(fake_list).actions.must_equal ["mv file.pdf.tmp-backup file-00000.pdf"]
  end

  it "correctly renames multiple revisions" do
    fake_list = %w{
      dissertation.pdf
      dissertation-1.pdf
      dissertation-2.pdf
      dissertation-3.pdf
      dissertation-4.pdf
      dissertation.pdf.tmp-backup
      file.pdf
      file-0.pdf
      file-1000.pdf
      file.pdf.tmp-backup
    }
    BackupVersionSorter.new(fake_list).actions.must_equal ["mv dissertation.pdf.tmp-backup dissertation-00005.pdf", "mv file.pdf.tmp-backup file-01001.pdf", ]
  end
end

def test
  require 'minitest/autorun'
end

def run
  RsyncBackupMain.new.main
end

case ARGV[0]
when "run" then run
when "test" then test
end
