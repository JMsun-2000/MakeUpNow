//
//  PloyBaseUIView.m
//  Makeup
//
//  Created by Sun Jimmy on 10/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PloyBaseUIView.h"

@interface PloyBaseUIView()

@end

@implementation PloyBaseUIView{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)dealloc
{
    if (_curPolyPoints != nil){
        // release the old one
        [_curPolyPoints release];
    }
    
    if (_curBezierPath  != nil){
        [self.curBezierPath release];
    }
    [super dealloc];
}

-(void)setPolyPoints:(NSArray*)points
{
    if (_curPolyPoints != nil){
        // release the old one
        [_curPolyPoints release];
    }
    
    _curPolyPoints = [points retain];
}

- (void)setPolyType:(PolyType)type
{
    curPolyType = type;
}

-(UIBezierPath*)getCurPath
{
    return self.curBezierPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
