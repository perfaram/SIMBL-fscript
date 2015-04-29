//
//  FScriptLoader.m
//  SIMBL-FScript
//
//  Created by Perceval FARAMAZ on 25/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "FScriptLoader.h"
#import "RSSwizzle.h"
#import <objc/objc.h>
#import <objc/runtime.h>

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

-(void) showFScriptConsole {
	[menuItem performSelector:@selector(showConsole:) withObject:nil];
}
-(void) showFScriptBrowser {
	[menuItem performSelector:@selector(openObjectBrowser:) withObject:nil];
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
	
	//Class statusItem = objc_getClass("NSStatusItem");
	/*Method foreignSetMenu = class_getInstanceMethod(statusItem, @selector(setMenu:));
	IMP foreignSetMenuImp = method_getImplementation(foreignSetMenu);
	IMP selfSetMenuImp = imp_implementationWithBlock(^(id self, SEL _cmd, ...) {
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Hi there."];
		[alert runModal];
		method_setImplementation(foreignSetMenu, foreignSetMenuImp);
		NSMenuItem* consoleItem = [NSMenuItem.alloc init];
		NSMenuItem* browserItem = [NSMenuItem.alloc init];
		[consoleItem setTitle:@"FScript Console"];
		[browserItem setTitle:@"FScript Object Browser"];
		[consoleItem setAction:@selector(showFScriptConsole)];
		[browserItem setAction:@selector(showFScriptBrowser)];
		[menu addItem:consoleItem];
		[menu addItem:browserItem];
		[statusItem setMenu:menu];
		method_setImplementation(foreignSetMenu, foreignSetMenuImp);
	});
	method_setImplementation(foreignSetMenu, selfSetMenuImp);*/
	/*RSSwizzleInstanceMethod(statusItem,
							@selector(setMenu:),
							RSSWReturnType(void),
							RSSWArguments(id menu),
							RSSWReplacement(
	{
		// The following code will be used as the new implementation.
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Hi there."];
		[alert runModal];
		NSMenuItem* consoleItem = [NSMenuItem.alloc init];
		NSMenuItem* browserItem = [NSMenuItem.alloc init];
		[consoleItem setTitle:@"FScript Console"];
		[browserItem setTitle:@"FScript Object Browser"];
		[consoleItem setAction:@selector(showFScriptConsole)];
		[browserItem setAction:@selector(showFScriptBrowser)];
		[menu addItem:consoleItem];
		[menu addItem:browserItem];
		// Calling original implementation.
		RSSWCallOriginal(menu);
	}), 0, NULL);*/
	@try {
		udpPort = [self getUdpPort];
		udpSocket = [self initializeUdpSocket: udpPort];
	}
	@catch(NSException *ex) {
		NSLog(@"Error: %@: %@", ex.name, ex.reason);
	}
	@finally {
		NSString *portTitle = [NSString stringWithFormat:@"UDP port: %@",
							   udpPort >= 0 ? [NSNumber numberWithInt:udpPort] : @"unavailable"];
	}
	return self;
}

-(int) getUdpPort {
	int port = 7138;
	
/*	if (port < 0 || port > 65535) {
		@throw([NSException exceptionWithName:@"Argument Exception"
									   reason:[NSString stringWithFormat:@"UDP Port range is invalid: %d", port]
									 userInfo:@{@"argument": [NSNumber numberWithInt:port]}]);
		
	}*/
	
	return port;
}

-(GCDAsyncUdpSocket*)initializeUdpSocket:(int)port {
	NSError *error = nil;
	GCDAsyncUdpSocket *udpSocket = [[GCDAsyncUdpSocket alloc]
									initWithDelegate:self
									delegateQueue:dispatch_get_main_queue()];
	
	[udpSocket bindToPort:port error:&error];
	if (error) {
		@throw([NSException exceptionWithName:@"UDP Exception"
									   reason:[NSString stringWithFormat:@"Binding to %d failed", port]
									 userInfo:@{@"error": error}]);
	}
	
	[udpSocket beginReceiving:&error];
	if (error) {
		@throw([NSException exceptionWithName:@"UDP Exception"
									   reason:[NSString stringWithFormat:@"Receiving from %d failed", port]
									 userInfo:@{@"error": error}]);
	}
	
	return udpSocket;
}

-(void)shutdownUdpSocket:(GCDAsyncUdpSocket*)sock {
	if (sock != nil) {
		[sock close];
	}
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
	 fromAddress:(NSData *)address withFilterContext:(id)filterContext {
	[self processUdpSocketMsg:sock withData:data fromAddress:address];
}

-(void)processUdpSocketMsg:(GCDAsyncUdpSocket *)sock withData:(NSData *)data
			   fromAddress:(NSData *)address {
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if ([msg isEqualToString:@"browser"])
		[self showFScriptBrowser];
	else if ([msg isEqualToString:@"console"])
		[self showFScriptConsole];
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
