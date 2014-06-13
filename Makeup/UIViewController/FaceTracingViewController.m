//
//  FaceTracingViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 9/1/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "FaceTracingViewController.h"
#import "FaceDataManager.h"

@interface FaceTracingViewController (){
}
@property (nonatomic) NSMutableArray* pointsViewArray;
@end

@implementation FaceTracingViewController

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
    
    UIImage *image = [[FaceDataManager getInstance] getFacePhoto:[UIScreen mainScreen].bounds.size];
    // Do any additional setup after loading the view from its nib.
    faceImageView = [[UIImageView alloc] initWithImage:image];
    [[self view] addSubview:faceImageView];
    [[self view] sendSubviewToBack:faceImageView];
    
    // get control point
    NSArray* pointsValue = [[FaceDataManager getInstance] getFaceInitialPoints];
    self.pointsViewArray = [[NSMutableArray alloc] init];
    for (int i=0; i < pointsValue.count; i++){
        CGPoint p = [[pointsValue objectAtIndex:i] CGPointValue];
        // add small offset for point middle
        MarkupDotUIView *point = [[MarkupDotUIView alloc] initWithFrame:CGRectMake(p.x - 9, p.y - 9, 18, 18)];
        [self.pointsViewArray addObject:point];
        [[self view] addSubview:point];
    }
}

- (void)saveAllPoints
{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pointsViewArray.count; i++){
        CGPoint point = [[self.pointsViewArray objectAtIndex:i] center];
        //[pointsValue replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:point]];
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [[FaceDataManager getInstance] setSavedFacePoints:points];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
