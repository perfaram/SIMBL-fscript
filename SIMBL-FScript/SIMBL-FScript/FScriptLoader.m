//
//  FScriptLoader.m
//  SIMBL-FScript
//
//  Created by Perceval FARAMAZ on 25/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "FScriptLoader.h"
//#import "/Library/Frameworks/FScript.framework/Headers/FScript.h"

@implementation FScriptLoader
/**
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+(void) load
{
	FScriptLoader* plugin = [FScriptLoader sharedInstance];
	[[NSBundle bundleWithPath:@"/Library/Frameworks/FScript.framework"] load];
	[NSClassFromString(@"FScriptMenuItem") performSelector:@selector(insertInMainMenu)];
	NSLog(@"FScript loaded");
}

/**
 * @return the single static instance of the plugin object
 */
+(FScriptLoader*) sharedInstance
{
	static FScriptLoader* plugin = nil;
	
	if (plugin == nil)
		plugin = [[FScriptLoader alloc] init];
	
	return plugin;
}
@end
