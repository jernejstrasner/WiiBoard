//
//  irTockeView.m
//  WiiTabla
//
//  Created by Jernej Strasner on 1/7/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "irTockeView.h"


@implementation irTockeView

static NSImage *greenPoint = nil;
static NSImage *redPoint = nil;
static NSImage *orangePoint = nil;
static NSImage *bluePoint = nil;

+ (void)initialize {
	if (self == [irTockeView class]) {
		greenPoint = [[NSImage imageNamed:@"ledgreen.png"] retain];
		redPoint = [[NSImage imageNamed:@"ledred.png"] retain];
		orangePoint = [[NSImage imageNamed:@"ledorange.png"] retain];
		bluePoint = [[NSImage imageNamed:@"ledlightblue.png"] retain];
	}
}

- (void)drawRect:(NSRect)dirtyRect {
	[greenPoint drawAtPoint:thePoint[0] fromRect:[self bounds] operation:NSCompositeSourceOver fraction:1.0];
	[redPoint drawAtPoint:thePoint[1] fromRect:[self bounds] operation:NSCompositeSourceOver fraction:1.0];
	[orangePoint drawAtPoint:thePoint[2] fromRect:[self bounds] operation:NSCompositeSourceOver fraction:1.0];
	[bluePoint drawAtPoint:thePoint[3] fromRect:[self bounds] operation:NSCompositeSourceOver fraction:1.0];
}

- (void)setThePoint:(CGPoint[4])_thePoint {
	int i;
	for (i = 0; i < 4; i++) {
		thePoint[i] = _thePoint[i];
	}
}

@end
