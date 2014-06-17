//
//  FaceDataManager.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "FaceDataManager.h"
#import <CoreImage/CoreImage.h>
#import "LeftEyeData.h"
#import "RightEyeData.h"

#define ADJUST_FACE_OFFSET_FOR_JAW 0.4f
#define RATIO_GUESS_EYE_SCOPE 2.0f

static FaceDataManager *instance = nil;

@interface FaceDataManager()
@property (nonatomic, strong) UIImage* originalImage;
@end

@implementation FaceDataManager{
    CGSize originalImageSize;
    // for face
    CGFloat faceScaleFactorS2W;
    CGFloat offsetOfShowFaceX;
    CGFloat offsetOfShowFaceY;
    CGRect corpFaceInPic;
    CGRect faceBounds;
    // for eye
    
    CGFloat eyesScaleFactorS2W;
    CGFloat offsetOfShowEyeX;
    CGFloat offsetOfShowEyeY;
    CGRect corpEyesInPic;
    // for mouth
    CGPoint mouthPosition;
    CGFloat offsetOfShowMouthX;
    CGFloat offsetOfShowMouthY;
}


@synthesize asset;
@synthesize savedFacePoints;

@synthesize savedLeftBrowPoints;
@synthesize savedRightBrowPoints;
@synthesize savedMouthPoints;

+(FaceDataManager *)getInstance
{
    if (instance == nil){
        // Create instance
        instance = [[FaceDataManager alloc] init];
    }
    
    return instance;
}

// initialize inner data
-(id)init{
    if (self = [super init]) {
        // create sub data
        self.leftEye = [[LeftEyeData alloc] init];
        self.rightEye = [[RightEyeData alloc] init];
    }
    
    return self;
}

-(UIImage*)getOriginalImage
{
    return self.originalImage;
}

-(UIImage*)getFacePhoto:(CGSize)windowSize
{
    // initial the scale factor
    faceScaleFactorS2W = 1.0f;
    
    UIImage *imgReturn;
    
    // check the face size
    if (faceBounds.size.width > windowSize.width || faceBounds.size.height > windowSize.height){

        if (windowSize.width > windowSize.height){
            // use width to fit
            faceScaleFactorS2W = windowSize.width / originalImageSize.width;
        }
        else{
            faceScaleFactorS2W = windowSize.height / originalImageSize.height;
        }
        
        // original picture after scale size
        CGSize afterScale;
        afterScale.width = originalImageSize.width * faceScaleFactorS2W;
        afterScale.height = originalImageSize.height * faceScaleFactorS2W;
        
        if (windowSize.width > windowSize.height){
            offsetOfShowFaceY = (windowSize.height - afterScale.height)/2;
        }
        else{
            offsetOfShowFaceX = (windowSize.width - afterScale.width)/2;
        }
        
        UIGraphicsBeginImageContextWithOptions(windowSize, NO, 0.0);
        [self.originalImage drawInRect:CGRectMake(offsetOfShowFaceX, offsetOfShowFaceY, afterScale.width, afterScale.height)];
        imgReturn = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else{
        // face center
        CGPoint centerPos = [self getCenter:faceBounds];
        // just corp from original picture
        corpFaceInPic= CGRectMake(centerPos.x - windowSize.width/2.0f, centerPos.y - windowSize.height/2.0f, windowSize.width, windowSize.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.originalImage CGImage], corpFaceInPic);
        imgReturn = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }

    return imgReturn;
}

-(UIImage*)getEyesPhoto:(CGSize)windowSize
{
    // get eye distance
    CGFloat eyeDistance = self.rightEye.position.x - self.leftEye.position.x;
    
    // initial the scale factor
    eyesScaleFactorS2W = 1.0f;
    UIImage *imgReturn;
    
    CGPoint eyeCenterPoint = [self getCenter:self.rightEye.position another:self.leftEye.position];
    
    // check the width of screen
    if (eyeDistance * RATIO_GUESS_EYE_SCOPE > windowSize.width){
        // have to scale the original photo
        eyesScaleFactorS2W = windowSize.width / (eyeDistance * RATIO_GUESS_EYE_SCOPE);
        
        // original picture after scale size
        CGSize afterScale;
        afterScale.width = originalImageSize.width * eyesScaleFactorS2W;
        afterScale.height = originalImageSize.height * eyesScaleFactorS2W;
        
        // get the offest to draw on canvas
        offsetOfShowEyeX = windowSize.width/2.0f - eyeCenterPoint.x * eyesScaleFactorS2W;
        offsetOfShowEyeY = windowSize.height/2.0f - eyeCenterPoint.y * eyesScaleFactorS2W;
        
        
        UIGraphicsBeginImageContextWithOptions(windowSize, NO, 0.0);
        [self.originalImage drawInRect:CGRectMake(offsetOfShowEyeX, offsetOfShowEyeY, afterScale.width, afterScale.height)];
        imgReturn = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else{
        // just corp from original picture
        corpEyesInPic= CGRectMake(eyeCenterPoint.x - windowSize.width/2.0f,
                                 eyeCenterPoint.y - windowSize.height/2.0f, windowSize.width, windowSize.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.originalImage CGImage], corpEyesInPic);
        imgReturn = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    return imgReturn;
}

-(UIImage*)getMouthPhoto:(CGSize)windowSize
{
    UIImage *imgReturn;
    // original picture after scale size, use same as eye for its size is suitable
    CGSize afterScale;
    afterScale.width = originalImageSize.width * eyesScaleFactorS2W;
    afterScale.height = originalImageSize.height * eyesScaleFactorS2W;
    
    // get the offest to draw on canvas
    offsetOfShowMouthX = windowSize.width/2.0f - mouthPosition.x * eyesScaleFactorS2W;
    offsetOfShowMouthY = windowSize.height/2.0f - mouthPosition.y * eyesScaleFactorS2W;
    
    
    UIGraphicsBeginImageContextWithOptions(windowSize, NO, 0.0);
    [self.originalImage drawInRect:CGRectMake(offsetOfShowMouthX, offsetOfShowMouthY, afterScale.width, afterScale.height)];
    imgReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgReturn;
}

-(NSArray*)getFaceInitialPoints
{
    // face center
    CGPoint centerPos = [self getCenter:faceBounds];
    centerPos.x = centerPos.x * faceScaleFactorS2W + offsetOfShowFaceX;
    centerPos.y = centerPos.y * faceScaleFactorS2W + offsetOfShowFaceY;
    CGPoint topLeft = faceBounds.origin;
    topLeft.x = topLeft.x * faceScaleFactorS2W + offsetOfShowFaceX;
    topLeft.y = topLeft.y * faceScaleFactorS2W + offsetOfShowFaceY;
    CGPoint bottomRight;
    bottomRight.x = topLeft.x + faceBounds.size.width * faceScaleFactorS2W;
    bottomRight.y = topLeft.y + faceBounds.size.height * faceScaleFactorS2W;
        
    CGPoint point1 = CGPointMake(centerPos.x, topLeft.y);
    CGPoint point2 = CGPointMake(bottomRight.x, centerPos.y);
    CGPoint point3 = CGPointMake((bottomRight.x + centerPos.x)/2, (centerPos.y + 2*bottomRight.y)/3);
    CGPoint point4 = CGPointMake(centerPos.x, bottomRight.y);
    CGPoint point5 = CGPointMake((topLeft.x + centerPos.x)/2, (centerPos.y + 2*bottomRight.y)/3);
    CGPoint point6 = CGPointMake(topLeft.x, centerPos.y);
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            [NSValue valueWithCGPoint:point4],
            [NSValue valueWithCGPoint:point5],
            [NSValue valueWithCGPoint:point6],
            nil];
}

-(NSArray*)getLeftEyeInitialPoints
{
    CGFloat eyeWidth = faceBounds.size.width * 0.2f / 2.0f;
    CGFloat eyeHeight = eyeWidth / 3.0f;
    
    CGPoint point1 = CGPointMake((self.leftEye.position.x - eyeWidth)*eyesScaleFactorS2W + offsetOfShowEyeX, self.leftEye.position.y * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point2 = CGPointMake(self.leftEye.position.x*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y - eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point3 = CGPointMake((self.leftEye.position.x + eyeWidth)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y + eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point4 = CGPointMake(self.leftEye.position.x*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y + eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            [NSValue valueWithCGPoint:point4],
            nil];
}

-(NSArray*)getRightEyeInitialPoints
{
    CGFloat eyeWidth = faceBounds.size.width * 0.2f / 2.0f;
    CGFloat eyeHeight = eyeWidth / 3.0f;
    
    CGPoint point1 = CGPointMake((self.rightEye.position.x - eyeWidth)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y + eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point2 = CGPointMake(self.rightEye.position.x*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y - eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point3 = CGPointMake((self.rightEye.position.x + eyeWidth)*eyesScaleFactorS2W + offsetOfShowEyeX, self.rightEye.position.y * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point4 = CGPointMake(self.rightEye.position.x*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y + eyeHeight) * eyesScaleFactorS2W + offsetOfShowEyeY);
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            [NSValue valueWithCGPoint:point4],
            nil];
}

-(NSArray*)getLeftBrowInitialPoints
{
    CGFloat eyeWidth = faceBounds.size.width * 0.2f;
    
    CGPoint point1 = CGPointMake((self.leftEye.position.x - eyeWidth*3.0f/4.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y - eyeWidth/2.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point2 = CGPointMake((self.leftEye.position.x-eyeWidth/2.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y - eyeWidth*2.0f/3.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point3 = CGPointMake((self.leftEye.position.x + eyeWidth / 2.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.leftEye.position.y - eyeWidth/3.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            nil];
}

-(NSArray*)getRightBrowInitialPoints
{
    CGFloat eyeWidth = faceBounds.size.width * 0.2f;
    
    CGPoint point1 = CGPointMake((self.rightEye.position.x - eyeWidth / 2.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y - eyeWidth/3.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point2 = CGPointMake((self.rightEye.position.x+eyeWidth/2.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y - eyeWidth*2.0f/3.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);
    CGPoint point3 = CGPointMake((self.rightEye.position.x + eyeWidth*3.0f/4.0f)*eyesScaleFactorS2W + offsetOfShowEyeX, (self.rightEye.position.y - eyeWidth/2.0f) * eyesScaleFactorS2W + offsetOfShowEyeY);

    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            nil];
}

-(NSArray*)getMouthInitialPoints
{
    CGFloat mouthDistance = (self.rightEye.position.x - self.leftEye.position.x)*eyesScaleFactorS2W/2;
    
    // use eye distance to lock the mouth area
    CGPoint point1 = CGPointMake(mouthPosition.x*eyesScaleFactorS2W - mouthDistance*3.0f/4.0f + offsetOfShowMouthX, mouthPosition.y*eyesScaleFactorS2W +mouthDistance/10.0f + offsetOfShowMouthY);
    CGPoint point4 = CGPointMake(point1.x + mouthDistance*3.0f/4.0f, point1.y - mouthDistance/5.0f);
    CGPoint point3 = CGPointMake(point4.x - mouthDistance/6.0f, point1.y - mouthDistance*3.0f/10.0f);
    CGPoint point2 = CGPointMake(point3.x - mouthDistance/6.0f, point1.y - mouthDistance/5.0f);
    CGPoint point5 = CGPointMake(point4.x + mouthDistance/6.0f, point3.y);
    CGPoint point6 = CGPointMake(point5.x + mouthDistance/6.0f, point1.y - mouthDistance/5.0f);
    CGPoint point7 = CGPointMake(point1.x + mouthDistance*3.0f/2.0f , point1.y);
    CGPoint point8 = CGPointMake(point6.x, point1.y + mouthDistance*3.0f/10.0f);
    CGPoint point9 = CGPointMake(point4.x, point1.y + mouthDistance*2.0f/5.0f);
    CGPoint point10 = CGPointMake(point2.x, point1.y + mouthDistance*3.0f/10.0f);
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1],
            [NSValue valueWithCGPoint:point2],
            [NSValue valueWithCGPoint:point3],
            [NSValue valueWithCGPoint:point4],
            [NSValue valueWithCGPoint:point5],
            [NSValue valueWithCGPoint:point6],
            [NSValue valueWithCGPoint:point7],
            [NSValue valueWithCGPoint:point8],
            [NSValue valueWithCGPoint:point9],
            [NSValue valueWithCGPoint:point10],
            nil];
}

-(CGPoint)getCenter:(CGRect)rect
{
    CGPoint ret;
    ret.x = rect.origin.x + rect.size.width/2.0f;
    ret.y = rect.origin.y + rect.size.height/2.0f;
    
    return ret;
}

-(CGPoint)getCenter:(CGPoint)point1 another:(CGPoint)point2
{
    CGPoint ret;
    ret.x = (point1.x + point2.x)/2.0f;
    ret.y = (point1.y + point2.y)/2.0f;
    return ret;
}

-(CGFloat)getFaceScaledRatio
{
    return faceScaleFactorS2W;
}

-(CGPoint)getFaceScaledOffset
{
    return CGPointMake(offsetOfShowFaceX, offsetOfShowFaceY);
}

-(NSMutableArray*)getOriginalLeftEyePoints
{
    
    return self.leftEye.outlinePoints;
}

-(void)doFaceDetector
{
    CGImageRef originalImageRef = [[asset defaultRepresentation] fullResolutionImage];
    CIImage* ciimage = [CIImage imageWithCGImage:originalImageRef];
    originalImageSize.width = CGImageGetWidth(originalImageRef);
    originalImageSize.height = CGImageGetHeight(originalImageRef);
    
    // don't need it now
    self.originalImage = [UIImage imageWithCGImage:originalImageRef];
    
    // initialize face detector
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    NSArray* features = [faceDetector featuresInImage:ciimage];
    
    for (CIFaceFeature* faceFeature in features){
        faceBounds = faceFeature.bounds;
        
        faceBounds.origin.y = originalImageSize.height - faceBounds.origin.y - faceBounds.size.height;
        
        // for the cooridate is from bottom left, so all the Y-axis need change
        // left eye
        if (faceFeature.hasLeftEyePosition){
            CGPoint pt = faceFeature.leftEyePosition;
            pt.y = originalImageSize.height - pt.y;
            self.leftEye.position = pt;
        }
        
        // right eye
        if (faceFeature.hasRightEyePosition){
            CGPoint pt = faceFeature.rightEyePosition;
            pt.y = originalImageSize.height - pt.y;
            self.rightEye.position = pt;
        }
        
        // mouth
        if (faceFeature.hasMouthPosition){
            mouthPosition = faceFeature.mouthPosition;
            mouthPosition.y = originalImageSize.height - mouthPosition.y;
        }
        
        // just one face now
        break;
    }
}

-(UIImage*)doCorp:(CGRect)corp{
    CGImageRef croppedImage = CGImageCreateWithImageInRect(self.originalImage.CGImage, corp);
    UIImage* ret = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    return ret;
}

-(void) saveLeftEyePoint:(NSArray*)points{
    // change the original coordination
    NSMutableArray* originalPoints = [self convertToOriginalCoord:points];
    [self.leftEye setOutlinePoints:originalPoints];
    
    // create bounds
    CGFloat centerPos = (self.leftEye.position.x + self.rightEye.position.x) /2.0f;
    CGFloat leftBond = faceBounds.origin.x;
    CGFloat width = centerPos - leftBond;
    CGFloat topPos = self.leftEye.position.y - width/2.0f;
    self.leftEye.maskLayerbounds = CGRectMake(leftBond, topPos, width, width);
    
    // create
    self.leftEye.originalImage = [self doCorp:self.leftEye.maskLayerbounds];
}

-(void) saveRightEyePoint:(NSArray*)points
{
    // change the original coordination
    NSMutableArray* originalPoints = [self convertToOriginalCoord:points];
    [self.rightEye setOutlinePoints:originalPoints];
    
    // create bounds
    CGFloat centerPos = (self.leftEye.position.x + self.rightEye.position.x) /2.0f;
    CGFloat rightBond = faceBounds.origin.x + faceBounds.size.width;
    CGFloat width = rightBond - centerPos;
    CGFloat topPos = self.rightEye.position.y - width/2.0f;
    self.rightEye.maskLayerbounds = CGRectMake(centerPos, topPos, width, width);
    
    // create
    self.rightEye.originalImage = [self doCorp:self.rightEye.maskLayerbounds];
}

-(NSMutableArray*) convertToOriginalCoord:(NSArray*)points{
    // change the original coordination
    NSMutableArray* retPoints = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < points.count; i++){
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        point.x = (point.x - offsetOfShowEyeX)/eyesScaleFactorS2W;
        point.y = (point.y - offsetOfShowEyeY)/eyesScaleFactorS2W;
        [retPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return retPoints;
}

-(UIImage*) getLeftEyeMask{
    return [self.leftEye getMaskImage];
}

-(UIImage*) getRightEyeMask{
    return [self.rightEye getMaskImage];
}

-(CGRect) getLeftEyeBounds{
    return self.leftEye.maskLayerbounds;
}

-(CGRect) getRightEyeBounds;{
    return self.rightEye.maskLayerbounds;
}

-(void) setLeftEyeMaskColor:(UIColor*)color
{
    self.leftEye.maskColor = color;
}

-(void) setRightEyeMaskColor:(UIColor*)color
{
    self.rightEye.maskColor = color;
}

@end
