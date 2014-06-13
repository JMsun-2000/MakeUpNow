//
//  EyesTracingViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 9/8/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkupDotUIView.h"
#import "TracingBaseViewController.h"

@interface EyesTracingViewController : TracingBaseViewController<FeaturePointMoveDelegate>{
    UIImageView *eyeImageView;
}

@end
