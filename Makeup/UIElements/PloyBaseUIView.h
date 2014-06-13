//
//  PloyBaseUIView.h
//  Makeup
//
//  Created by Sun Jimmy on 10/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BezierCreatorUtils.h"

@interface PloyBaseUIView : UIView{
    PolyType curPolyType;
}
@property (nonatomic, strong) NSArray* curPolyPoints;
@property (nonatomic, strong) UIBezierPath* curBezierPath;

-(void)setPolyPoints:(NSArray*)points;
-(UIBezierPath*)getCurPath;
- (void)setPolyType:(PolyType)type;
@end
