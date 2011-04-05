//
//  SmoothingAdaptive.h
//  WiiTabla
//
//  Created by Jernej Strasner on 4/26/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSPoint.h"


@interface SmoothingAdaptive : NSObject {
	double alpha;
	double dAlpha;
	
	double x, y, dx, dy;
	JSPoint *last;
}

- (void)reset;
- (CGPoint)translate:(CGPoint)p;

@end
