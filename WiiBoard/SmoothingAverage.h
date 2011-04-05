//
//  SmoothingAverage.h
//  WiiTabla
//
//  Created by Jernej Strasner on 4/26/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSPoint.h"


#define CACHE_SIZE 14


@interface SmoothingAverage : NSObject {
	NSMutableArray *cache;
}

- (void)reset;
- (CGPoint)translate:(CGPoint)p;

@end
