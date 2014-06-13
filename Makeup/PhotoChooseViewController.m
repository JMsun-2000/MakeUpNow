//
//  ViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 8/10/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PhotoChooseViewController.h"

@interface PhotoChooseViewController ()

@end

@implementation PhotoChooseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // attach click event
    UITapGestureRecognizer *tap = [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTap)
    self.openGallaryButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
