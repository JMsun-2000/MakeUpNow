//
//  ImageCollectionItem.h
//  A360Mobile
//
//  Created by Federico Lagarmilla on 9/4/12.
//  Copyright (c) 2012 Globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDeleteButtonSideLength 28
#define kDeleteButtonPadding 8

@protocol  ImageCollectionItemDelelgate <NSObject>
- (void)deletedItemAtPosition:(NSInteger)position;
- (void)navigateItemAtPosition:(NSInteger)position data:(id)data;
@end

@interface ImageCollectionItem : UIView
{
    
}
@property (assign) NSInteger position;
@property (nonatomic, unsafe_unretained) id<ImageCollectionItemDelelgate>delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition image:(UIImage *)aImage;
- (id)initWithDeleteButtonAndFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition image:(UIImage *)aImage;
- (id)initWithFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition array:(NSSet*)attachments;
- (UIImage *)image;

@end
