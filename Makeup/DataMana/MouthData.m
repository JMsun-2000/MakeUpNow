//
//  MouthData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/23/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "MouthData.h"
#import "BezierCreatorUtils.h"

@implementation MouthData
CGFloat const DEFAULT_MOUTH_SHADOW_WIDTH = 426.0f;
CGFloat const DEFAULT_MOUTH_SHADOW_HEIGHT = 167.0f;
CGFloat const MOUTH_REFERENCE_POINT_X = 271.0f;
CGFloat const MOUTH_REFERENCE_POINT_Y = 54.0f;

-(instancetype)init{
    self = super.init;
    if (self){
        curMaskStyleName = @"lip-test-sample-1.jpg";
        refrencePointOffset = CGPointMake(MOUTH_REFERENCE_POINT_X, MOUTH_REFERENCE_POINT_Y);
        
    }
    
    return self;
}

-(UIImage*) adjustedMaskStyle
{
    CGPoint pointsPos[self.outlinePoints.count];
    // get all points
    for (int i = 0; i < self.outlinePoints.count; i++){
        pointsPos[i] = [[self.outlinePoints objectAtIndex:i] CGPointValue];
    }
    // Add shape of mask
    UIImage *maskOriginal = [UIImage imageNamed:curMaskStyleName];
    // Scale and rotation mask
    CGFloat curMouthWidth = pointsPos[5].x - pointsPos[0].x;
    CGFloat curMouthHeight = pointsPos[8].y - pointsPos[3].y;
    
    CGFloat xScaleFactor = curMouthWidth/DEFAULT_MOUTH_SHADOW_WIDTH;
    CGFloat yScaleFactor = curMouthHeight/DEFAULT_MOUTH_SHADOW_HEIGHT;
    CGFloat realWidth = maskOriginal.size.width * xScaleFactor;
    CGFloat realHeigth = maskOriginal.size.height * yScaleFactor;
    CGFloat xOffset = refrencePointOffset.x * xScaleFactor;
    CGFloat yOffset = refrencePointOffset.y * yScaleFactor;
    xOffset = pointsPos[3].x-xOffset-self.maskLayerbounds.origin.x;
    yOffset = pointsPos[3].y-yOffset-self.maskLayerbounds.origin.y;
    
    UIGraphicsBeginImageContext(self.originalImage.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill((CGRect){{0,0}, self.originalImage.size});
    [maskOriginal drawInRect:CGRectMake(xOffset, yOffset, realWidth, realHeigth)];
    // remove the polygon of eye
    //[self.getoutlineBezierPath fill];
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskImage;
}

-(UIBezierPath*)getoutlineBezierPath{
    CGPoint p = CGPointMake(0, 0);
    p.x -= self.maskLayerbounds.origin.x;
    p.y -= self.maskLayerbounds.origin.y;
    return [BezierCreatorUtils getMouthPath:self.outlinePoints offset:p];
}

@end
