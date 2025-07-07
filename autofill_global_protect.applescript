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
                
                repeat until exists text field 2
                    delay 0.1
                end repeat
            end if
            
            set focused of text field 1 to true
            set focused of text field 2 to true
        end tell

        -- password... popover
        repeat until ((first window whose subrole is "AXUnknown") exists)
            delay 0.1
        end repeat
        tell first window whose subrole is "AXUnknown"
            set openPasswordsApp to row 1 of table 1 of scroll area 1
            set selected of openPasswordsApp to true
            keystroke return
        end tell
        
        tell first window whose subrole is "AXSystemDialog"
            -- delay until the passwords popover is ready and unlocked
            repeat until ((scroll area 1 of group 1 of sheet 1 of sheet 1) exists)
                delay 0.1
            end repeat
            tell group 1 of sheet 1 of sheet 1
                set queryField to text field 1
                set value of queryField to searchQuery

                -- delay 0.2
                click UI Element 3 of UI Element 1 of row 2 of outline 1 of scroll area 1
            end tell

            repeat until ((group 1 of sheet 1 of sheet 1 of sheet 1) exists)
                delay 0.1
            end repeat
            tell group 1 of sheet 1 of sheet 1 of sheet 1
                set otpTextElement to static text 9 of group 1 of scroll area 1
                set otpCode to otpTextElement's value
                key code 53
            end tell

            -- close the password popover
            delay 0.2
            keystroke tab & (ASCII character 31) & return

            delay 0.2
            click button "연결"

            repeat until ((static text "인증 코드") exists)
                delay 0.1
            end repeat
            set value of text field 1 to otpCode
            click button "확인"
        end tell
	end tell
	
	tell application "System Settings" to quit
end tell
