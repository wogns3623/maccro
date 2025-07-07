set myTarget to "Name"
set backoffInitial to 0.5
set searchQuery to "hanyang.ac.kr"

tell application "System Events"
	tell process "GlobalProtect"
		click menu bar item 1 of menu bar 2
		set mainTarget to window 1
		
		if exists static text "연결 해제됨" of mainTarget then
			click button "연결" of mainTarget
			
			set i to backoffInitial
			repeat until exists text field 2 of mainTarget
				delay i
				set i to i + i
			end repeat
		end if
		
		
		set usernameField to text field 1 of mainTarget
		set passwordField to text field 2 of mainTarget
		-- open password filler
		set focused of usernameField to true
		set focused of passwordField to true
		delay 1
		-- keystroke (ASCII character 31) & return
		set openPasswordsAppWindow to window 1
		perform action "AXRaise" of openPasswordsAppWindow
		-- set openPasswordsApp to static text 1 of UI element 1 of row 1 of table 1 of scroll area 1 of openPasswordsAppWindow
		-- set focused of openPasswordsApp to true
		
		-- repeat until exists text field 1 of group 1 of sheet 1 of sheet 1 of mainTarget
		--     delay 0.5
		-- end repeat
		
		-- set queryField to text field 1 of group 1 of sheet 1 of sheet 1 of mainTarget
		-- set value of queryField to searchQuery
		
		-- open context menu of usernameField(i)
		-- set textField to usernameField of mainTarget
		-- tell textField to perform action "AXShowMenu"
		
		-- set value of usernameField of mainTarget to "wogns3623"
		-- set value of passwordField of mainTarget to "password"
		-- click button "연결" of mainTarget
	end tell
	
	tell application "System Settings" to quit
end tell
