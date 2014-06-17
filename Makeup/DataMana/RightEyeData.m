//
//  RightEyeData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/17/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "RightEyeData.h"

CGFloat const RIGHTEYE_REFERENCE_POINT_X = 122.0f;
CGFloat const RIGHTEYE_REFERENCE_POINT_Y = 208.0f;

@implementation RightEyeData

-(instancetype)init{
    self = super.init;
    if (self){
        curMaskStyleName = @"eyeshadow-test-samples-R.jpg";
        referencePointIndex = 0;
        refrencePointOffset = CGPointMake(RIGHTEYE_REFERENCE_POINT_X, RIGHTEYE_REFERENCE_POINT_Y);
        
    }
    
    return self;
}

@end
