//
//  NVSPowerMonitor.m
//  NeverSleep
//
//  Created by Eoin Coffey on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NVSPowerMonitor.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/ps/IOPSKeys.h>
#import <IOKit/ps/IOPowerSources.h>

static void updatePowerStatus (void * context);

@interface NVSPowerMonitor ()
@property (assign) id<NVSPowerMonitorDelegate> delegate;
@end

@implementation NVSPowerMonitor
@synthesize delegate;

- (id) initWithDelegate:(id <NVSPowerMonitorDelegate>) d
{
	if (self = [super init])
	{
		[self setDelegate:d];
		
		CFRunLoopSourceRef loopSource = IOPSNotificationCreateRunLoopSource(updatePowerStatus, delegate);
		
		if (loopSource)
		{
			CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSource, kCFRunLoopDefaultMode);
		}
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) pollForPowerStatus
{
	updatePowerStatus(delegate);
}

@end

static bool compareStrings(CFStringRef a, CFStringRef b)
{
	return a != nil && b != nil && CFStringCompare(a, b, 0) == kCFCompareEqualTo;
}

static void updatePowerStatus(void* context)
{
	id<NVSPowerMonitorDelegate> delegate = (id<NVSPowerMonitorDelegate>) context;
	
	CFTypeRef blob = IOPSCopyPowerSourcesInfo();
	CFArrayRef list = IOPSCopyPowerSourcesList(blob);
	
	int count = CFArrayGetCount(list);
	
	if (count == 0)
	{
		// No power sources, so we must be plugged in
		[delegate powerStatusIsNow:NVSPowerStatus_Wall];
	}
	
	for (int i = 0; i < count; i++) 
	{
		CFTypeRef source;
		CFDictionaryRef description;
		
		source = CFArrayGetValueAtIndex(list, i);
		description = IOPSGetPowerSourceDescription(blob, source);
		
		if (compareStrings(CFDictionaryGetValue(description, CFSTR(kIOPSTransportTypeKey)), CFSTR(kIOPSInternalType))) 
		{
			CFStringRef currentState = CFDictionaryGetValue(description, CFSTR(kIOPSPowerSourceStateKey));
			
			if (compareStrings(currentState, CFSTR(kIOPSACPowerValue)))
			{
				[delegate powerStatusIsNow:NVSPowerStatus_Wall];
			}
			else if (compareStrings(currentState, CFSTR(kIOPSBatteryPowerValue)))
			{
				[delegate powerStatusIsNow:NVSPowerStatus_Battery];
			}
			else
			{
				// *shrug*
				[delegate powerStatusIsNow:NVSPowerStatus_Offline];
			}
		} 
	}
	
	CFRelease (list);
	CFRelease (blob);
}
