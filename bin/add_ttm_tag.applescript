on addTTMToNote(aNote)	
	if aNote contains "#ttm" then
		aNote
	else
		(aNote as string) & "
#ttm"
	end if
end addTTMToNote

tell application "OmniFocus"
	tell default document
		tell folder named "TTM"
			tell flattened projects
				set taskListList to tasks
				repeat with tskList in taskListList
					repeat with tsk in tskList
						--log note of tsk as string
						--copy note of tsk to copyNote						
						--set copyNote to (addTTMToNote(copyNote) of me)
						--set the note of tsk to copyNote
									
						set newNote to (addTTMToNote(note of tsk) of me)
						set the note of tsk to newNote
					end repeat
				end repeat
			end tell
		end tell
	end tell
end tell

