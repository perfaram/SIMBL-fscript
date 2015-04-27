//
//  FScriptLoader.h
//  SIMBL-FScript
//
//  Created by Perceval FARAMAZ on 27/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FScriptLoader : NSObject
+(void) load;
+(FScriptLoader*) sharedInstance;
@end
