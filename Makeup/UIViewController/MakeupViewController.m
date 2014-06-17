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
@synthesize imageScrollView;
@synthesize originalImageView;
@synthesize leftEyeMaskImageView;
@synthesize rightEyeMaskImageView;

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
	
    // init imageview and scrollview
    [self  initFaceImageView];
    [self initScrollView];
    
    // mask function
    [self initEyeMaskView];
}

-(void)initEyeMaskView{
    // add mask view
    leftEyeMaskImageView = [[UIImageView alloc] initWithFrame:[[FaceDataManager getInstance] getLeftEyeBounds]];
    rightEyeMaskImageView = [[UIImageView alloc] initWithFrame:[[FaceDataManager getInstance] getRightEyeBounds]];
    [originalImageView addSubview:leftEyeMaskImageView];
    [originalImageView addSubview:rightEyeMaskImageView];
    
    // add listener
    [doEyeMaskButton addTarget:self action:@selector(showHideColorPalette) forControlEvents:UIControlEventTouchUpInside];
    
    //UITapGestureRecognizer set up
    UITapGestureRecognizer *colorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChooseColor:)];
    [colorPalette addGestureRecognizer:colorTap];
}

-(void)initFaceImageView
{
    UIImage *image = [[FaceDataManager getInstance] getOriginalImage];
    // Do any additional setup after loading the view from its nib
    //Setting up the imageView
    originalImageView = [[UIImageView alloc] initWithImage:image];
    originalImageView.userInteractionEnabled = YES;
    
    //Adding the imageView to the scrollView as subView
    [imageScrollView addSubview:originalImageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    //Adding gesture recognizer
    [originalImageView addGestureRecognizer:doubleTap];
    [originalImageView addGestureRecognizer:twoFingerTap];
    [originalImageView sizeToFit];
}

-(void)initScrollView
{
    //Setting up the scrollView
    imageScrollView.bouncesZoom = YES;
    imageScrollView.delegate = self;
    imageScrollView.clipsToBounds = YES;
    imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [[FaceDataManager getInstance] getFaceScaledRatio];//This is the minimum scale, set it to whatever you want. 1.0 = default
    
    imageScrollView.maximumZoomScale = 2.0;
    imageScrollView.minimumZoomScale = minimumScale;
    imageScrollView.zoomScale = minimumScale;
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
    [imageScrollView setContentSize:CGSizeMake(originalImageView.frame.size.width, originalImageView.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect initalFrame = originalImageView.frame;
    initalFrame.origin = [[FaceDataManager getInstance] getFaceScaledOffset];
    originalImageView.frame = initalFrame;
}

-(void)handleChooseColor:(UITapGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateRecognized){
        CGPoint point = [recognizer locationInView:recognizer.view];
        CGSize viewSize = colorPalette.frame.size;
        CGSize imgSize = colorPalette.image.size;
        int x = point.x*imgSize.width/viewSize.width;
        int y = point.y*imgSize.height/viewSize.height;
        // set color
        UIColor* color = [self getRGBAFromImage:colorPalette.image atX:x atY:y];
        if (color == nil){
            color = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0];
        }
        [[FaceDataManager getInstance] setLeftEyeMaskColor:color];
        [[FaceDataManager getInstance] setRightEyeMaskColor:color];
        UIImage *maskedImage = [[FaceDataManager getInstance] getLeftEyeMask];
        leftEyeMaskImageView.backgroundColor = [UIColor colorWithPatternImage:maskedImage];
        maskedImage = [[FaceDataManager getInstance] getRightEyeMask];
        rightEyeMaskImageView.backgroundColor = [UIColor colorWithPatternImage:maskedImage];
    }
}

-(void)showHideColorPalette
{
    colorPalette.hidden = !colorPalette.hidden;
}

-(UIColor*)getRGBAFromImage:(UIImage*)image atX:(int)x atY:(int)y
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * y) + (x * bytesPerPixel);

    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];        
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
