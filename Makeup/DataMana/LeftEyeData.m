//
//  LeftEyeData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "LeftEyeData.h"
#import "BezierCreatorUtils.h"


@implementation LeftEyeData

CGFloat const DEFAULT_LEFTEYE_SHADOW_WIDTH = 249.57563983f;
CGFloat const DEFAULT_LEFTEYE_SHADOW_HEIGHT = 100.00000f;
CGFloat const LEFTEYE_REFERENCE_POINT_X = 412.0f;
CGFloat const LEFTEYE_REFERENCE_POINT_Y = 208.0f;

-(UIBezierPath*)getoutlineBezierPath{
    CGPoint p = CGPointMake(0, 0);
    p.x -= self.maskLayerbounds.origin.x;
    p.y -= self.maskLayerbounds.origin.y;
    return [BezierCreatorUtils getEyePath:self.outlinePoints offset:p];
}

-(UIImage*)getMaskImage{
    CGPoint pointsPos[self.outlinePoints.count];
    // get 4 points
    for (int i = 0; i < self.outlinePoints.count; i++){
        pointsPos[i] = [[self.outlinePoints objectAtIndex:i] CGPointValue];
    }
    
    CGRect canvesRect = CGRectMake(0.0f, 0.0f, self.originalImage.size.width, self.originalImage.size.height);
    
    // Add Color of mask by draw context
    UIGraphicsBeginImageContext(self.originalImage.size);
    [self.originalImage drawAtPoint:CGPointZero];
    
    // change canves to Overlay mode
    // save context
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(oldContext);
    CGContextSetBlendMode(oldContext, kCGBlendModeOverlay);
    // draw mask color
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, canvesRect);
    [[UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.0f] setFill];
    CGContextAddPath(oldContext, path);
    CGContextDrawPath(oldContext, kCGPathFill);
    CGPathRelease(path);
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    
    // test for step1
    // get step 1 result
    UIImage *source = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    return source;
    
    // Add shape of mask
    UIImage *maskOriginal = [UIImage imageNamed:@"eyeshadow-test-samples-L.jpg"];
    // Scale and rotation mask
    CGFloat curXDist = pointsPos[2].x - pointsPos[0].x;
    CGFloat curYDist = pointsPos[2].y - pointsPos[0].y;
    CGFloat curEyeDistance = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    curXDist = pointsPos[3].x - pointsPos[1].x;
    curYDist = pointsPos[3].y - pointsPos[1].y;
    CGFloat curEyeHeight = sqrt((curXDist*curXDist)+(curYDist*curYDist));
    CGFloat xScaleFactor = curEyeDistance/DEFAULT_LEFTEYE_SHADOW_WIDTH;
    CGFloat yScaleFactor = curEyeHeight/DEFAULT_LEFTEYE_SHADOW_HEIGHT;
    CGFloat realWidth = maskOriginal.size.width * xScaleFactor;
    CGFloat realHeigth = maskOriginal.size.height * yScaleFactor;
    CGFloat xOffset = LEFTEYE_REFERENCE_POINT_X * xScaleFactor;
    CGFloat yOffset = LEFTEYE_REFERENCE_POINT_Y * yScaleFactor;
    xOffset = pointsPos[2].x-xOffset-self.maskLayerbounds.origin.x;
    yOffset = pointsPos[2].y-yOffset-self.maskLayerbounds.origin.y;
    
    UIGraphicsBeginImageContext(self.originalImage.size);
    oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill(canvesRect);
    [maskOriginal drawInRect:CGRectMake(xOffset, yOffset, realWidth, realHeigth)];
    // remove the polygon of eye
    [self.getoutlineBezierPath fill];
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // test for step2
//    return maskImage;
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [source CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)){
        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    //Added extra render step to force it to save correct alpha values (not the mask)
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    UIGraphicsBeginImageContext(retImage.size);
    [retImage drawAtPoint:CGPointZero];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    retImage = nil;
    
    return newImg;
}
@end
