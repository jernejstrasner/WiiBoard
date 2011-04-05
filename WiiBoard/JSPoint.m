//
//  JSPoint.m
//  WiiTabla
//
//  Created by Jernej Strasner on 4/25/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "JSPoint.h"


@implementation JSPoint

@synthesize x, y;

- (id)initWithX:(int)_x andY:(int)_y {
	self = [super init];
	if (self) {
		x = _x;
		y = _y;
	}
	return self;
}

+ (JSPoint *)point {
	return [[self new] autorelease];
}

+ (JSPoint *)pointWithX:(int)_x Y:(int)_y {
	return [[[self alloc] initWithX:_x andY:_y] autorelease];
}

@end
