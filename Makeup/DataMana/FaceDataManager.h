//
//  FaceDataManager.h
//  MarkupProject
//
//  Created by Sun Jimmy on 7/13/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class LeftEyeData;
@class RightEyeData;
@class MouthData;
@class LeftBrowData;
@class RightBrowData;

#define FACE_TRACING_POINT_NUM 6

@interface FaceDataManager : NSObject{

}

-(void)setChosenPhoto:(CGImageRef)originalImageRef;

+(FaceDataManager*)getInstance;
-(UIImage*)getOriginalImage;

-(UIImage*)getFacePhoto:(CGSize)windowSize;
-(NSArray*)getFaceInitialPoints;

-(UIImage*)getEyesPhoto:(CGSize)windowSize;
-(NSArray*)getLeftEyeInitialPoints;
-(NSArray*)getRightEyeInitialPoints;
-(NSArray*)getLeftBrowInitialPoints;
-(NSArray*)getRightBrowInitialPoints;

-(UIImage*)getMouthPhoto:(CGSize)windowSize;
-(NSArray*)getMouthInitialPoints;

// scale parameter getter
-(CGFloat)getFaceScaledRatio;
-(CGPoint)getFaceScaledOffset;
-(NSMutableArray*)getOriginalLeftEyePoints;

@property (nonatomic, strong) UIImage* originalImage;

@property (nonatomic, strong) NSMutableArray* savedFacePoints;
@property (nonatomic, strong) LeftEyeData* leftEye;
@property (nonatomic, strong) RightEyeData* rightEye;
@property (nonatomic, strong) MouthData* mouth;
@property (nonatomic, strong) LeftBrowData* leftBrow;
@property (nonatomic, strong) RightBrowData* rightBrow;
// face original data

// new
-(void) saveLeftEyePoint:(NSArray*)points;
-(void) saveRightEyePoint:(NSArray*)points;
-(void) saveMouthPoint:(NSArray*)points;
-(void) saveLeftBrowPoint:(NSArray*)points;
-(void) saveRightBrowPoint:(NSArray*)points;
-(UIImage*) getLeftEyeMask;
-(UIImage*) getRightEyeMask;
-(UIImage*) getMouthMask;
-(UIImage*) getLeftBrowMask;
-(UIImage*) getRightBrowMask;
-(CGRect) getLeftEyeBounds;
-(CGRect) getRightEyeBounds;
-(CGRect) getMouthBounds;
-(CGRect) getLeftBrowBounds;
-(CGRect) getRightBrowBounds;
-(void) setLeftEyeMaskColor:(UIColor*)color;
-(void) setRightEyeMaskColor:(UIColor*)color;
-(void) setMouthMaskColor:(UIColor*)color;
-(void) setLeftBrowMaskColor:(UIColor*)color;
-(void) setRightBrowMaskColor:(UIColor*)color;

@end
