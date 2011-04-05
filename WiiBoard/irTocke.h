//
//  irTocke.h
//  WiiTabla
//
//  Created by Jernej Strasner on 1/7/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "irTockeView.h"
#import <WiiRemote/WiiRemote.h>

@interface irTocke : NSWindowController {
	irTockeView *view;
	
	int numOfPoints;
}

@property (assign) IBOutlet irTockeView *view;
@property (assign) int numOfPoints;

- (void)setIRData:(IRData[4])_points;

@end
