//
//  LeftEyeData.m
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "LeftEyeData.h"
#import "BezierCreatorUtils.h"

@implementation LeftEyeData

-(UIBezierPath*)getoutlineBezierPath{
    return [BezierCreatorUtils getEyePath:self.outlinePoints];
}
@end
