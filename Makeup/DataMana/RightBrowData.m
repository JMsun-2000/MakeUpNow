//
//  RightBrowData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/30/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "RightBrowData.h"

CGFloat const RIGHTBROW_REFERENCE_POINT_X = 72.0f;
CGFloat const RIGHTBROW_REFERENCE_POINT_Y = 155.0f;

@implementation RightBrowData

-(instancetype)init{
    self = super.init;
    if (self){
        curMaskStyleName = @"brows-test-sample-R-1.jpg";
        referencePointBeginIndex = 0;
        referencePointEndIndex = 2;
        refrencePointOffset = CGPointMake(RIGHTBROW_REFERENCE_POINT_X, RIGHTBROW_REFERENCE_POINT_Y);
        
    }
    
    return self;
}

@end
