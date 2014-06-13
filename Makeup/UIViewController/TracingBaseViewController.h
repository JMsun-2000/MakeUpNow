//
//  TracingBaseViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PloyBaseUIView.h"

@interface TracingBaseViewController : UIViewController{
    IBOutlet UIButton *popBackButton;
    IBOutlet UIButton *doNextButton;
}
-(void)redrawPoly:(NSMutableArray*)pointArray polygonview:(PloyBaseUIView*)polygon;
@end
