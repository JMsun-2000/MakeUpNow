//
//  LeftBrowData.h
//  Makeup
//
//  Created by Sun Jimmy on 6/30/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import "OrganBase.h"

extern CGFloat const DEFAULT_BROW_SHADOW_WIDTH;
extern CGFloat const DEFAULT_BROW_SHADOW_HEIGHT;

@interface LeftBrowData : OrganBase{
    int referencePointBeginIndex;
    int referencePointEndIndex;
}

@end
