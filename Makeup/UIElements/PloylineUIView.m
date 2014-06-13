//
//  PloylineUIView.m
//  Makeup
//
//  Created by Sun Jimmy on 10/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PloylineUIView.h"

@interface PloylineUIView()
@end

CGFloat LINE_BEZIER_FACTOR_X = 0.25f;
CGFloat LINE_BEZIER_FACTOR_Y = 0.3f;

@implementation PloylineUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    UIColor *stellBlueColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.6f alpha:1.0f];
    CGContextSetStrokeColorWithColor(currentContext, [stellBlueColor CGColor]);
    
    self.curBezierPath = [BezierCreatorUtils getBezierPath:curPolyType Points:self.curPolyPoints];
    
    [self.curBezierPath stroke];
}


@end
