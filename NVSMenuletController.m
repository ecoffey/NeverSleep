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
	displayControl = [[NVSDisplayControl alloc] initWithShouldDisable:NO andDelegate:self];
	
	[powerMonitor pollForPowerStatus];

	NSBundle *bundle = [NSBundle mainBundle];
	
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"161" ofType:@"png"]];
	
	noSleepImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"display_nosleep" ofType:@"png"]];
	sleepImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"display_sleep" ofType:@"png"]];
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	[statusItem setImage:sleepImage];
	[statusItem setHighlightMode:YES];
	
	[menu setAutoenablesItems:NO];
	
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
							   
- (void) displaySleepDisabled
{
	[statusItem setImage:noSleepImage];
}

- (void) displaySleepEnabled
{
	[statusItem setImage:sleepImage];
}

- (void) powerStatusIsNow:(NVSPowerStatus)currentStatus
{
	NSLog(@"setPowerStatus: %d", currentStatus);
	BOOL powerStatusHasChanged = powerStatus != currentStatus;
	
	powerStatus = currentStatus;
	
	BOOL inWall = powerStatus == NVSPowerStatus_Wall;
	
	if (powerStatusHasChanged)
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
