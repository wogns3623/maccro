-----------------------------------------------------------|
on run
    _init()

    # Your startup code goes here, which will
    # execute once when your application runs
    # e.g.
    #   do shell script "/path/to/start-script.sh"
end run

on idle
    # Any code you need to run repeatedly can
    # go here.  Otherwise, you can delete this
    # entire handler

    # The following line is test code:
    display notification "idling..."

    # The return value is how often (in seconds)
    # this handler will be called
    return 10
end idle

on activate
    # Insert code you want to execute whenever
    # your application receives focus, e.g.
    # 
    #   tell application "System Events" to ¬
    #       open folder "~/Path/To/Folder/"

    # The following line is test code:
    display dialog "Focus acquired."
end activate

on quit
    global |@|
    |@|'s removeObserver:me

    # Any other clean-up code that needs to
    # execute just before your application
    # exits should go here, e.g.
    #   do shell script "/path/to/quit-script.sh"

    continue quit
end quit
-----------------------------------------------------------|
# PRIVATE HANDLERS:
use framework "Foundation"
use framework "AppKit"
use scripting additions

property |@| : a reference to my NSWorkspace's ¬
    sharedWorkspace's notificationCenter

on _init()
    "NSWorkspaceDidActivateApplicationNotification"
    |@|'s addObserver:me selector:("_notify:") ¬
        |name|:result object:(missing value)

    idle
end _init

to _notify:notification
    local notification
    if my id = the notification's userInfo()'s ¬
        NSWorkspaceApplicationKey's ¬
        bundleIdentifier() as text ¬
        then activate me
end _notify:
-----------------------------------------------------------|
