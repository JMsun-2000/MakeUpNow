//
//  FaceOrgan.h
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganBase : NSObject{
    CGRect maskLayerbounds;
}

@property (strong)NSMutableArray* outlinePoints;

-(CGRect)getMaskLayerbounds;
-(void)setMaskLayerbounds:(CGRect)bounds;
-(UIBezierPath*)getoutlineBezierPath;

@end
