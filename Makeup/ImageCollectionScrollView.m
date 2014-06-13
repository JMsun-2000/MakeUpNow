//
//  ImageCollectionScrollView.m
//  A360Mobile
//
//  Created by Federico Lagarmilla on 9/4/12.
//  Copyright (c) 2012 Globant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ImageCollectionScrollView.h"

@interface ImageCollectionScrollView ()

@property (nonatomic) UIView *highlightBorder;
- (CGPoint)newItemPosition;
- (void)adjustContentSize;
- (CGSize)itemSize;
@end

@implementation ImageCollectionScrollView {
    CGSize _paddingSize;
}
@synthesize collectionItems = _collectionItems;
@synthesize collectionDelegate = _collectionDelegate;
@synthesize highlightBorder = _highlightBorder;

- (id)initWithFrame:(CGRect)frame paddingSize:(CGSize)paddingSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.collectionItems = [NSMutableArray new];
        [self setBackgroundColor:[UIColor clearColor]];
        _paddingSize = paddingSize;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (frame.size.width < self.contentSize.width) {
        CGFloat newContentOffsetX = (self.contentSize.width/2) - (self.bounds.size.width/2);
        self.contentOffset = CGPointMake(newContentOffsetX, self.contentOffset.y);
    }
}

- (CGSize)itemSize
{
    CGFloat itemSideLength = self.frame.size.height - _paddingSize.height * 2;
    return CGSizeMake(itemSideLength, itemSideLength);
}

- (void)addImage:(UIImage *)aImage
{
    CGPoint newItemOrigin = [self newItemPosition];
    CGSize newItemSize = [self itemSize];
    CGRect itemFrame = CGRectMake(newItemOrigin.x, newItemOrigin.y, newItemSize.width, newItemSize.height);
    ImageCollectionItem *newItem = [[ImageCollectionItem alloc] initWithDeleteButtonAndFrame:itemFrame
                                                                                    delegate:self
                                                                                    position:[self.collectionItems count]
                                                                                       image:aImage];
    [self.collectionItems addObject:newItem];
    [self addSubview:newItem];
    
    [self adjustContentSize];
}

- (void)addImageWithAttachments:(NSSet*)attachments
{
    for (id attachment in attachments) {
        
        CGPoint newItemOrigin = [self newItemPosition];
        CGSize newItemSize = [self itemSize];
        CGRect itemFrame = CGRectMake(newItemOrigin.x, newItemOrigin.y, newItemSize.width, newItemSize.height);
        ImageCollectionItem *newItem = [[ImageCollectionItem alloc] initWithFrame:itemFrame
                                                                         delegate:self
                                                                         position:[self.collectionItems count]
                                                                            array:attachments];
        [self.collectionItems addObject:newItem];
        
        [self addSubview:newItem];
        
        [self adjustContentSize];
    }
}

- (void)adjustContentSize
{
    CGPoint lastItemOrigin = [self itemOriginAtPosition:[[self collectionItems] count]];
    CGSize newContentSize = CGSizeMake(lastItemOrigin.x-kImageCollectionItemSeparation+_paddingSize.width, self.frame.size.height);
    [self setContentSize:newContentSize];
}

- (CGPoint)itemOriginAtPosition:(NSInteger)aPosition
{
    CGPoint itemOrigin = CGPointZero;
    CGSize itemSize = [self itemSize];
    itemOrigin = CGPointMake(_paddingSize.width + aPosition * (itemSize.width + kImageCollectionItemSeparation), _paddingSize.height);
    
    return itemOrigin;    
}

- (CGPoint)newItemPosition
{
    CGPoint itemOrigin = CGPointZero;
    NSInteger index = 0;
    if (self.collectionItems) {
        index = [self.collectionItems count];
    }
    itemOrigin = [self itemOriginAtPosition:index];
    
    return itemOrigin;
}

-(void)highlightItem:(NSInteger)position {
    if (self.highlightBorder) {
        [self.highlightBorder removeFromSuperview];
    }
    ImageCollectionItem *removeItem = [self.collectionItems objectAtIndex:position];
    UIView *border = [[UIView alloc] initWithFrame:removeItem.frame];
    border.layer.borderWidth = 1;
    border.backgroundColor = [UIColor clearColor];
    border.layer.borderColor = [[UIColor colorWithRed:52.f/255.f green:144.f/255.f blue:235.f/255.f alpha:1.f] CGColor];
    border.layer.opaque = 1;
    border.clipsToBounds = NO;
    [self addSubview:border];
    self.highlightBorder = border;
}

- (void)removeAllImages {
    for (ImageCollectionItem *removeItem in self.collectionItems) {
        [removeItem removeFromSuperview];
    }
    [self.collectionItems removeAllObjects];
    [self adjustContentSize];
}

#pragma mark ImageCollectionDelegate

- (void)deletedItemAtPosition:(NSInteger)position
{
    // only adjust frame of images to the right
    if (self.collectionDelegate == nil || ![self.collectionDelegate respondsToSelector:@selector(removedItemFromCollection)]) {
        return;
    }
    ImageCollectionItem *removeItem = [self.collectionItems objectAtIndex:position];
    [removeItem removeFromSuperview];
    [self.collectionItems removeObjectAtIndex:position];
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = position; i < [self.collectionItems count]; i++) {
            ImageCollectionItem *adjustItem = [self.collectionItems objectAtIndex:i];
            CGPoint newOrigin = [self itemOriginAtPosition:i];
            CGSize itemSize = [self itemSize];
            CGRect newFrame = CGRectMake(newOrigin.x - kDeleteButtonPadding, newOrigin.y - kDeleteButtonPadding, itemSize.width, itemSize.height);
            [adjustItem setFrame:newFrame];
            [adjustItem setPosition:i];
        }

    } completion:^(BOOL finished) {
        [self adjustContentSize];
        [self.collectionDelegate removedItemFromCollection];        
    }];    
}

- (void)navigateItemAtPosition:(NSInteger)position data:(id)data
{
    if (self.collectionDelegate == nil || ![self.collectionDelegate respondsToSelector:@selector(navigateItem: data:)]) {
        return;
    }
    [self.collectionDelegate navigateItem:position data:data];        
        
}

- (NSArray *)images
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    ImageCollectionItem *item = nil;
    for (item in self.collectionItems) {
        [images addObject:[item image]];
    }
    return [NSArray arrayWithArray:images];
}



@end
