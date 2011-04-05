//
//  CalibrateView.h
//  WiiTabla
//
//  Created by Jernej Strasner on 2/9/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CalibrateView : NSView {
	CGPoint calibPoint[4];
	int calibratedPoints;
}

@property (nonatomic, assign) int calibratedPoints;

- (void)resetView;

@end
