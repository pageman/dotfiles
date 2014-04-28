#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

open ./command_line_tools_for_xcode.dmg
#should mount volume /Volumes/Command\ Line\ Tools/

sudo installer -pkg /Volumes/Command\ Line\ Tools/Command\ Line\ Tools.mpkg -target /

MOUNT_DIR="/Volumes/Command Line Tools/"

cd "$MOUNT_DIR"

# cleanup 
umount "$MOUNT_DIR"