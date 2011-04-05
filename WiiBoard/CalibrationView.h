//
//  CalibrationView.h
//  WiiTabla
//
//  Created by Jernej Strasner on 2/10/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CalibrationView : NSView {
	CGPoint topLeft;
	CGPoint topRight;
	CGPoint bottomRight;
	CGPoint bottomLeft;
}

@property CGPoint topLeft;
@property CGPoint topRight;
@property CGPoint bottomRight;
@property CGPoint bottomLeft;

@end
