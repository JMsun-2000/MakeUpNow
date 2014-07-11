//
//  TestFaceTracingViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 7/10/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "TestFaceTracingViewController.h"

@interface TestFaceTracingViewController ()
@property (nonatomic, strong) UIImage *m_originalImage;
@property (nonatomic, readonly) CGFloat curScaleFactor;
@property (nonatomic, readonly) CGSize sizeAfterScale;
@property (nonatomic, strong) UIImage *m_scaledImage;
@property (nonatomic, readonly) CGRect faceBounds;
@property (nonatomic, readonly) CGPoint leftEyePosition;
@property (nonatomic, readonly) CGPoint rightEyePosition;
@property (nonatomic, readonly) CGPoint mouthPosition;
@end

@implementation TestFaceTracingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_originalImage = [UIImage imageWithCGImage:self.faceRef];
    // initialize scaled the size
    [self scaledFactor:[[UIScreen mainScreen] bounds]];
    UIImage* afterconverted = [self getScaledImage];
    [self detectorFacefromPhoto:[CIImage imageWithCGImage:afterconverted.CGImage]];
    
    imageFace.image = [self CreateDetectorResult:afterconverted];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)detectorFacefromPhoto:(CIImage *)photo{

    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    NSArray* features = [faceDetector featuresInImage:photo];
    
    for (CIFaceFeature* faceFeature in features){
        _faceBounds = faceFeature.bounds;
        
        _faceBounds.origin.y = self.sizeAfterScale.height - _faceBounds.size.height/_curScaleFactor;
        
        // left eye
        if (faceFeature.hasLeftEyePosition){
            _leftEyePosition = faceFeature.leftEyePosition;
            _leftEyePosition.y = self.sizeAfterScale.height - _leftEyePosition.y;
        }
        
        // right eye
        if (faceFeature.hasRightEyePosition){
            _rightEyePosition = faceFeature.rightEyePosition;
            _rightEyePosition.y = self.sizeAfterScale.height - _rightEyePosition.y;
        }
        
        // mouth
        if (faceFeature.hasMouthPosition){
            _mouthPosition = faceFeature.mouthPosition;
            _mouthPosition.y = self.sizeAfterScale.height - _mouthPosition.y;
        }
        
        // just one face now
        break;
    }
    
}

-(void)scaledFactor:(CGRect)boxBounds
{
    CGFloat imageWidth = [self.m_originalImage size].width;
    CGFloat imageHeight = [self.m_originalImage size].height;
    CGFloat screenWidth = boxBounds.size.width;
    CGFloat screenHeight = boxBounds.size.height;
    
    _curScaleFactor = 1.0f;
    
    // check for a  most suitable factor
    if ((imageHeight > imageWidth) && (imageHeight > screenHeight)){
        _curScaleFactor = imageHeight / screenHeight;
    }
    else if ((imageWidth >= imageHeight) && (imageHeight > screenWidth)){
        _curScaleFactor = imageWidth / screenWidth;
    }
    
    _sizeAfterScale.width = imageWidth/self.curScaleFactor;
    _sizeAfterScale.height = imageHeight/self.curScaleFactor;
}

- (UIImage*)getScaledImage
{
    
    UIGraphicsBeginImageContextWithOptions(self.sizeAfterScale, NO, 0.0);
    [self.m_originalImage drawInRect:CGRectMake(0, 0, self.sizeAfterScale.width, self.sizeAfterScale.height)];
    self.m_scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return self.m_scaledImage;
}

-(UIImage*) CreateDetectorResult:(UIImage*)source{
    CGImageRef sourceImage = [source CGImage];

    
    UIGraphicsBeginImageContext(source.size);
    [source drawAtPoint:CGPointZero];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // draw face
    // scale the transform
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect faceArea = _faceBounds;
    CGPathAddRect(path, NULL, faceArea);
    [[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw left eye
    path = CGPathCreateMutable();
    CGPoint leftEyePos = _leftEyePosition;
    CGRect leftEyeArea = CGRectMake(leftEyePos.x - faceArea.size.width * 0.01f,
                                    leftEyePos.y - faceArea.size.width * 0.01f,
                                    faceArea.size.width * 0.02f, faceArea.size.width * 0.02f);
    CGPathAddRect(path, NULL, leftEyeArea);
    [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw right eye
    path = CGPathCreateMutable();
    CGPoint rightEyePos = _rightEyePosition;
    CGRect rightEyeArea = CGRectMake(rightEyePos.x - faceArea.size.width * 0.1f,
                                     rightEyePos.y - faceArea.size.width * 0.1f,
                                     faceArea.size.width * 0.2f, faceArea.size.width * 0.2f);
    CGPathAddRect(path, NULL, rightEyeArea);
    [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    // draw mouth
    path = CGPathCreateMutable();
    CGPoint mouthPos = _mouthPosition;
    CGRect mouthArea = CGRectMake(mouthPos.x - faceArea.size.width * 0.1f,
                                  mouthPos.y - faceArea.size.width * 0.1f,
                                  faceArea.size.width * 0.2f, faceArea.size.width * 0.2f);
    CGPathAddRect(path, NULL, mouthArea);
    [[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.3] setFill];
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return newImg;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
