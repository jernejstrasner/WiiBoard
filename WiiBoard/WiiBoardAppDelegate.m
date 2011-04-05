//
//  WiiBoardAppDelegate.m
//  WiiTabla
//
//  Created by Jernej Strasner on 1/5/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "WiiBoardAppDelegate.h"

@implementation WiiBoardAppDelegate

@synthesize window, findWiiMoteButton, wiiProgressIndicator, wiiStatusLabel, irButton, batteryLevelUI;
@synthesize IRSensorState, batteryLevel, led1Blink, greenLED, redLED, irTockeController, numOfIRPoints, isMultitouchEnabled;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Add a observer for numOfIRPoints
	[self addObserver:self forKeyPath:@"numOfIRPoints" options:NSKeyValueObservingOptionNew context:NULL];
	
	calibrationProcess = 0;
	
	// Init the smoothing
	smoother = [[SmoothingAverage alloc] init];
//	smoother = [[SmoothingAdaptive alloc] init];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	NSLog(@"Closing connection to WiiMote...");
	[wii closeConnection];
	[wii release];
	wii = nil;
	NSLog(@"Connection closed! Terminating...");
	
	return NSTerminateNow;
}

#pragma mark -
#pragma mark Observers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"numOfIRPoints"]) {
		[self.irTockeController setNumOfPoints:[[change objectForKey:NSKeyValueChangeNewKey] intValue]+1];
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)startWiiMoteDiscovery:(id)sender {
	NSLog(@"Start discovering the WiiMote...");	
	wiiDiscovery = [[WiiRemoteDiscovery alloc] init];
	[wiiDiscovery setDelegate:self];
	[wiiDiscovery start];
	
	[self.wiiProgressIndicator startAnimation:sender];
	[self.wiiStatusLabel setStringValue:@"Searching for WiiMote..."];
	[self.redLED setHidden:YES];
	[self.greenLED setHidden:YES];
}

- (IBAction)toggleIRState:(id)sender {
	[wii setIRSensorEnabled:[sender state]];
	NSLog(@"IR sensor status changed: %@", [NSNumber numberWithBool:[sender state]]);
}

- (IBAction)disconnectWiiMote:(id)sender {
	[wii closeConnection];
	[wii release];
	wii = nil;
}

- (IBAction)showIRTockePanel:(id)sender {
	self.irTockeController = [[irTocke alloc] initWithWindowNibName:@"irTocke"];
	[self.irTockeController showWindow:sender];
}

- (IBAction)toggleMouse:(id)sender {
	if ([sender state] == 0) {
		isSimulatingMouse = NO;
	} else {
		isSimulatingMouse = YES;
	}
	NSLog(@"%@: Is simulating mouse: %@", [self class], [NSNumber numberWithBool:isSimulatingMouse]);
}

- (IBAction)calibrateMouse:(id)sender {
	isCalibrating = YES;
	[NSMenu setMenuBarVisible:NO];
	
	CalibrateView *calibView = [[CalibrateView alloc] initWithFrame:[[NSScreen mainScreen] frame]];
	calibrateWindow = [[CalibrateWindow alloc] initWithContentRect:calibView.frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES screen:[NSScreen mainScreen]];
	[calibrateWindow setContentView:calibView];
	[calibrateWindow setLevel:NSFloatingWindowLevel];
	[calibrateWindow setTitle:@"Calibrate"];
	[calibrateWindow makeKeyAndOrderFront:nil];
	[calibrateWindow setFrame:[calibrateWindow frameRectForContentRect:[calibView frame]] display:YES animate:YES];
	[calibrateWindow setDelegate:self];
}

- (void)resetCalibration {
	isCalibrating = NO;
	calibrationProcess = 0;	
}

- (void)windowWillClose:(NSNotification *)notification {
	isCalibrating = NO;
}

- (void)commitCalibration {
	isCalibrating = NO;
	calibrationProcess = 0;
	
	// Get the main screen size
	CGSize screenSize = NSSizeToCGSize([[NSScreen mainScreen] frame].size);
	
	// Quadrilateral bounding points
	CGPoint bPoints[4] = {
		CGPointMake(calibData.topLeft.x, calibData.topLeft.y),
		CGPointMake(calibData.topRight.x, calibData.topRight.y),
		CGPointMake(calibData.bottomLeft.x, calibData.bottomLeft.y),
		CGPointMake(calibData.bottomRight.x, calibData.bottomRight.y)
	};
	
	// The screen size + calibration offsets
	CGPoint dPoints[4] = {
		CGPointMake(0.0 + 60, 0.0 + 60),
		CGPointMake(screenSize.width - 60, 0.0 + 60),
		CGPointMake(0.0 + 60, screenSize.height - 60),
		CGPointMake(screenSize.width - 60, screenSize.height - 60)
	};
	
	// If the warper already exists release it
	if (warper) {
		[warper release];
	}
	
	// Create a new Warper with the required data
	warper = [[Warper alloc] init];
	[warper setDestination:dPoints];
	[warper setSource:bPoints];
	[warper computeWarp];
}

- (IBAction)trackingArea:(id)sender {
	CalibrationView *cView = [[CalibrationView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 512, 384))];
	NSWindow *win = [[NSWindow alloc] initWithContentRect:cView.frame styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask) backing:NSBackingStoreBuffered defer:YES];
	[win setContentView:cView];
	[win setLevel:NSNormalWindowLevel];
	[win setTitle:@"Tracking area"];
	[win makeKeyAndOrderFront:nil];
	[win setFrame:[win frameRectForContentRect:[cView frame]] display:YES animate:NO];
	[win setFrameOrigin:NSPointFromCGPoint(CGPointMake(300, 200))];
	
	[cView setTopLeft:calibData.topLeft];
	[cView setTopRight:calibData.topRight];
	[cView setBottomRight:calibData.bottomRight];
	[cView setBottomLeft:calibData.bottomLeft];
	[cView setNeedsDisplay:YES];
}

- (IBAction)lightDesk:(id)sender {
	CalibrationView *cView = [[CalibrationView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 512, 384))];
	NSWindow *win = [[NSWindow alloc] initWithContentRect:cView.frame styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask) backing:NSBackingStoreBuffered defer:YES];
	[win setContentView:cView];
	[win setLevel:NSNormalWindowLevel];
	[win setTitle:@"Tracking area"];
	[win makeKeyAndOrderFront:nil];
	[win setFrame:[win frameRectForContentRect:[cView frame]] display:YES animate:NO];
	[win setFrameOrigin:NSPointFromCGPoint(CGPointMake(300, 200))];
	
	[cView setTopLeft:calibData.topLeft];
	[cView setTopRight:calibData.topRight];
	[cView setBottomRight:calibData.bottomRight];
	[cView setBottomLeft:calibData.bottomLeft];
	[cView setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Connecting the WiiMote

- (void)willStartWiimoteConnections {
	NSLog(@"Remote found. Connecting...");
}

- (void)WiiRemoteDiscovered:(WiiRemote *)wiimote {
	NSLog(@"Remote discovered!");
	[self.wiiStatusLabel setStringValue:@"WiiMote connected"];
	[self.wiiProgressIndicator stopAnimation:nil];
	[self.greenLED setHidden:NO];
	[self.redLED setHidden:YES];
	wii = [wiimote retain];
	[wii setDelegate:self];
	[wii setInitialConfiguration];
	[wii setMotionSensorEnabled:NO];
	[wii setExpansionPortEnabled:NO];
	// Enable the IR sensor
	[wii setIRSensorEnabled:YES];
}

- (void)WiiRemoteDiscoveryError:(int)code {
	NSLog(@"Remote discovery error! Code:%d", code);
	[self.wiiStatusLabel setStringValue:@"The WiiMote could not be found!"];
	[self.wiiProgressIndicator stopAnimation:nil];
	[self.redLED setHidden:NO];
	[self.greenLED setHidden:YES];
	// Release the WiiMoteDiscovery object
	[wiiDiscovery release];
	wiiDiscovery = nil;
}

- (void)wiiRemoteDisconnected:(IOBluetoothDevice*)device {
	NSLog(@"WiiMote disconnected!");
	[self.wiiStatusLabel setStringValue:@"Connection dropped!"];
	[self.wiiProgressIndicator stopAnimation:nil];
	// Set the LED to red
	[self.redLED setHidden:NO];
	[self.greenLED setHidden:YES];
	// Battery to 0
	self.batteryLevel = 0;
	// Release the WiiMoteDiscovery object
	[wiiDiscovery release];
	wiiDiscovery = nil;
}

#pragma mark Dummy methods

// This methods have to bo here because the framework doesn't ask the delegate
// if the method implementations exist but just calls them. And KABOOOM! :D
- (void)accelerationChanged:(WiiAccelerationSensorType)type accX:(unsigned short)accX accY:(unsigned short)accY accZ:(unsigned short)accZ { /* Do nothing */ }
- (void)irPointMovedX:(float)px Y:(float)py { /* Do nothing */ }
- (void)buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed { /* Do nothing */ }

#pragma mark Pointer movement

- (CGPoint)convertPointToScreen:(CGPoint)sourcePoint {
	// Transform the point using the warper
	CGPoint retPoint = [warper warpSourcePoint:sourcePoint];
	
	// return the new point
	return retPoint;
}

- (void)rawIRData:(IRData[4])irData {
	// Send the data to the controller that draws the points
	[self.irTockeController setIRData:irData];
	
	// If the application is in the calibrating state
	if (isCalibrating) {
		// If the first point is bright enough (the range is from 0 - 15)
		if (irData[0].s < 10) {
			// Another condition that prevents multiple clicks as this method gets called about a 100 times in a second
			if (!isMouseDown) {
				// Log the click coordinates in the WiiMote coordinate system
				NSLog(@"CLICK (%d, %d)", irData[0].x, irData[0].y);
				
				// calibrate 4 points
				if (calibrationProcess == 0)
				{
					calibData.topLeft = CGPointMake(irData[0].x, irData[0].y);
					calibrationProcess = 1;
					[[calibrateWindow contentView] setCalibratedPoints:1];
				} else
				if (calibrationProcess == 1)
				{
					calibData.topRight = CGPointMake(irData[0].x, irData[0].y);
					calibrationProcess = 2;
					[[calibrateWindow contentView] setCalibratedPoints:2];
				} else
				if (calibrationProcess == 2)
				{
					calibData.bottomRight = CGPointMake(irData[0].x, irData[0].y);
					calibrationProcess = 3;
					[[calibrateWindow contentView] setCalibratedPoints:3];
				} else
				if (calibrationProcess == 3)
				{
					calibData.bottomLeft = CGPointMake(irData[0].x, irData[0].y);
					calibrationProcess = 4;
					[[calibrateWindow contentView] setCalibratedPoints:4];
				}
				
				// The IR dot is visible (act like the user holds the mouse button down)
				isMouseDown = YES;
			}
		} else {
			// The IR dot is no longer visible
			isMouseDown = NO;
		}
	// If the application is simulating the mouse
	} else if (isSimulatingMouse) {
		// If the dot is bright enough
		if(irData[0].s < 10)
		{
			CGPoint p = CGPointMake(irData[0].x, irData[0].y);
			// Smoothing
			p = [smoother translate:p];
			p = [self convertPointToScreen:p];

			if (!isMouseDown)
			{
				CGEventRef mouseEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, p, kCGMouseButtonLeft);
				CGEventPost(kCGHIDEventTap, mouseEvent);
				
				isMouseDown = YES;
			}
			else
			{
				CGEventRef mouseEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDragged, p, kCGMouseButtonLeft);
				CGEventPost(kCGHIDEventTap, mouseEvent);
			}
		} else {
			if (isMouseDown) {
				// Current mouse position
				CGEventRef ourEvent = CGEventCreate(NULL);
				CGPoint p = CGEventGetLocation(ourEvent);
				// DO a mouse-up action on the current pointer position
				CGEventRef mouseEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, p, kCGMouseButtonLeft);
				CGEventPost(kCGHIDEventTap, mouseEvent);
				// Mouse is up
				isMouseDown = NO;
				// Reset the smoother
				[smoother reset];
			}
		}
	}
	
//	if (!isCalibrating && isMultitouchEnabled) {
//		// Enable multitouch
//		int i;
//		NSDictionary *userInfo;
//		NSMutableArray *touchData = [[NSMutableArray alloc] init];
//		CGPoint nPoint;
//		NSString *touchID = @"JSTouchEvent";
//		
//		for (i = 0; i < 4; i++) {
//			// Create a touch event for each touch
//			if (irData[i].s < 15)
//			{
//				nPoint = [self convertPointToScreen:CGPointMake(irData[i].x, irData[i].y)];
//				
//				// Smoothing
//				nPoint = [smoother translate:nPoint];
//				
//				[touchData addObject:[NSString stringWithFormat:@"%0.0f,%0.0f", nPoint.x, nPoint.y]];
//			}
//		}
//		
//		userInfo = [NSDictionary dictionaryWithObject:[NSArray arrayWithArray:touchData] forKey:@"touchData"];
//		[touchData release];
//
//		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:touchID object:[self className] userInfo:userInfo deliverImmediately:YES];
//	}
}

#pragma mark Battery level indicator

/* Show the battery level on the WiiMote */

- (void)blinkLed1 {
	BOOL led1;
	if (self.led1Blink) {
		led1 = NO;
		self.led1Blink = NO;
	} else {
		led1 = YES;
		self.led1Blink = YES;
	}
	[wii setLEDEnabled1:led1 enabled2:NO enabled3:NO enabled4:NO];
}

- (void)batteryLevelChanged:(double)level {
#if DEBUG
	NSLog(@"Battery level changed: %f", level);
#endif
	self.batteryLevel = (int)(level*100);
	BOOL led1 = NO, led2 = NO, led3 = NO, led4 = NO;
	if (self.batteryLevel > 75) {
		led1 = YES;
		led2 = YES;
		led3 = YES;
		led4 = YES;
	} else if (self.batteryLevel > 50) {
		led1 = YES;
		led2 = YES;
		led3 = YES;
	} else if (self.batteryLevel > 25) {
		led1 = YES;
		led2 = YES;
	} else if (self.batteryLevel > 10) {
		led1 = YES;
	}
	[wii setLEDEnabled1:led1 enabled2:led2 enabled3:led3 enabled4:led4];
	if (self.batteryLevel <= 10) {
		[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(blinkLed1) userInfo:nil repeats:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[findWiiMoteButton release];
	[wiiProgressIndicator release];
	[wiiStatusLabel release];
	[irButton release];
	[batteryLevelUI release];
	[greenLED release];
	[redLED release];
	// Warper
	[warper release];
	// Smoother
	[smoother release];
	// Super
	[super dealloc];
}

@end
