//
//  NVSPreferenceWindowController.m
//  NeverSleep
//
//  Created by Eoin Coffey on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NVSPreferenceWindowController.h"


@implementation NVSPreferenceWindowController

@synthesize window;

- (void) showPreferences
{
	[window makeKeyAndOrderFront:self];
}

@end
