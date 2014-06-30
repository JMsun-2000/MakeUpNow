//
//  FaceOrgan.h
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganBase : NSObject{
    NSString* curMaskStyleName;
    CGPoint refrencePointOffset;
}

@property (strong) NSMutableArray* outlinePoints;
@property (strong) UIImage* originalImage;
@property (strong) UIColor* maskColor;
@property (assign) CGPoint position;
@property (assign) CGRect maskLayerbounds;

-(UIImage*)getMaskImage;
-(UIImage*) clipMaskScope;
-(UIImage*) adjustedMaskStyle;
-(UIImage*) createMaskByMerge:(UIImage*)source maskImage:(UIImage*)maskImage;
@end
