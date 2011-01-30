//
//  NVSDisplayControlDelegate.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol NVSDisplayControlDelegate

- (void) displaySleepDisabled;
- (void) displaySleepEnabled;

@end
