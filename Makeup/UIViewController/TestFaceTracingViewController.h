//
//  TestFaceTracingViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 7/10/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracingBaseViewController.h"

@interface TestFaceTracingViewController : TracingBaseViewController{
    IBOutlet UIImageView* imageFace;
}
@property (atomic) CGImageRef faceRef;
@end
