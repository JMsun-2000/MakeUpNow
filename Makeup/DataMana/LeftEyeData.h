//
//  LeftEyeData.h
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "OrganBase.h"

extern CGFloat const DEFAULT_EYE_SHADOW_WIDTH;
extern CGFloat const DEFAULT_EYE_SHADOW_HEIGHT;


@interface LeftEyeData : OrganBase{
    NSString* curMaskStyleName;
    int referencePointIndex;
    CGPoint refrencePointOffset;
}

@end
