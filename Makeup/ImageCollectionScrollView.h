//
//  ImageCollectionScrollView.h
//  A360Mobile
//
//  Created by Federico Lagarmilla on 9/4/12.
//  Copyright (c) 2012 Globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCollectionItem.h"

#define kImageCollectionItemSeparation 10
#define kMaximumImages 3

@protocol ImageCollectionScrollViewDelegate <NSObject>
@optional
- (void)removedItemFromCollection;
- (void)navigateItem:(NSInteger)position data:(id)data;
@end

@interface ImageCollectionScrollView : UIScrollView <ImageCollectionItemDelelgate>

@property (nonatomic, strong) NSMutableArray *collectionItems;
@property (nonatomic, unsafe_unretained) id<ImageCollectionScrollViewDelegate> collectionDelegate;

- (id)initWithFrame:(CGRect)frame paddingSize:(CGSize)paddingSize;
- (void)addImage:(UIImage *)aImage;
- (void)addImageWithAttachments:(NSSet*)attachments;
- (NSArray *)images;
- (void)highlightItem:(NSInteger)position;
- (void)removeAllImages;

@end
