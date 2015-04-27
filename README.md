# SIMBL-fscript
SIMBL Plugin for loading FScript into unyielding applications

Steps to use :
1. Download EasySIMBL (https://github.com/norio-nomura/EasySIMBL/releases)
2. Extract and move EasySIMBL.app into /Applications or ~/Applications
3. Launch EasySIMBL.app and check Use SIMBL, then quit EasySIMBL.app
4. Download FScript (https://github.com/Kentzo/F-Script/releases) and put it in /Library/Frameworks/
5. Use *this* project ("download" button on the right)
6. Compile it (xCode)
7. Add it into EasySIMBL's Plugin Folder (usually, `~/Library/Application Support/SIMBL/Plugins/"
8. Activate it in EasySIMBL
9. Profit !

NB : This will load FScript into all applications. To load it into one specific app, open my project in xCode, and edit Info.plist's BundleIdentifier key (into SIMBLTargetApplications array) to match your app's identifier.
