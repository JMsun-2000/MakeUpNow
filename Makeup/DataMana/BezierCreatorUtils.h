//
//  BezierCreatorUtils.h
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EYE_POLYGON,
    BROW_POLYLINE,
    MOUTH_POLYGON,
    ERROR
} PolyType;

@interface BezierCreatorUtils : NSObject
+(UIBezierPath*)getBezierPath:(PolyType)type Points:(NSArray*)pointsArray;
+(UIBezierPath*)getEyePath:(NSArray*)pointsArray offset:(CGPoint)offset;
@end
