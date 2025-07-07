set myTarget to "Name"
set backoffInitial to 0.5
set searchQuery to "hanyang.ac.kr"

tell application "System Events"
	tell process "GlobalProtect"
		click menu bar item 1 of menu bar 2

        repeat until ((first window whose subrole is "AXSystemDialog") exists)
            delay 0.1
        end repeat
        tell first window whose subrole is "AXSystemDialog"
            if exists static text "연결 해제됨" then
                click button "연결"
                
                set i to backoffInitial
                repeat until exists text field 2
                    delay i
                    set i to i + i
                end repeat
            end if
            
            set focused of text field 1 to true
            set focused of text field 2 to true
        end tell

        repeat until ((first window whose subrole is "AXUnknown") exists)
            delay 0.1
        end repeat
        tell first window whose subrole is "AXUnknown"
            set openPasswordsApp to row 1 of table 1 of scroll area 1
            -- -- delay 1
            -- keystroke (ASCII character 31) & return
            set selected of openPasswordsApp to true
            -- -- delay 1
            keystroke return
            -- TODO: get otp data from Passwords app
        end tell
		
        tell first window whose subrole is "AXSystemDialog"
            repeat until ((text field 1 of group 1 of sheet 1 of sheet 1) exists)
                delay 0.1
            end repeat

            set queryField to text field 1 of group 1 of sheet 1 of sheet 1
            set value of queryField to searchQuery
            keystroke tab & (ASCII character 31) & return

            delay 0.2
            set connectButton to button "연결"
            click connectButton
        end tell
	end tell
	
	tell application "System Settings" to quit
end tell
