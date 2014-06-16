//
//  MakeupViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "MakeupViewController.h"
#import "FaceDataManager.h"
#import "BezierCreatorUtils.h"
#define ZOOM_STEP 2.0



@interface MakeupViewController ()
@property (atomic) UIImageView *originalImageView;
@property (atomic) UIImageView *leftEyeMaskImageView;
@property (atomic) UIImageView *rightEyeMaskImageView;
@property (atomic) UIImageView *mouthMaskImageView;
@end

@implementation MakeupViewController
@synthesize imageScrollView, originalImageView, leftEyeMaskImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImage *image = [[FaceDataManager getInstance] getOriginalImage];
    // Do any additional setup after loading the view from its nib    
    
    //Setting up the scrollView
    imageScrollView.bouncesZoom = YES;
    imageScrollView.delegate = self;
    imageScrollView.clipsToBounds = YES;
    
    //Setting up the imageView
    originalImageView = [[UIImageView alloc] initWithImage:image];
    originalImageView.userInteractionEnabled = YES;
    // add mask view
    leftEyeMaskImageView = [[UIImageView alloc] initWithFrame:[[FaceDataManager getInstance] getLeftEyeBounds]];
    [originalImageView addSubview:leftEyeMaskImageView];
    
    //Adding the imageView to the scrollView as subView
    [imageScrollView addSubview:originalImageView];
    imageScrollView.contentSize = CGSizeMake(originalImageView.bounds.size.width, originalImageView.bounds.size.height);
    imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //UITapGestureRecognizer set up
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    //Adding gesture recognizer
    [originalImageView addGestureRecognizer:doubleTap];
    [originalImageView addGestureRecognizer:twoFingerTap];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [[FaceDataManager getInstance] getFaceScaledRatio];//This is the minimum scale, set it to whatever you want. 1.0 = default
    
    
    imageScrollView.maximumZoomScale = 2.0;
    imageScrollView.minimumZoomScale = minimumScale;
    imageScrollView.zoomScale = minimumScale;
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
    [originalImageView sizeToFit];
    [imageScrollView setContentSize:CGSizeMake(originalImageView.frame.size.width, originalImageView.frame.size.height)];
    
    // add listener
    // Add mask button
    [doEyeMaskButton addTarget:self action:@selector(doMaskEye) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect initalFrame = originalImageView.frame;
    initalFrame.origin = [[FaceDataManager getInstance] getFaceScaledOffset];
    originalImageView.frame = initalFrame;
}

-(void)doMaskEye
{
    UIImage *maskedImage = [[FaceDataManager getInstance] getLeftEyeMask];
    leftEyeMaskImageView.backgroundColor = [UIColor colorWithPatternImage:maskedImage];
}

-(UIImage*)getLeftEyeMask
{
    NSMutableArray* leftEyepoints = [[FaceDataManager getInstance] getOriginalLeftEyePoints];
    CGPoint pointsPos[leftEyepoints.count];
    // get 4 points
    for (int i = 0; i < leftEyepoints.count; i++){
        pointsPos[i] = [[leftEyepoints objectAtIndex:i] CGPointValue];
    }
    
    UIImage *leftEye = [[FaceDataManager getInstance] getOriginalImage];
    CGRect canvesRect = CGRectMake(0.0f, 0.0f, leftEye.size.width, leftEye.size.height);
    
    // Add Color by draw context
    UIGraphicsBeginImageContext(leftEye.size);
    CGContextRef oldContext = UIGraphicsGetCurrentContext();
    [leftEye drawAtPoint:CGPointZero];
    // save context
    CGContextSaveGState(oldContext);
    
    // Overlay red color
    CGContextSetBlendMode(oldContext, kCGBlendModeOverlay);
    // draw red
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, canvesRect);
    [[UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.0f] setFill];
    CGContextAddPath(oldContext, path);
    CGContextDrawPath(oldContext, kCGPathFill);
    CGPathRelease(path);
    
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
    UIImage *source = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // test for step1
    //return source;
    
    // Add alpha mask
    UIImage *maskOriginal = [UIImage imageNamed:@"eyeshadow-test-samples-L.jpg"];
    // Scale and rotation mask
/*    CGFloat curXDist = pointsPos[2].x - pointsPos[0].x;
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
    xOffset = pointsPos[2].x-xOffset;
    yOffset = pointsPos[2].y-yOffset;
    
    UIGraphicsBeginImageContext(leftEye.size);
    oldContext = UIGraphicsGetCurrentContext();
    // save context
    CGContextSaveGState(oldContext);
    [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    UIRectFill(canvesRect);
    [maskOriginal drawInRect:CGRectMake(xOffset, yOffset, realWidth, realHeigth)];
    // move the polygon of eye
    [[BezierCreatorUtils getBezierPath:EYE_POLYGON Points:leftEyepoints] fill];
 
    // recovery environment and save new Image
    CGContextRestoreGState(oldContext);
 */
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // test for step2
    //return maskImage;
    
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

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    CGFloat offsetX = (imageScrollView.bounds.size.width > imageScrollView.contentSize.width)?
    (imageScrollView.bounds.size.width - imageScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (imageScrollView.bounds.size.height > imageScrollView.contentSize.height)?
    (imageScrollView.bounds.size.height - imageScrollView.contentSize.height) * 0.5 : 0.0;
    originalImageView.center = CGPointMake(imageScrollView.contentSize.width * 0.5 + offsetX,
                                   imageScrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return originalImageView;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    
    if (newScale > self.imageScrollView.maximumZoomScale){
        newScale = self.imageScrollView.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [imageScrollView zoomToRect:zoomRect animated:YES];
        
    }
    else{
        
        newScale = self.imageScrollView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [imageScrollView zoomToRect:zoomRect animated:YES];
    }
}


- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
