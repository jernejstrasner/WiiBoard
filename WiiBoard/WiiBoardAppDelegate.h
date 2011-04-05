//
//  WiiBoardAppDelegate.h
//  WiiTabla
//
//  Created by Jernej Strasner on 1/5/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

#import "irTocke.h"
#import "CalibrateWindow.h"
#import "CalibrateView.h"
#import "CalibrationView.h"

#import "Warper.h"
#import "SmoothingAverage.h"
#import "SmoothingAdaptive.h"


typedef struct {
	CGPoint topLeft, topRight, bottomRight, bottomLeft;
} KData;


@interface WiiBoardAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSWindow *window;
	NSButton *findWiiMoteButton;
	NSProgressIndicator *wiiProgressIndicator;
	NSTextField *wiiStatusLabel;
	NSButton *irButton;
	NSLevelIndicator *batteryLevelUI;
	NSButton *greenLED;
	NSButton *redLED;
	irTocke *irTockeController;
	
	WiiRemoteDiscovery *wiiDiscovery;
	WiiRemote *wii;
	
	BOOL IRSensorState;
	int batteryLevel;
	BOOL led1Blink;
	
	IRData tempIRData[4];
	
	BOOL isSimulatingMouse;
	BOOL isMultitouchEnabled;
	BOOL isCalibrating;
	int calibrationProcess;
	// Calibration data
	KData calibData;
	BOOL isMouseDown;
	BOOL isTouchDown;
	CalibrateWindow *calibrateWindow;
	
	Warper *warper;
	SmoothingAverage *smoother;
	int numOfIRPoints;
//	SmoothingAdaptive *smoother;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSButton *findWiiMoteButton;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *wiiProgressIndicator;
@property (nonatomic, retain) IBOutlet NSTextField *wiiStatusLabel;
@property (nonatomic, retain) IBOutlet NSButton *irButton;
@property (nonatomic, retain) IBOutlet NSLevelIndicator *batteryLevelUI;
@property (nonatomic, retain) IBOutlet NSButton *greenLED;
@property (nonatomic, retain) IBOutlet NSButton *redLED;
@property (nonatomic, retain) irTocke *irTockeController;

@property (assign) BOOL IRSensorState;
@property (assign) BOOL isMultitouchEnabled;
@property (assign) BOOL led1Blink;
@property (assign) int batteryLevel;
@property (assign) int numOfIRPoints;

- (IBAction)startWiiMoteDiscovery:(id)sender;
- (IBAction)toggleIRState:(id)sender;
- (IBAction)disconnectWiiMote:(id)sender;
- (IBAction)showIRTockePanel:(id)sender;
- (IBAction)toggleMouse:(id)sender;
- (IBAction)calibrateMouse:(id)sender;
- (void)resetCalibration;
- (IBAction)trackingArea:(id)sender;
- (void)commitCalibration;
- (void)blinkLed1;

@end
