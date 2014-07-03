//
//  RightBrowData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/30/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "RightBrowData.h"

CGFloat const RIGHTBROW_REFERENCE_POINT_X = 78.0f;
CGFloat const RIGHTBROW_REFERENCE_POINT_Y = 153.0f;

@implementation RightBrowData

-(instancetype)init{
    self = super.init;
    if (self){
        curMaskStyleName = @"brows-test-sample-R.jpg";
        referencePointBeginIndex = 0;
        referencePointEndIndex = 2;
        refrencePointOffset = CGPointMake(RIGHTBROW_REFERENCE_POINT_X, RIGHTBROW_REFERENCE_POINT_Y);
        
    }
    
    return self;
}

@end
