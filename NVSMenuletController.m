//
//  MenuletController.m
//  NeverSleep
//
//  Created by Eoin Coffey on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NVSMenuletController.h"

@implementation NVSMenuletController

@synthesize menu;
@synthesize enableMenuItem;
@synthesize disableMenuItem;

- (void) awakeFromNib
{	
	powerMonitor = [[NVSPowerMonitor alloc] initWithDelegate:self];
	displayControl = [[NVSDisplayControl alloc] initWithShouldDisable:NO];
	
	[powerMonitor pollForPowerStatus];

	NSBundle *bundle = [NSBundle mainBundle];
	
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"161" ofType:@"png"]];
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setImage:statusImage];
	[statusItem setHighlightMode:YES];
	
	[statusItem setMenu:menu];
	[statusItem setToolTip:@"Never Sleep Display"];
	
	[self updateMenu];
	[displayControl updateDisplaySleep];
}

- (IBAction) displaySleepToggled:(id)sender
{	
	NSLog(@"displaySleepToggled:");

	[displayControl toggleDisplaySleep];
	
	[self updateMenu];
	[displayControl updateDisplaySleep];
}

- (IBAction) quit:(id)sender
{
	exit(0);
}

- (void) powerStatusIsNow:(NVSPowerStatus)currentStatus
{
	NSLog(@"setPowerStatus: %d", currentStatus);
	BOOL shouldUpdate = powerStatus != currentStatus;
	
	powerStatus = currentStatus;
	
	BOOL inWall = powerStatus == NVSPowerStatus_Wall;
	
	if (shouldUpdate)
	{
		[displayControl setCanDisable:inWall];
	
		[self updateMenu];
		[displayControl updateDisplaySleep];
	}
}

- (void) updateMenu
{
	[enableMenuItem setHidden:![displayControl shouldDisable]];
	[disableMenuItem setHidden:[displayControl shouldDisable]];
	
	BOOL inWall = powerStatus == NVSPowerStatus_Wall;
	
	[enableMenuItem setEnabled:inWall];
	[disableMenuItem setEnabled:inWall];	
}

@end
