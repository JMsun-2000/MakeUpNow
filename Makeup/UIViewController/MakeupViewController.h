//
//  MakeupViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracingBaseViewController.h"

@interface MakeupViewController : TracingBaseViewController<UIScrollViewDelegate>{
    IBOutlet UIButton *eyeColorButton;
    IBOutlet UIImageView *colorPalette;
    IBOutlet UISlider* alphaSlider;
    IBOutlet UIButton *eyeMaskChangeButton;
    IBOutlet UIButton *mouthColorButton;
}
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;

@end
