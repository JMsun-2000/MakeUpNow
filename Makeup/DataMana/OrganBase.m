//
//  FaceOrgan.m
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "OrganBase.h"

@implementation OrganBase

@synthesize outlinePoints;
@synthesize originalImage;
@synthesize maskColor;

-(UIImage*)getMaskImage{
    
    // add color of mask
    UIImage *source = [self clipMaskScope];
    //    return source;
    
    // add style of mask
    UIImage* maskImage = [self adjustedMaskStyle];
    //    return maskImage;
    
    return [self createMaskByMerge:source maskImage:maskImage];
}

-(UIImage*) clipMaskScope
{
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
    CGPathAddRect(path, NULL, (CGRect){{0,0}, self.originalImage.size});
    [self.maskColor setFill];
    CGContextAddPath(oldContext, path);
    CGContextDrawPath(oldContext, kCGPathFill);
    CGPathRelease(path);
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    
    // test for step1
    // get step 1 result
    UIImage *source = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return source;
}

-(UIImage*) createMaskByMerge:(UIImage*)source maskImage:(UIImage*)maskImage{
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

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage)
{
    
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,                                                          
                                                          8, 0, colorSpace,   kCGImageAlphaPremultipliedLast );
    
    
    if (offscreenContext != NULL) {
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        
        CGContextRelease(offscreenContext);
        
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
    
}

@end
