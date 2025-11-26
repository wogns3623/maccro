-- https://apple.stackexchange.com/questions/340942/applescript-how-can-i-get-ui-elements-names-attributes-properties-classe
-- LEFT: (key code 123)
-- RIGHT: key code 124)
-- UP: (key code 126)
-- DOWN: (key code 125)
-- tell application "System Events" to keystroke (ASCII character 31) --down arrow
-- tell application "System Events" to keystroke (ASCII character 30) --up arrow
-- tell application "System Events" to keystroke (ASCII character 29) --right arrow
-- tell application "System Events" to keystroke (ASCII character 28) --left arrow


tell application "System Events"
	set targName to "GlobalProtect"
	set mainApplication to application process targName

	-- Open the menu bar item
	set menuBarIcon to menu bar item 1 of menu bar 2 of mainApplication
	click menuBarIcon
	
	-- set mainWindow to window 1 of mainApplication
	-- set usernameField to text field 1 of mainWindow
	-- set passwordField to text field 2 of mainWindow
	-- set focused of usernameField to true
	-- set focused of passwordField to true
	-- delay 0.1
	-- keystroke (ASCII character 31) & return
	-- delay 2
	-- keystroke (ASCII character 31)
	-- delay 2
	
	set UIHierarchy to my TraverseUIElements(mainApplication, 0, 5)
	do shell script "echo \"" & UIHierarchy & "\" > \"./"&targName&".hierarchy.txt\""
end tell

on indent(theCharacter, maxLength)
	set theText to ""
	repeat with i from 1 to maxLength
		set theText to theCharacter & theText
	end repeat
	return theText
end indent

on TraverseUIElements(theElement, theDepth, maxDepth)
	set UIHierarchy to ""
	if theDepth > maxDepth then
		return UIHierarchy
	end if
	
	tell application "System Events"
		set UIlist to (get theElement's UI elements)
		repeat with h from 1 to number of items in UIlist
			set childElement to item h of UIlist
			set childElementName to (get name of childElement) & "(" & (class of childElement & " " & h) & ")"
			set UIHierarchy to UIHierarchy & my indent("  ", theDepth) & "- " & childElementName & "
"
			
			set saveTID to AppleScript's text item delimiters
			set AppleScript's text item delimiters to ", "
			set childElementAttributes to (name of attributes of childElement as list) as text
			set UIHierarchy to UIHierarchy & my indent("  ", theDepth + 1) & "attributes: [" & childElementAttributes & "]
"
			
			set childElementProperties to (properties of childElement as list) as text
			set UIHierarchy to UIHierarchy & my indent("  ", theDepth + 1) & "properties: [" & childElementProperties & "]
"
			set AppleScript's text item delimiters to saveTID
			
			
			set SubUIHierarchy to my TraverseUIElements(childElement, theDepth + 1, maxDepth)
			set UIHierarchy to UIHierarchy & SubUIHierarchy
		end repeat
	end tell
	
	return UIHierarchy
end TraverseUIElements
