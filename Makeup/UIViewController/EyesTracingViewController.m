//
//  EyesTracingViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 9/8/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "EyesTracingViewController.h"
#import "FaceDataManager.h"
#import "PloygonUIView.h"
#import "PloylineUIView.h"
#import "BezierCreatorUtils.h"

#define LEFT_EYE_TAG 1
#define RIGHT_EYE_TAG 2
#define LEFT_RBOW_TAG 3
#define RIGHT_RBOW_TAG 4

@interface EyesTracingViewController ()
@property (nonatomic) NSMutableArray* leftEyePointsViewArray;
@property (nonatomic) PloygonUIView*  leftEyePolygonView;
@property (nonatomic) NSMutableArray* rightEyePointsViewArray;
@property (nonatomic) PloygonUIView*  rightEyePolygonView;
@property (nonatomic) NSMutableArray* leftBrowPointsViewArray;
@property (nonatomic) PloylineUIView* leftBrowPolylineView;
@property (nonatomic) NSMutableArray* rightBrowPointsViewArray;
@property (nonatomic) PloylineUIView* rightBrowPolylineView;
@end

@implementation EyesTracingViewController{

}

-(void)dealloc
{
    for (int i = 0; i < self.leftEyePointsViewArray.count; i++)
        [[self.leftEyePointsViewArray objectAtIndex:i] release];
    [_leftEyePointsViewArray release];
    for (int i=0; i< self.rightEyePointsViewArray.count; i++)
        [[self.rightEyePointsViewArray objectAtIndex:i] release];
    [_rightEyePointsViewArray dealloc];
    for (int i=0; i< self.leftBrowPointsViewArray.count; i++)
        [[self.leftBrowPointsViewArray objectAtIndex:i] release];
    [_leftBrowPointsViewArray dealloc];
    for (int i=0; i< self.rightBrowPointsViewArray.count; i++)
        [[self.rightBrowPointsViewArray objectAtIndex:i] release];
    [_rightBrowPointsViewArray dealloc];
    [super dealloc];
}

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
    CGRect drawScope = [[UIScreen mainScreen] bounds];
    
    // draw eye image
    UIImage *image = [[FaceDataManager getInstance] getEyesPhoto:drawScope.size];
    // Do any additional setup after loading the view from its nib.
    eyeImageView = [[UIImageView alloc] initWithImage:image];
    [[self view] addSubview:eyeImageView];
    [[self view] sendSubviewToBack:eyeImageView];
    
    // adjust avoid the polys cover the bar
    drawScope.size.height -= 90;
    
    // draw left eye polygon
    NSArray* leftEyePoints = [[FaceDataManager getInstance] getLeftEyeInitialPoints];
    self.leftEyePolygonView = [[PloygonUIView alloc] initWithFrame:drawScope];
    [self.leftEyePolygonView setPolyType:EYE_POLYGON];
    [self.leftEyePolygonView setPolyPoints:leftEyePoints];
    [[self view] addSubview:self.leftEyePolygonView];

    // draw right eye polygon
    NSArray* rightEyePoints = [[FaceDataManager getInstance] getRightEyeInitialPoints];
    self.rightEyePolygonView = [[PloygonUIView alloc] initWithFrame:drawScope];
    [self.rightEyePolygonView setPolyType:EYE_POLYGON];
    [self.rightEyePolygonView setPolyPoints:rightEyePoints];
    [[self view] addSubview:self.rightEyePolygonView];
    
    // draw left brow polyline
    NSArray* leftBrowPoints = [[FaceDataManager getInstance] getLeftBrowInitialPoints];
    self.leftBrowPolylineView = [[PloylineUIView alloc] initWithFrame:drawScope];
    [self.leftBrowPolylineView setPolyType:BROW_POLYLINE];
    [self.leftBrowPolylineView setPolyPoints:leftBrowPoints];
    [[self view] addSubview:self.leftBrowPolylineView];
    
    // draw right brow polyline
    NSArray* rightBrowPoints = [[FaceDataManager getInstance] getRightBrowInitialPoints];
    self.rightBrowPolylineView = [[PloylineUIView alloc] initWithFrame:drawScope];
    [self.rightBrowPolylineView setPolyType:BROW_POLYLINE];
    [self.rightBrowPolylineView setPolyPoints:rightBrowPoints];
    [[self view] addSubview:self.rightBrowPolylineView];
    
    // !!!! control points must upper than the polygon, or user cannot do touch
    self.rightEyePointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < rightEyePoints.count; i++){
        CGPoint p = [[rightEyePoints objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        point.tag = RIGHT_EYE_TAG;
        point.movedDelegate = self;
        [self.rightEyePointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
    
    self.leftEyePointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < leftEyePoints.count; i++){
        CGPoint p = [[leftEyePoints objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        point.tag = LEFT_EYE_TAG;
        point.movedDelegate = self;
        [self.leftEyePointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
    
    self.leftBrowPointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < leftBrowPoints.count; i++){
        CGPoint p = [[leftBrowPoints objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        point.tag = LEFT_RBOW_TAG;
        point.movedDelegate = self;
        [self.leftBrowPointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
    
    self.rightBrowPointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < rightBrowPoints.count; i++){
        CGPoint p = [[rightBrowPoints objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        point.tag = RIGHT_RBOW_TAG;
        point.movedDelegate = self;
        [self.rightBrowPointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
}


- (void)onFeaturePointMoved:(int)tag;
{
    // check which point moved
    if (tag == LEFT_EYE_TAG){
        [self redrawPoly:self.leftEyePointsViewArray polygonview:self.leftEyePolygonView];
    }
    else if(tag == RIGHT_EYE_TAG){
        [self redrawPoly:self.rightEyePointsViewArray polygonview:self.rightEyePolygonView];
    }
    else if(tag == LEFT_RBOW_TAG){
        [self redrawPoly:self.leftBrowPointsViewArray polygonview:self.leftBrowPolylineView];
    }
    else if(tag == RIGHT_RBOW_TAG){
        [self redrawPoly:self.rightBrowPointsViewArray polygonview:self.rightBrowPolylineView];
    }
}



- (void)saveAllPoints
{
    // left eye
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.leftEyePointsViewArray.count; i++){
        CGPoint point = [[self.leftEyePointsViewArray objectAtIndex:i] center];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }    
    [[FaceDataManager getInstance] setSavedLeftEyePoints:points];
    
    // right eye
    points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.rightEyePointsViewArray.count; i++){
        CGPoint point = [[self.rightEyePointsViewArray objectAtIndex:i] center];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    [[FaceDataManager getInstance] setSavedRightEyePoints:points];
    
    // left brow
    points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.leftBrowPointsViewArray.count; i++){
        CGPoint point = [[self.leftBrowPointsViewArray objectAtIndex:i] center];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    [[FaceDataManager getInstance] setSavedLeftBrowPoints:points];
    
    // right brow
    points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.rightBrowPointsViewArray.count; i++){
        CGPoint point = [[self.rightBrowPointsViewArray objectAtIndex:i] center];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    [[FaceDataManager getInstance] setSavedRightBrowPoints:points];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
