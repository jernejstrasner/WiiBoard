//
//  SmoothingAverage.m
//  WiiTabla
//
//  Created by Jernej Strasner on 4/26/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "SmoothingAverage.h"


@implementation SmoothingAverage

- (id)init {
	self = [super init];
	if (self) {
		[self reset];
	}
	
	return self;
}

- (void)reset {
	if (cache) {
		[cache release];
	}
	cache = [NSMutableArray new];
}

- (CGPoint)translate:(CGPoint)p
{
	[cache addObject:[JSPoint pointWithX:p.x Y:p.y]];
	
	if ([cache count] > CACHE_SIZE) {
		[cache removeObjectAtIndex:0];
	}
	
	int _x, _y;
	for (JSPoint *point in cache) {
		_x += point.x;
		_y += point.y;
	}
	
	return CGPointMake(round(_x / [cache count]), round(_y / [cache count]));
}
	
- (void)dealloc {
	[cache release];
	
	[super dealloc];
}

@end
