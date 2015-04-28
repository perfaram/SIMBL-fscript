//
//  FScriptLoader.m
//  SIMBL-FScript
//
//  Created by Perceval FARAMAZ on 25/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "FScriptLoader.h"


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

-(id) init {
	self = [super init];
	if( !self ) return nil;
	menuItem = [FScriptMenuItem.alloc init];
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask
										   handler:^(NSEvent *event){
											   if ([event modifierFlags] == 1704234 && [event keyCode] == 8) {
												   /*CMD, ALT, SHIFT + C*/
												   [menuItem performSelector:@selector(showConsole:) withObject:nil];
											   } else if ([event modifierFlags] == 1704234 && [event keyCode] == 31) {
												   [menuItem performSelector:@selector(openObjectBrowser:) withObject:nil];
											   }
										   }];
	
	NSEvent * (^monitorHandler)(NSEvent *);
	monitorHandler = ^NSEvent * (NSEvent * event){
		if ([event modifierFlags] == 1704234 && [event keyCode] == 8) {
			/*CMD, ALT, SHIFT + C*/
			[menuItem performSelector:@selector(showConsole:) withObject:nil];
			return nil;
		} else if ([event modifierFlags] == 1704234 && [event keyCode] == 31) {
			[menuItem performSelector:@selector(openObjectBrowser:) withObject:nil];
			return nil;
		}
		// Return the event, a new event, or, to stop
		// the event from being dispatched, nil
		return event;
	};
	
	eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
														 handler:monitorHandler];
	
	
	return self;
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
