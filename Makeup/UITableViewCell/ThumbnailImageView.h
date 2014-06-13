//
//  ThumbnailImageView.h
//  Makeup
//
//  Created by Sun Jimmy on 8/16/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThumbnailImageView;

@protocol ThumbnailImageViewSelectionDelegate <NSObject>
- (void)thumbnailImageViewWasSelected:(ThumbnailImageView *)thumbnailImageView;
@end

@interface ThumbnailImageView : UIImageView {
    
    UIImageView *highlightView;
}

@property(nonatomic, weak) id<ThumbnailImageViewSelectionDelegate> delegate;

- (void)clearSelection;
@end
