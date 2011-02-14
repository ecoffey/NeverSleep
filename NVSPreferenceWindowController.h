//
//  NVSPreferenceWindowController.h
//  NeverSleep
//
//  Created by Eoin Coffey on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PreferencePanes/PreferencePanes.h>

@interface NVSPreferenceWindowController : NSObject {
	NSWindow* window;
}

@property (assign) IBOutlet NSWindow* window;

- (void) showPreferences;

@end
