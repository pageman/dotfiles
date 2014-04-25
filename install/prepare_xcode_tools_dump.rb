#!/usr/bin/env rvm 1.9 do ruby

# this script prepares an excode clitools dmg
# downloaded from apple to be extracted to a more convenient form.

# this form is an archive of the root directory of what would be
# placed by the installer. We then use these raw binaries to bootstrap
# the homebrew, etc process.

# the entire process is pretty complicated, so it is outlined here:

# first, we mount the DMG.

# next, we pull the contents of the pkg
# we want it to be.
# the main activity of this step is from
# http://stackoverflow.com/questions/11298855/osx-how-unpack-and-pack-pkg-file

# After getting the contents of the pkg, take the contents of the
# "Payload". This is the binary data that would be on the system

require 'fileutils'
require 'tmpdir'
include FileUtils
tmpdir = Dir.mktmpdir

Kernel.at_exit do
  `rm #{tmpdir}/*`
end

mount_dir = File.expand_path("~/Volumes/xcode_utils")
xcode_dmg_location = "~/var/binaries/xcode462_cltools_10_86938259a.dmg"
cli_tools_pkg_name = "DeveloperToolsCLI.pkg"

unless File.directory?(mount_dir)
  mkdir mount_dir
end

# mount a directory
`hdiutil attach -mountpoint #{mount_dir} #{xcode_dmg_location}`


cp File.expand_path("#{mount_dir}/Packages/#{cli_tools_pkg_name}"), tmpdir
p Dir.entries(tmpdir)

puts "tmpdir is #{tmpdir}"

cd tmpdir
puts `cpio -i -t < #{cli_tools_pkg_name}`

`hdiutil detach #{mount_dir}`

