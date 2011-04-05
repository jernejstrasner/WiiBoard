//
//  SmoothingAdaptive.m
//  WiiTabla
//
//  Created by Jernej Strasner on 4/26/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "SmoothingAdaptive.h"


@implementation SmoothingAdaptive

- (id)init {
	self = [super init];
	if (self) {
		[self reset];
	}
	
	return self;
}

- (void)reset {
	x = y = dx = dy = -1;
	if (last) {
		[last release];
	}
	last = [JSPoint new];
}	

- (CGPoint)translate:(CGPoint)p
{
	if (!last) {
		dx = dy = 0;
	} else {
		dx += dAlpha * ((p.x - last.x) - dx);
		dy += dAlpha * ((p.y - last.y) - dy);
		
		alpha = alpha + 0.015 - (alpha + 0.015) * (1/(fmax(abs(dx), abs(dy)) + 1));
	}
	if (last) {
		last.x = p.x;
		last.y = p.y;
	} else {
		last = [[JSPoint alloc] initWithX:p.x Y:p.y];
	}
	
	if (x == -1) {
		x = p.x;
		y = p.y;
	} else {
		x += alpha * (p.x - x);
		y += alpha * (p.y - y);
	}
	
	
	return CGPointMake(round(x), round(y));
}

- (void)dealloc {
	[last release];
	
	[super dealloc];
}

@end
