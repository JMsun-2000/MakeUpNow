//
//  LeftBrowData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/30/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "LeftBrowData.h"

@implementation LeftBrowData

CGFloat const DEFAULT_BROW_SHADOW_WIDTH = 372.0f;
CGFloat const DEFAULT_BROW_SHADOW_HEIGHT = 150.0f;
CGFloat const LEFTBROW_REFERENCE_POINT_X = 436.0f;
CGFloat const LEFTBROW_REFERENCE_POINT_Y = 153.0f;

-(instancetype)init{
    self = super.init;
    if (self){
        curMaskStyleName = @"brows-test-sample-L.jpg";
        referencePointBeginIndex = 2;
        referencePointEndIndex = 0;
        refrencePointOffset = CGPointMake(LEFTBROW_REFERENCE_POINT_X, LEFTBROW_REFERENCE_POINT_Y);
        
    }
    
    return self;
}

-(UIImage*) adjustedMaskStyle
{
    CGPoint pointsPos[self.outlinePoints.count];
    // get 3 points
    for (int i = 0; i < self.outlinePoints.count; i++){
        pointsPos[i] = [[self.outlinePoints objectAtIndex:i] CGPointValue];
    }
    // Add shape of mask
    UIImage *maskOriginal = [UIImage imageNamed:curMaskStyleName];
    // Scale and rotation mask
    CGFloat curXDist = pointsPos[2].x - pointsPos[0].x;
    CGFloat curYDist = pointsPos[2].y - pointsPos[0].y;
    CGFloat curBrowDistance = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    curXDist = pointsPos[referencePointEndIndex].x - pointsPos[1].x;
    curYDist = pointsPos[referencePointEndIndex].y - pointsPos[1].y;
    CGFloat curBroweight = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    CGFloat xScaleFactor = curBrowDistance/DEFAULT_BROW_SHADOW_WIDTH;
    CGFloat yScaleFactor = curBroweight/DEFAULT_BROW_SHADOW_HEIGHT;
    CGFloat realWidth = maskOriginal.size.width * xScaleFactor;
    CGFloat realHeigth = maskOriginal.size.height * yScaleFactor;
    CGFloat xOffset = refrencePointOffset.x * xScaleFactor;
    CGFloat yOffset = refrencePointOffset.y * yScaleFactor;
    xOffset = pointsPos[referencePointBeginIndex].x-xOffset-self.maskLayerbounds.origin.x;
    yOffset = pointsPos[referencePointBeginIndex].y-yOffset-self.maskLayerbounds.origin.y;
    
    UIGraphicsBeginImageContext(self.originalImage.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill((CGRect){{0,0}, self.originalImage.size});
    [maskOriginal drawInRect:CGRectMake(xOffset, yOffset, realWidth, realHeigth)];

    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskImage;
}
@end
