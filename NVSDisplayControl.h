//
//  NVSDisplayControl.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import "NVSDisplayControlDelegate.h"

@interface NVSDisplayControl : NSObject {
	BOOL canDisable;
	BOOL shouldDisable;
	
	IOPMAssertionID displayAssertionId;
	IOPMAssertionID idleAssertionId;
	
	BOOL isCurrentlyDisabled;
	
	id<NVSDisplayControlDelegate> delegate;
}

@property (assign) BOOL canDisable;
@property (assign) BOOL shouldDisable;

- (id) initWithShouldDisable:(BOOL) disable andDelegate:(id<NVSDisplayControlDelegate>)d;

- (void) toggleDisplaySleep;
- (void) updateDisplaySleep;

@end
