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

-(UIImage*) adjustedMaskStyle
{
    CGPoint pointsPos[self.outlinePoints.count];
    // get 10 points
    for (int i = 0; i < self.outlinePoints.count; i++){
        pointsPos[i] = [[self.outlinePoints objectAtIndex:i] CGPointValue];
    }
    
    UIGraphicsBeginImageContext(self.originalImage.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill((CGRect){{0,0}, self.originalImage.size});
    // just leave the mouth
    [[UIColor colorWithWhite:0.0f alpha:1.0f] setFill];
    [self.getoutlineBezierPath fill];
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
