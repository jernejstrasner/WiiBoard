//
//  JSPoint.h
//  WiiTabla
//
//  Created by Jernej Strasner on 4/25/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JSPoint : NSObject {
	int x, y;
}

+ (JSPoint *)point;
+ (JSPoint *)pointWithX:(int)_x Y:(int)_y;

- (id)initWithX:(int)_x andY:(int)_y;


@property int x;
@property int y;

@end
