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

@interface FScriptLoader : NSObject {
	id eventMonitor;
	FScriptMenuItem* menuItem;
}
+(void) load;
+(FScriptLoader*) sharedInstance;
@end
