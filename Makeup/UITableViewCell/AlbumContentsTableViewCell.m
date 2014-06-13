//
//  AlbumContentsTableViewCell.m
//  Makeup
//
//  Created by Sun Jimmy on 8/16/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "AlbumContentsTableViewCell.h"
#import "ThumbnailImageView.h"

@implementation AlbumContentsTableViewCell

@synthesize rowNumber;
@synthesize selectionDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    photo1.delegate = self;
    photo2.delegate = self;
    photo3.delegate = self;
    photo4.delegate = self;
}

- (UIImageView *)photo1 {
    return photo1;
}

- (UIImageView *)photo2 {
    return photo2;
}

- (UIImageView *)photo3 {
    return photo3;
}

- (UIImageView *)photo4 {
    return photo4;
}

- (void)clearSelection {
    [photo1 clearSelection];
    [photo2 clearSelection];
    [photo3 clearSelection];
    [photo4 clearSelection];
}

- (void)thumbnailImageViewWasSelected:(ThumbnailImageView *)thumbnailImageView {
    NSUInteger selectedPhotoIndex = 0;
    if (thumbnailImageView == photo1) {
        selectedPhotoIndex = 0;
    } else if (thumbnailImageView == photo2) {
        selectedPhotoIndex = 1;
    } else if (thumbnailImageView == photo3) {
        selectedPhotoIndex = 2;
    } else if (thumbnailImageView == photo4) {
        selectedPhotoIndex = 3;
    }
    [selectionDelegate albumContentsTableViewCell:self selectedPhotoAtIndex:selectedPhotoIndex];
}

@end

