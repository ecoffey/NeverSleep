//
//  NVSDisplayControl.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

@interface NVSDisplayControl : NSObject {
	BOOL canDisable;
	BOOL shouldDisable;
	
	IOPMAssertionID displayAssertionId;
	IOPMAssertionID idleAssertionId;
	
	BOOL isCurrentlyDisabled;
}

@property (assign) BOOL canDisable;
@property (assign) BOOL shouldDisable;

- (id) initWithShouldDisable:(BOOL) disable;

- (void) toggleDisplaySleep;
- (void) updateDisplaySleep;

@end
