//
//  TracingBaseViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "TracingBaseViewController.h"
#import "PloyBaseUIView.h"
#import "MarkupDotUIView.h"

@interface TracingBaseViewController ()

@end

@implementation TracingBaseViewController

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
	// Do any additional setup after loading the view.
    // back button event
    [popBackButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    // set next button listener
    [doNextButton addTarget:self action:@selector(saveAllPoints) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)redrawPoly:(NSMutableArray*)pointArray polygonview:(PloyBaseUIView*)polygon
{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (int i = 0; i < pointArray.count; i++){
        MarkupDotUIView* dot = [pointArray objectAtIndex:i];
        CGRect pinFrame = dot.frame;
        CGPoint point = CGPointMake(CGRectGetMidX(pinFrame),CGRectGetMidY(pinFrame));
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    [polygon setPolyPoints:points];
    [polygon setNeedsDisplay];
}

-(void)popBack:(id)target
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAllPoints
{
}

@end
