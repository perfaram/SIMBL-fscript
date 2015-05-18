# SIMBL-fscript
##### SIMBL Plugin for loading FScript into unyielding applications. 
## Purpose 
Runtime exploration of Objective-C and Objective-C++ programs through F-Script's Object Browser and Console.
Specifically, this plugin comes in handy when the program you want to explore disables debugger-attaching (so you can't use it to load the F-Script framework), or when the program has no menu bar (such as a status-bar-only app). In these cases, use EasySIMBL to load this plugin, and then use the shortcuts to control F-Script ! (see below for detailed instructions).

## Installing
* Download EasySIMBL (https://github.com/norio-nomura/EasySIMBL/releases)
* Extract and move EasySIMBL.app into /Applications or ~/Applications
* Launch EasySIMBL.app and check Use SIMBL, then quit EasySIMBL.app
* Download FScript (https://github.com/Kentzo/F-Script/releases) and put it in /Library/Frameworks/
* Use *this* project ("download" button on the right)
* Compile it (xCode)
* Add it into EasySIMBL's Plugin Folder (usually, `~/Library/Application Support/SIMBL/Plugins/"
* Activate it in EasySIMBL
* Profit ! (see below for use)

## Way(s) to use
* Use the newly created `F-Script` item in the app's main menu (in the top menu bar).
* Shortcuts : *⌘ + ⌥ + ⇧ + C* to show console, *⌘ + ⌥ + ⇧ + O* to show Object browser.
* Use the UDP socket at port 7138 : `echo -n "bundleID.command" | nc -4u -w0 localhost 7138`. Replace `bundleID` by the target app's bundle ID (eg *com.panic.Coda2*), and `command` by *console* or *browser*.

NB : This will load FScript into all applications. To load it into one specific app, open my project in xCode, and edit Info.plist's BundleIdentifier key (into SIMBLTargetApplications array) to match your app's identifier.
