//
//  ploygonUIView.m
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PloygonUIView.h"


@interface PloygonUIView(){
    
}

@end


@implementation PloygonUIView{
    
}

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
    UIColor *stellBlueColor = [UIColor colorWithRed:0.3f green:0.4f blue:0.6f alpha:0.5f];
    CGContextSetFillColorWithColor(currentContext, [stellBlueColor CGColor]);

    self.curBezierPath = [BezierCreatorUtils getBezierPath:curPolyType Points:self.curPolyPoints];

        
    [self.curBezierPath fill];
    
}


@end
