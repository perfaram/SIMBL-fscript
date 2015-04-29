//
//  FScriptLoader.h
//  SIMBL-FScript
//
//  Created by Perceval FARAMAZ on 27/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "/Library/Frameworks/FScript.framework/Headers/FScript.h"
#import "/Library/Frameworks/FScript.framework/Headers/FScriptMenuItem.h"
#import "GCDAsyncUdpSocket.h"

@interface FScriptLoader : NSObject {
	id eventMonitor;
	FScriptMenuItem* menuItem;
	GCDAsyncUdpSocket *udpSocket;
	int udpPort;
	NSString* consoleStr;
	NSString* browserStr;
}

+(void) load;
+(FScriptLoader*) sharedInstance;
@end
