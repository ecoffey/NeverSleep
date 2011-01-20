//
//  NVSDisplayControl.m
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NVSDisplayControl.h"

@implementation NVSDisplayControl

@synthesize canDisable;
@synthesize shouldDisable;

- (id) initWithShouldDisable:(BOOL)disable
{
	if (self = [super init])
	{
		shouldDisable = disable;
		canDisable = NO;
		isCurrentlyDisabled = NO;
	}
	
	return self;
}

- (void) toggleDisplaySleep
{
	shouldDisable = shouldDisable ? NO : YES;
}

- (void) updateDisplaySleep
{
	NSLog(@"DisplayControl => shouldDisable : %d, canDisable : %d", shouldDisable, canDisable);
	
	IOReturn ret;
	
	if (shouldDisable && canDisable && !isCurrentlyDisabled)
	{
		NSLog(@"Attempting to turn off display sleep...");
		
		ret = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep, kIOPMAssertionLevelOn, CFSTR("DisplaySleepOff"), &displayAssertionId);
		
		if (ret == kIOReturnSuccess)
		{
			NSLog(@"Display sleep is off");
		}
		
		ret = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoIdleSleep, kIOPMAssertionLevelOn, CFSTR("IdleSleepOff"), &idleAssertionId);
		
		if (ret == kIOReturnSuccess)
		{
			NSLog(@"Idle sleep is off");
		}
		
		isCurrentlyDisabled = YES;
	}
	else if (isCurrentlyDisabled)
	{
		if (displayAssertionId != 0)
		{
			NSLog(@"Attempting to turn on display sleep...");
			
			ret = IOPMAssertionRelease(displayAssertionId);
			
			if (ret == kIOReturnSuccess)
			{
				NSLog(@"Display sleep is on");
			}
			
			displayAssertionId = 0;
		}
		
		if (idleAssertionId != 0)
		{
			NSLog(@"Attempting to turn on idle sleep...");
			
			ret = IOPMAssertionRelease(idleAssertionId);
			
			if (ret == kIOReturnSuccess)
			{
				NSLog(@"Idle sleep is on");
			}
			
			idleAssertionId = 0;
		}
		
		isCurrentlyDisabled = NO;
	}
}

@end
