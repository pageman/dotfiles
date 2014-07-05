
require 'mixlib/shellout'
require 'fileutils'
require 'chef/util/file_edit'
require 'rexml/document'

include Chef::Mixin::ShellOut

action :install do

  # manually adding extensions to a firefox profile is a very tricky
  # thing to get right. The order that these steps take place are that
  # way for a reason and probably shouldn't be messed with that much.
  # However, I fear that this will break at some point, anyway.

  unless new_resource.location_exists?
    cmd = <<-FX_CMD.strip
      #{node[:firefox_bin]} -CreateProfile "#{new_resource.profile_name} #{new_resource.location}"
    FX_CMD
    converge_by "create a new profile with: #{cmd}" do
      shell_out!(cmd, user: new_resource.owner)
    end
  end

  unless new_resource.extensions.empty?
    converge_by "add extension auto-enable permissions to profile's prefs.js" do
      insert_auto_enable_extensions_setting
    end

    new_resource.extensions.each do |extension|
      install_extension extension
    end
    open_firefox_briefly
  end

  unless new_resource.prefs.empty?
    file_edit = Chef::Util::FileEdit.new prefsjs_file
    new_resource.prefs.each do |pref|
      converge_by "ensure prefs.js contains '#{pref}'" do
        file_edit_ensure_line file_edit, pref
      end
    end
    file_edit.write_file
  end

  if new_resource.owner
    ownership = [new_resource.owner, new_resource.group].compact.join ":"

    converge_by "set profile ownership to #{ownership}" do
      cmd = <<-FX_CMD.strip
        cd #{new_resource.location}
        sudo chown -R #{ownership} *
      FX_CMD

      shell_out!(cmd, user: new_resource.owner)
    end
  end
end

def prefsjs_file
  "#{new_resource.location}/prefs.js"
end


# Firefox does some fancy work that seems important here.
# I don't know precisely what it is, but doing this in various places
# tends to eliciit different results.
def open_firefox_briefly
  converge_by "briefly run firefox to have it set up the newly-created profile" do
    pipe = IO.popen [node[:firefox_bin], "-P", new_resource.profile_name]
    sleep 5
    Process.kill 9, pipe.pid
  end
end

def insert_auto_enable_extensions_setting
  file_edit = Chef::Util::FileEdit.new prefsjs_file

  file_edit_ensure_line file_edit, 'user_pref("extensions.autoDisableScopes", 0);'
  file_edit_ensure_line file_edit, 'user_pref("extensions.enabledScopes", 15);'

  file_edit.write_file
end


def file_edit_ensure_line file_edit, string
  file_edit.insert_line_if_no_match Regexp.new(Regexp.escape(string)), string
end

def install_extension extension
  installed_name = installed_xpi_name extension
  unless new_resource.extension_exists? installed_name
    converge_by "install extension #{extension}" do
      extension_location = "#{new_resource.location}/extensions/"
      FileUtils.mkdir_p extension_location
      FileUtils.cp extension, ::File.join(extension_location, installed_name)
    end
  end
end

def installed_xpi_name xpi_file
  @xpi_name_requirements ||= ->{
    chef_gem 'rubyzip'
    require 'zip'
  }.call

  XpiIdFinder.new(xpi_file).find_id
end

class XpiIdFinder
  def initialize xpi_file
    @xpi_file = xpi_file
  end

  def find_id
    file = Zip::File.open(@xpi_file)
    install_contents = file.read("install.rdf")

    @doc = REXML::Document.new(install_contents)

    id_node = try_to_find_id_node

    unless id_node
      raise "Could not determine id from XPI: #{@xpi_file}"
    end

    id_node.text + ".xpi"
  end

  private
  def try_to_find_id_node
    REXML::XPath.first(@doc, "/RDF/Description/em:id") ||
      REXML::XPath.first(@doc, "/RDF:RDF/RDF:Description/em:id")
  end
end


def whyrun_enabled?
  true
end
