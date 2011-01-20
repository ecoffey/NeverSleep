//
//  NVSPowerMonitor.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NVSPowerMonitorDelegate.h"

@interface NVSPowerMonitor : NSObject {

}

- (id) initWithDelegate:(id<NVSPowerMonitorDelegate>) d;

- (void) pollForPowerStatus;

@end
