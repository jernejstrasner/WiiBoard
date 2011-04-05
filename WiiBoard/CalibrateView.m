//
//  CalibrateView.m
//  WiiTabla
//
//  Created by Jernej Strasner on 2/9/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "CalibrateView.h"
#import "WiiBoardAppDelegate.h"

@implementation CalibrateView

@synthesize calibratedPoints;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {		
		// Add a close button
		int x = (frame.size.width-120)/2;
		int y = frame.size.height / 2 + 5;
		NSButton *aButton = [[NSButton alloc] initWithFrame:NSMakeRect(x, y, 120, 22)];
		[aButton setTitle:@"Close"];
		[aButton setButtonType:NSMomentaryPushInButton];
		[aButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[aButton setTarget:[self window]];
		[aButton setAction:@selector(closeCalibrationScreen)];
		[self addSubview:aButton];
		[aButton release];
		// Add a reset button
		y = frame.size.height / 2 - 22 - 5;
		NSButton *rButton = [[NSButton alloc] initWithFrame:NSMakeRect(x, y, 120, 22)];
		[rButton setTitle:@"Reset"];
		[rButton setButtonType:NSMomentaryPushInButton];
		[rButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[rButton setTarget:[self window]];
		[rButton setAction:@selector(resetCalibrationScreen)];
		[self addSubview:rButton];
		[rButton release];
    }
    return self;
}

- (void)setCalibratedPoints:(int)i {
	calibratedPoints = i;
	[self setNeedsDisplay:YES];
	
	if (i > 3) {
		calibratedPoints = 0;
		[(WiiBoardAppDelegate *)[[NSApplication sharedApplication] delegate] commitCalibration];
		[(CalibrateWindow *)[self window] closeCalibrationScreen];
	}
}

- (void)resetView {
	calibratedPoints = 0;
	calibPoint[0] = CGPointZero;
	calibPoint[1] = CGPointZero;
	calibPoint[2] = CGPointZero;
	calibPoint[3] = CGPointZero;	
	
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	NSColor *bg = [NSColor whiteColor];
	[bg setFill];
	CGContextFillRect(context, (CGRect)dirtyRect);
	
	// Point 1
	if (calibratedPoints >= 1) {
		[[NSColor greenColor] setFill];
	} else {
		[[NSColor redColor] setFill];
	}
	CGContextFillEllipseInRect(context, CGRectMake(40, dirtyRect.size.height-40*2, 40, 40));
	
	// Point 2
	if (calibratedPoints >= 2) {
		[[NSColor greenColor] setFill];
	} else {
		[[NSColor redColor] setFill];
	}
	CGContextFillEllipseInRect(context, CGRectMake(dirtyRect.size.width-40*2, dirtyRect.size.height-40*2, 40, 40));
	
	// Point 3
	if (calibratedPoints >= 3) {
		[[NSColor greenColor] setFill];
	} else {
		[[NSColor redColor] setFill];
	}
	CGContextFillEllipseInRect(context, CGRectMake(dirtyRect.size.width-40*2, 40, 40, 40));
	
	// Point 4
	if (calibratedPoints >= 4) {
		[[NSColor greenColor] setFill];
	} else {
		[[NSColor redColor] setFill];
	}
	CGContextFillEllipseInRect(context, CGRectMake(40, 40, 40, 40));
}

@end
