//
//  irTockeView.h
//  WiiTabla
//
//  Created by Jernej Strasner on 1/7/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface irTockeView : NSView {
	CGPoint thePoint[4];
}

- (void)setThePoint:(CGPoint[4])_thePoint;

@end
