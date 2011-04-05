//
//  Warper.h
//  WiiTabla
//
//  Created by Jernej Strasner on 4/5/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Warper : NSObject {
	float srcX[4];
	float srcY[4];
	float dstX[4];
	float dstY[4];
	float srcMat[16];
	float dstMat[16];
	float warpMat[16];
	bool dirty;	
}

- (void)setIdentity;
- (void)computeQuadToSquare;
- (void)computeSquareToQuad;
- (void)computeSquareToQuadSrc;
- (void)multiplySourceAndDestinationMatrices;
- (CGPoint)warpMatrix:(float[16])mat sourcePoint:(CGPoint)sp;

- (void)setSource:(CGPoint [])sourcePoints;
- (void)setDestination:(CGPoint [])destinationPoints;
- (void)computeWarp;
- (CGPoint)warpSourcePoint:(CGPoint)sp;

@end
