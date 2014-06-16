//
//  FaceOrgan.h
//  Makeup
//
//  Created by Sun Jimmy on 6/13/14.
//  Copyright (c) 2014 Sun Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganBase : NSObject{
}

@property (strong) NSMutableArray* outlinePoints;
@property (strong) UIImage* originalImage;
@property (assign) CGPoint position;
@property (assign) CGRect maskLayerbounds;

-(UIImage*)getMaskImage;

@end
