on run {searchQuery}
  set SystemLanguage to do shell script "defaults read .GlobalPreferences AppleLanguages | tr -d '[:space:]()' | cut -c2-3"
  set translations to {en: {textDisconnected: "Disconnected",textVerificationCode: "Verification code",buttonConnect: "Connect",buttonVerify: "Verify"}, ko: {textDisconnected: "연결 해제됨",textVerificationCode: "인증 코드",buttonConnect: "연결",buttonVerify: "확인"}}
  set tl to getProperTranslation(translations, SystemLanguage)


  repeat while true
    waitUntilDialogOpen()
    -- log "Dialog opened."
    log "Current Page: " & checkCurrentPage(tl)

  end repeat

  set currentPage to checkCurrentPage(tl)
  if currentPage is "connectionPage" then
    connectToPortal(tl)
    set currentPage to "credentialPage"
  end if

  if currentPage is "credentialPage" then
    set otpCode to enterLoginCredential(tl, searchQuery)
    set currentPage to "verificationPage"
  end if

  if currentPage is "verificationPage" then
    if otpCode is not missing value then
      enterVerificationCode(tl, otpCode)
    else
      -- TODO: get OTP code
      error "OTP Code is missing."
    end if
  end if
end run

on waitUntilDialogOpen()
  tell application "System Events"
    tell process "GlobalProtect"
      repeat until ((first window whose subrole is "AXSystemDialog") exists)
        delay 0.1
      end repeat
    end tell
  end tell
end waitUntilDialogOpen

on checkCurrentPage(tl)
  tell application "System Events"
    tell process "GlobalProtect"
      tell (first window whose subrole is "AXSystemDialog")
        if exists static text (textDisconnected of tl) then
          return "connectionPage"
        -- if second text field exists, we are on the enter credentials page
        else if exists text field 2 then
          return "credentialPage"
        else if exists static text (textVerificationCode of tl) then
          return "verificationPage"
        else
          return "unknownPage"
        end if
      end tell
    end tell
  end tell
end checkCurrentPage

on connectToPortal(tl)
  tell application "System Events"
    tell process "GlobalProtect"
			tell (first window whose subrole is "AXSystemDialog")
				if exists static text (textDisconnected of tl) then
					click button (buttonConnect of tl)
					
					repeat until exists text field 2
						delay 0.1
					end repeat
				end if
				
				set focused of text field 1 to true
				set focused of text field 2 to true
			end tell
    end tell
  end tell
end connectionPage

-- make sure the passwords popover is open and focused
on enterLoginCredential(tl, searchQuery)
	tell application "System Events"
		tell process "GlobalProtect"
			tell (first window whose subrole is "AXSystemDialog")
				set focused of text field 2 to true
			end tell
			
      -- wait until password... popover is open
			repeat until ((first window whose subrole is "AXUnknown") exists)
				delay 0.1
			end repeat
			tell (first window whose subrole is "AXUnknown")
				set openPasswordsApp to row 1 of table 1 of scroll area 1
				set selected of openPasswordsApp to true
				keystroke return
			end tell
			
			tell (first window whose subrole is "AXSystemDialog")
				-- delay until the passwords popover is ready and unlocked
				repeat until ((scroll area 1 of group 1 of sheet 1 of sheet 1) exists)
					delay 0.1
				end repeat
				tell group 1 of sheet 1 of sheet 1
					set queryField to text field 1
					set focused of queryField to true
					keystroke searchQuery
					-- set value of queryField to searchQuery
					
					delay 0.2
					click UI element 3 of UI element 1 of row 2 of outline 1 of scroll area 1
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
				
				delay 0.5
				click button (buttonConnect of tl)
			end tell
		end tell
	end tell

  return otpCode
end getConnectionInformation

on enterVerificationCode(tl, otpCode)
  tell application "System Events"
    tell process "GlobalProtect"
      tell (first window whose subrole is "AXSystemDialog")
        repeat until ((static text (textVerificationCode of tl)) exists)
          delay 0.1
        end repeat

				set value of text field 1 to otpCode
        click button (buttonVerify of tl)
      end tell
    end tell
  end tell
end enterVerificationCode

on getProperTranslation(translations, lang)
  script inner
    property parent : a reference to current application
    use framework "Foundation"
    on getProperTranslation(translations, lang)
      set dict to current application's NSDictionary's dictionaryWithDictionary:translations

      set tl to missing value
      repeat with l in dict's allKeys()
        if lang is l as text then
          set tl to (dict's valueForKey:l) as record
          exit repeat
        end if
      end repeat

      -- fallback
      if tl is missing value then
        set tl to (dict's valueForKey:"en") as record
      end if

      return tl
    end getProperTranslation
  end script

  return inner's getProperTranslation(translations, lang)
end getProperTranslation
