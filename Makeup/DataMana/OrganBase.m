//
//  FaceOrgan.m
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "OrganBase.h"

@implementation OrganBase

@synthesize outlinePoints;

-(CGRect)getMaskLayerbounds{
    return maskLayerbounds;
}

-(void)setMaskLayerbounds:(CGRect)bounds{
    maskLayerbounds = bounds;
}
@end