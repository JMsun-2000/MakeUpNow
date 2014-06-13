//
//  AlbumContentsTableViewCell.h
//  Makeup
//
//  Created by Sun Jimmy on 8/16/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThumbnailImageView.h"

@class AlbumContentsTableViewCell;

@protocol AlbumContentsTableViewCellSelectionDelegate <NSObject>
- (void)albumContentsTableViewCell:(AlbumContentsTableViewCell *)cell selectedPhotoAtIndex:(NSUInteger)index;
@end

@interface AlbumContentsTableViewCell : UITableViewCell <ThumbnailImageViewSelectionDelegate> {
    
    IBOutlet ThumbnailImageView *photo1;
    IBOutlet ThumbnailImageView *photo2;
    IBOutlet ThumbnailImageView *photo3;
    IBOutlet ThumbnailImageView *photo4;
    
    NSUInteger rowNumber;
    id <AlbumContentsTableViewCellSelectionDelegate> selectionDelegate;
}

@property (nonatomic, assign) NSUInteger rowNumber;
@property (nonatomic, assign) id<AlbumContentsTableViewCellSelectionDelegate> selectionDelegate;

- (UIImageView *)photo1;
- (UIImageView *)photo2;
- (UIImageView *)photo3;
- (UIImageView *)photo4;

- (void)clearSelection;
@end