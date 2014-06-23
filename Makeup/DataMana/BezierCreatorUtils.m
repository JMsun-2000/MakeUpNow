//
//  BezierCreatorUtils.m
//  Makeup
//
//  Created by Sun Jimmy on 10/6/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "BezierCreatorUtils.h"

@implementation BezierCreatorUtils
+(UIBezierPath*)getBezierPath:(PolyType)type Points:(NSArray*)pointsArray
{
    UIBezierPath* ret = nil;
    switch (type) {
        case EYE_POLYGON:
            ret = [self getEyePath:pointsArray offset:CGPointMake(0,0)];
            break;
        case BROW_POLYLINE:
            ret = [self getBrowPath:pointsArray];
            break;
        case MOUTH_POLYGON:
            ret = [self getMouthPath:pointsArray offset:CGPointMake(0,0)];
        default:
            break;
    }
    
    return ret;
}

+(UIBezierPath*)getMouthPath:(NSArray*)pointsArray offset:(CGPoint)offset
{
    CGPoint pervious;
    UIBezierPath* curBezierPath = [UIBezierPath bezierPath];
    int pointCnt = [pointsArray count];
    for (int i = 0; i <= pointCnt; i++){
        // it's a polygon. So must add bezier for the last point line to begin, or it will be straight line by system automatically
        CGPoint p = [[pointsArray objectAtIndex:(i%pointCnt)] CGPointValue];
        p.x += offset.x;
        p.y += offset.y;
        if (i == 0){
            [curBezierPath moveToPoint:CGPointMake(p.x, p.y)];
        }
        else{
            // add Curve
            CGFloat xOffset = (p.x - pervious.x);
            CGFloat yOffset = (p.y - pervious.y);
            
            
            // check the quadrant
            if (i < 8 || i > 9){
                xOffset *= 0.1f;
                yOffset *= 0.25f;
                [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, pervious.y+yOffset)  controlPoint2:CGPointMake(p.x-xOffset, p.y-yOffset)];
            }
             else{
                 xOffset *= 0.5f;
                if (xOffset*yOffset < 0.0f){
                    [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, p.y)  controlPoint2:CGPointMake(p.x-xOffset, p.y)];
                }
                else{
                    [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, pervious.y)  controlPoint2:CGPointMake(p.x-xOffset,  pervious.y)];
                }
             }

            
        }
        pervious = p;
    }
    
    return curBezierPath;
}

+(UIBezierPath*)getBrowPath:(NSArray*)pointsArray
{
    CGPoint pervious;
    UIBezierPath* curBezierPath = [UIBezierPath bezierPath];
    int pointCnt = [pointsArray count];
    for (int i = 0; i < pointCnt; i++){
        // it's a polygon. So must add bezier for the last point line to begin, or it will be straight line by system automatically
        CGPoint p = [[pointsArray objectAtIndex:i] CGPointValue];
        if (i == 0){
            [curBezierPath moveToPoint:CGPointMake(p.x, p.y)];
        }
        else{
            // add Curve
            CGFloat xOffset = (p.x - pervious.x);
            CGFloat yOffset = (p.y - pervious.y);
            
            xOffset *= 0.25f;
            yOffset *= 0.3f;
            // check the quadrant
            if (xOffset*yOffset < 0.0f){
                [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, p.y-yOffset)  controlPoint2:CGPointMake(p.x-xOffset, p.y+yOffset)];
            }
            else{
                [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, pervious.y-yOffset)  controlPoint2:CGPointMake(p.x-xOffset,  pervious.y+yOffset)];
            }
            
        }
        pervious = p;
    }
    
    return curBezierPath;
}

+(UIBezierPath*)getEyePath:(NSArray*)pointsArray offset:(CGPoint)offset
{
    CGPoint pervious;
    UIBezierPath* curBezierPath = [UIBezierPath bezierPath];
    int pointCnt = [pointsArray count];
    for (int i = 0; i <= pointCnt; i++){
        // it's a polygon. So must add bezier for the last point line to begin, or it will be straight line by system automatically
        CGPoint p = [[pointsArray objectAtIndex:(i%pointCnt)] CGPointValue];
        p.x += offset.x;
        p.y += offset.y;
        if (i == 0){
            [curBezierPath moveToPoint:CGPointMake(p.x, p.y)];
        }
        else{
            // add Curve
            CGFloat xOffset = (p.x - pervious.x);
            CGFloat yOffset = (p.y - pervious.y);
            
            xOffset *= 0.25f;
            // check the quadrant
            if (xOffset*yOffset < 0.0f){                
                [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, p.y)  controlPoint2:CGPointMake(p.x-xOffset, p.y)];
            }
            else{
                [curBezierPath addCurveToPoint:p controlPoint1:CGPointMake(pervious.x+xOffset, pervious.y)  controlPoint2:CGPointMake(p.x-xOffset,  pervious.y)];
            }
            
        }
        pervious = p;
    }   

    return curBezierPath;
}
@end
