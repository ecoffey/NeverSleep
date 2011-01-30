//
//  MenuletController.h
//  NeverSleep
//
//  Created by Eoin Coffey on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import "NVSPowerMonitor.h"
#import "NVSPowerMonitorDelegate.h"
#import "NVSDisplayControl.h"
#import "NVSDisplayControlDelegate.h"

@interface NVSMenuletController : NSResponder<NVSPowerMonitorDelegate, NVSDisplayControlDelegate> {
	NVSPowerMonitor* powerMonitor;
	NVSDisplayControl* displayControl;
	
	NSMenu* menu;
	NSMenuItem* enableMenuItem;
	NSMenuItem* disableMenuItem;
	
	NSStatusItem* statusItem;
	NSImage* statusImage;
	
	NSImage* noSleepImage;
	NSImage* sleepImage;
	
	NVSPowerStatus powerStatus;
}

@property (assign) IBOutlet NSMenu* menu;
@property (assign) IBOutlet NSMenuItem* enableMenuItem;
@property (assign) IBOutlet NSMenuItem* disableMenuItem;

- (IBAction) displaySleepToggled:(id)sender;
- (IBAction) quit:(id)sender;

- (void) updateMenu;

@end
