//
//  MouthTracingViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "MouthTracingViewController.h"
#import "PloygonUIView.h"
#import "FaceDataManager.h"
#import "MarkupDotUIView.h"

@interface MouthTracingViewController ()
@property (nonatomic) NSMutableArray* mouthPointsViewArray;
@property (nonatomic) PloygonUIView*  mouthPolygonView;
@end

@implementation MouthTracingViewController

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
    // Do any additional setup after loading the view from its nib.
    CGRect drawScope = [[UIScreen mainScreen] bounds];
    
    // draw mouth image
    UIImage *image = [[FaceDataManager getInstance] getMouthPhoto:drawScope.size];
    UIImageView *mouthImageView = [[UIImageView alloc] initWithImage:image];
    [[self view] addSubview:mouthImageView];
    [[self view] sendSubviewToBack:mouthImageView];
    
    // adjust avoid the polys cover the bar
    drawScope.size.height -= 90;
    
    // draw left eye polygon
    NSArray* mouthPoints = [[FaceDataManager getInstance] getMouthInitialPoints];
    self.mouthPolygonView = [[PloygonUIView alloc] initWithFrame:drawScope];
    [self.mouthPolygonView setPolyType:MOUTH_POLYGON];
    [self.mouthPolygonView setPolyPoints:mouthPoints];
    [[self view] addSubview:self.mouthPolygonView];
    
    self.mouthPointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < mouthPoints.count; i++){
        CGPoint p = [[mouthPoints objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        point.movedDelegate = self;
        [self.mouthPointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
}

- (void)saveAllPoints
{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.mouthPointsViewArray.count; i++){
        CGPoint point = [[self.mouthPointsViewArray objectAtIndex:i] center];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [[FaceDataManager getInstance] setSavedMouthPoints:points];
}

- (void)onFeaturePointMoved:(int)tag;
{
    [self redrawPoly:self.mouthPointsViewArray polygonview:self.mouthPolygonView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
