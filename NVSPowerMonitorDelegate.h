//
//  NVSPowerMonitorDelegate.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NVSPowerStatus.h"

@protocol NVSPowerMonitorDelegate

- (void) powerStatusIsNow:(NVSPowerStatus)currentStatus;

@end
