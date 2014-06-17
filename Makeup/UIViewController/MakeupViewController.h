//
//  MakeupViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeupViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIButton *doEyeMaskButton;
    IBOutlet UIImageView *colorPalette;
}
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;

@end
