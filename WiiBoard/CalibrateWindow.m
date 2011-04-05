//
//  CalibrateWindow.m
//  WiiTabla
//
//  Created by Jernej Strasner on 2/9/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "CalibrateWindow.h"
#import "WiiBoardAppDelegate.h"


@implementation CalibrateWindow

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (void)closeCalibrationScreen {
	[self close];
	[NSMenu setMenuBarVisible:YES];
	// Reset the calibration data
	[(WiiBoardAppDelegate *)[[NSApplication sharedApplication] delegate] resetCalibration];
}

- (void)resetCalibrationScreen {
	// Reset the calibration data
	[(WiiBoardAppDelegate *)[[NSApplication sharedApplication] delegate] resetCalibration];
	[[self contentView] resetView];
}

@end
