
require 'fileutils'

MAX_ITERATIONS = 1000
=begin
Shadow Directory

Replaces a directory with a link to another directory. Any contents in
the directory to be replaced are first moved to the other directory.
=end

include Chef::Mixin::ShellOut

action :install do
  # create the replacement target if it does not exist
  unless current_resource.with_exists?
    converge_by "create new directory #{new_resource.with_path}" do
      ::FileUtils.mkdir_p new_resource.with_path
    end
  end

  # create replacement link if no replace currently exists
  if current_resource.replace_is_link_to_with?
    # nothing; this is the ideal case
    nil
  elsif current_resource.replace_exists?
    handle_existing_replace
  else
    create_symlink
  end


  if new_resource.owner
    ownership = [new_resource.owner, new_resource.group].compact.join ":"
    converge_by "set profile ownership to #{ownership}" do
      cmd = <<-FX_CMD.strip
        chown -R #{ownership} #{new_resource.with_path}
      FX_CMD

      shell_out!(cmd, user: new_resource.owner)
    end
  end
end

def handle_existing_replace
  current_resource.files_in_replace.each do |file|
    # does the file already exist at the destination? if so, we need
    # to come up with a unique name for the file

    if ::File.exists?(::File.join(current_resource.with_path, file))
      mv_uniquely file
    else
      converge_by "move #{file} from #{new_resource.replace_path} to #{new_resource.with_path}" do
        ::FileUtils.mv(::File.join(current_resource.replace_path, file),
                       new_resource.with_path)
      end
    end
  end

  converge_by "Remove #{new_resource.replace_path} to make way for link to #{new_resource.with_path}" do
    system "sudo rm -rf #{current_resource.replace_path}"
  end

  create_symlink
end

def create_symlink
  converge_by "create link from #{new_resource.replace_path} to #{new_resource.with_path}" do
    ::File.symlink(new_resource.with_path, new_resource.replace_path)
  end
end

def mv_uniquely file
  (0..MAX_ITERATIONS).each do |i|
    potential_name = "#{file}.#{i}"
    unless current_resource.file_exists_in_replace?(potential_name)
      converge_by "move #{file} (as #{potential_name}) from #{new_resource.replace_path} to #{new_resource.with_path}" do
        ::FileUtils.mv(::File.join(current_resource.replace_path, file),
                       ::File.join(new_resource.with_path, potential_name))
      end

      return nil
    end
  end
  raise TooManyIterationsCannotMoveFile.new "unable to move file #{file}, all potential file renamings already exist."
end

def load_current_resource
  # these would have the same attributes starting out, however we will
  # handle them differently
  @current_resource ||= new_resource.dup
end

def whyrun_supported?
  true
end

class TooManyIterationsCannotMoveFile < RuntimeError; end
