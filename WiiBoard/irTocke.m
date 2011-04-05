//
//  irTocke.m
//  WiiTabla
//
//  Created by Jernej Strasner on 1/7/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "irTocke.h"
#import "irTockeView.h"

@implementation irTocke

@synthesize view;
@synthesize numOfPoints;

- (void)setIRData:(IRData[4])_points {
	if (!numOfPoints) {
		numOfPoints = 1;
	}
	
	CGPoint _point[4];
	
	int i;
	for (i = 0; i < numOfPoints; i++) {
		_point[i] = CGPointApplyAffineTransform(NSMakePoint(_points[i].x, _points[i].y), CGAffineTransformMakeScale(0.5, 0.5));
	}
	
	[[self view] setThePoint:_point];
	[[self view] setNeedsDisplay:YES];
	
	[[self window] setTitle:[NSString stringWithFormat:@"(%0.0f, %0.0f)", _point[0].x, _point[0].y]];
}

@end
