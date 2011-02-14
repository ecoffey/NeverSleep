//
//  MenuletController.m
//  NeverSleep
//
//  Created by Eoin Coffey on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NVSMenuletController.h"

@interface NVSMenuletController ()
- (void) updateStateAndUI;
- (void) updateMenu;
- (BOOL) canDisable;
@end

@implementation NVSMenuletController

@synthesize menu;
@synthesize enableMenuItem;
@synthesize disableMenuItem;
@synthesize preferenceWindowController;

+ (void) initialize
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary* defaults = [NSDictionary dictionaryWithObject:@"NO" forKey:@"DisableOnNoPower"];
	
	[userDefaults registerDefaults:defaults];
}

- (void) awakeFromNib
{	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults
	 addObserver:self
	 forKeyPath:@"DisableOnNoPower"
	 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
	 context:NULL];
	
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
	
	[self updateStateAndUI];
}

- (IBAction) displaySleepToggled:(id)sender
{	
	NSLog(@"displaySleepToggled:");

	[displayControl toggleDisplaySleep];
	
	[self updateStateAndUI];
}

- (IBAction) showPreferences:(id)sender
{
	[preferenceWindowController showPreferences];
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
	
	if (powerStatusHasChanged)
	{
		[self updateStateAndUI];
	}
}

- (void) updateStateAndUI
{
	BOOL canDisable = [self canDisable];
	[displayControl setCanDisable:canDisable];
	
	[self updateMenu];
	[displayControl updateDisplaySleep];
}

- (void) updateMenu
{
	[enableMenuItem setHidden:![displayControl shouldDisable]];
	[disableMenuItem setHidden:[displayControl shouldDisable]];
	
	BOOL canDisable = [self canDisable];
	
	[enableMenuItem setEnabled:canDisable];
	[disableMenuItem setEnabled:canDisable];	
}

- (BOOL) canDisable
{
	BOOL disableOnNoPower = [[NSUserDefaults standardUserDefaults] boolForKey:@"DisableOnNoPower"];
	BOOL inWall = powerStatus == NVSPowerStatus_Wall;
	
	return inWall || disableOnNoPower;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	[self updateStateAndUI];
}

@end
