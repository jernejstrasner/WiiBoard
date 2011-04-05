//
//  CalibrationView.m
//  WiiTabla
//
//  Created by Jernej Strasner on 2/10/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "CalibrationView.h"


@implementation CalibrationView

@synthesize topLeft, topRight, bottomRight, bottomLeft;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	[[NSColor whiteColor] setFill];
	CGContextFillRect(context, dirtyRect);
	
	// Draw the area
	[[NSColor blueColor] setFill];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, round(topLeft.x/2), round(topLeft.y/2));
	CGContextAddLineToPoint(context, round(topRight.x/2), round(topRight.y/2));
	CGContextAddLineToPoint(context, round(bottomRight.x/2), round(bottomRight.y/2));
	CGContextAddLineToPoint(context, round(bottomLeft.x/2), round(bottomLeft.y/2));
	CGContextAddLineToPoint(context, round(topLeft.x/2), round(topLeft.y/2));
	CGContextFillPath(context);
}

@end
