//
//  ImageAttachmentsView.h
//  A360Mobile
//
//  Created by Kalicy Zhou on 9/11/12.
//  Copyright (c) 2012 Autodesk. All rights reserved.
//

#import "ImageCollectionScrollView.h"

#define kToolbarHeight 44
#define kSpace 10
#define kAttachmentsWidth 630
#define kAttachmentsHeight 660

@interface ImageAttachmentsView : UIView <UIScrollViewDelegate, ImageCollectionScrollViewDelegate>

@property (nonatomic) UIToolbar* topBar;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIView *pageControl;
@property (nonatomic) ImageCollectionScrollView* imageCollection;
@property (nonatomic) NSSet* pageArray;
@property (nonatomic) UIView* attachmentView;

- (id)initWithFrame:(CGRect)frame withPages:(NSSet*)pageArray andDefault:(NSInteger)defaultPage;
-(void) adjustViewContent:(UIImageView*)view;
@end
