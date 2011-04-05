//
//  Warper.m
//  WiiTabla
//
//  Created by Jernej Strasner on 4/5/10.
//  Copyright 2010 JernejStrasner.com. All rights reserved.
//

#import "Warper.h"

@implementation Warper

- (id)init {
	self = [super init];
	if (self) {
		[self setIdentity];
	}
	return self;
}
		
- (void)setIdentity {
	CGPoint sPoints[4] = {
		CGPointMake(0.0, 0.0),
		CGPointMake(1.0, 0.0),
		CGPointMake(0.0, 1.0),
		CGPointMake(1.0, 1.0)
	};
	
	[self setSource:sPoints];

	CGPoint dPoints[4] = {
		CGPointMake(0.0, 0.0),
		CGPointMake(1.0, 0.0),
		CGPointMake(0.0, 1.0),
		CGPointMake(1.0, 1.0)
	};
	
	[self setDestination:dPoints];

	[self computeWarp];
}

- (void)setSource:(CGPoint[4])sourcePoints {
	int i;
	for (i = 0; i < 4; i++) {
		srcX[i] = sourcePoints[i].x;
		srcY[i] = sourcePoints[i].y;
	}
	
	dirty = true;
}

- (void)setDestination:(CGPoint[4])destinationPoints {
	int i;
	for (i = 0; i < 4; i++) {
		dstX[i] = destinationPoints[i].x;
		dstY[i] = destinationPoints[i].y;
	}
	
	dirty = true;
}

- (void)computeWarp {
	[self computeQuadToSquare];
	[self computeSquareToQuad];

	[self multiplySourceAndDestinationMatrices];

	dirty = false;
}

- (void)multiplySourceAndDestinationMatrices {
	for (int r = 0; r < 4; r++)
	{
		int ri = r * 4;
		
		for (int c = 0; c < 4; c++)
		{
			warpMat[ri + c] = (srcMat[ri] * dstMat[c] +
							  srcMat[ri + 1] * dstMat[c + 4] +
							  srcMat[ri + 2] * dstMat[c + 8] +
							  srcMat[ri + 3] * dstMat[c + 12]);
		}
	}
}
		
- (void)computeSquareToQuad {
	float x0 = dstX[0], y0 = dstY[0];
	float x1 = dstX[1], y1 = dstY[1];
	float x2 = dstX[2], y2 = dstY[2];
	float x3 = dstX[3], y3 = dstY[3];
	
	float dx1 = x1 - x2, dy1 = y1 - y2;
	float dx2 = x3 - x2, dy2 = y3 - y2;
	
	float sx = x0 - x1 + x2 - x3;
	float sy = y0 - y1 + y2 - y3;
	
	float g = (sx * dy2 - dx2 * sy) / (dx1 * dy2 - dx2 * dy1);
	float h = (dx1 * sy - sx * dy1) / (dx1 * dy2 - dx2 * dy1);
	
	float a = x1 - x0 + g * x1;
	float b = x3 - x0 + h * x3;
	
	float c = x0;
	float d = y1 - y0 + g * y1;
	float e = y3 - y0 + h * y3;
	float f = y0;
	
	dstMat[	0] = a;	dstMat[ 1] = d;	dstMat[ 2] = 0;	dstMat[ 3] = g;
	dstMat[	4] = b;	dstMat[ 5] = e;	dstMat[ 6] = 0;	dstMat[ 7] = h;
	dstMat[	8] = 0;	dstMat[ 9] = 0;	dstMat[10] = 1;	dstMat[11] = 0;
	dstMat[12] = c;	dstMat[13] = f;	dstMat[14] = 0;	dstMat[15] = 1;
}

- (void)computeSquareToQuadSrc {
	float x0 = srcX[0], y0 = srcY[0];
	float x1 = srcX[1], y1 = srcY[1];
	float x2 = srcX[2], y2 = srcY[2];
	float x3 = srcX[3], y3 = srcY[3];
	
	float dx1 = x1 - x2, dy1 = y1 - y2;
	float dx2 = x3 - x2, dy2 = y3 - y2;
	
	float sx = x0 - x1 + x2 - x3;
	float sy = y0 - y1 + y2 - y3;
	
	float g = (sx * dy2 - dx2 * sy) / (dx1 * dy2 - dx2 * dy1);
	float h = (dx1 * sy - sx * dy1) / (dx1 * dy2 - dx2 * dy1);
	
	float a = x1 - x0 + g * x1;
	float b = x3 - x0 + h * x3;
	
	float c = x0;
	float d = y1 - y0 + g * y1;
	float e = y3 - y0 + h * y3;
	float f = y0;
	
	srcMat[	0] = a;	srcMat[ 1] = d;	srcMat[ 2] = 0;	srcMat[ 3] = g;
	srcMat[	4] = b;	srcMat[ 5] = e;	srcMat[ 6] = 0;	srcMat[ 7] = h;
	srcMat[	8] = 0;	srcMat[ 9] = 0;	srcMat[10] = 1;	srcMat[11] = 0;
	srcMat[12] = c;	srcMat[13] = f;	srcMat[14] = 0;	srcMat[15] = 1;	
}

- (void)computeQuadToSquare {
	
	[self computeSquareToQuadSrc];
	
	float a = srcMat[ 0], d = srcMat[ 1], g = srcMat[ 3];
	float b = srcMat[ 4], e = srcMat[ 5], h = srcMat[ 7];

	float c = srcMat[12],	f = srcMat[13];
	
	float A =     e - f * h;
	float B = c * h - b;
	float C = b * f - c * e;
	float D = f * g - d;
	float E =     a - c * g;
	float F = c * d - a * f;
	float G = d * h - e * g;
	float H = b * g - a * h;
	float I = a * e - b * d;
	
	float idet = 1.0f / (a * A           + b * D           + c * G);
	
	srcMat[ 0] = A * idet;	srcMat[ 1] = D * idet;	srcMat[ 2] = 0;	srcMat[ 3] = G * idet;
	srcMat[ 4] = B * idet;	srcMat[ 5] = E * idet;	srcMat[ 6] = 0;	srcMat[ 7] = H * idet;
	srcMat[ 8] = 0       ;	srcMat[ 9] = 0       ;	srcMat[10] = 1;	srcMat[11] = 0       ;
	srcMat[12] = C * idet;	srcMat[13] = F * idet;	srcMat[14] = 0;	srcMat[15] = I * idet;
}

- (CGPoint)warpSourcePoint:(CGPoint)sp {
	if (dirty) {
		[self computeWarp];
	}
	
	CGPoint retPoint = [self warpMatrix:warpMat sourcePoint:sp];
	
	return retPoint;
}

- (CGPoint)warpMatrix:(float[16])mat sourcePoint:(CGPoint)sp {
	float result[4];
	float z = 0;

	result[0] = (float)(sp.x * mat[0] + sp.y * mat[4] + z * mat[8] + 1 * mat[12]);
	result[1] = (float)(sp.x * mat[1] + sp.y * mat[5] + z * mat[9] + 1 * mat[13]);
	result[2] = (float)(sp.x * mat[2] + sp.y * mat[6] + z * mat[10] + 1 * mat[14]);
	result[3] = (float)(sp.x * mat[3] + sp.y * mat[7] + z * mat[11] + 1 * mat[15]);
	
	return CGPointMake(result[0] / result[3], result[1] / result[3]);
}

@end