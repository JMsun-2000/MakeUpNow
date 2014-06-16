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

#define FACE_TRACING_POINT_NUM 6

@interface FaceDataManager : NSObject{
    ALAsset *asset;
}

-(void)doFaceDetector;

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

@property (nonatomic, retain) ALAsset *asset;

@property (nonatomic, strong) NSMutableArray* savedFacePoints;
@property (nonatomic, strong) LeftEyeData* leftEye;
@property (nonatomic, strong) NSMutableArray* savedRightEyePoints;
@property (nonatomic, strong) NSMutableArray* savedLeftBrowPoints;
@property (nonatomic, strong) NSMutableArray* savedRightBrowPoints;
@property (nonatomic, strong) NSMutableArray* savedMouthPoints;
// face original data

// new
-(void) saveLeftEyePoint:(NSArray*)points;
-(UIImage*) getLeftEyeMask;
-(CGRect) getLeftEyeBounds;

@end
