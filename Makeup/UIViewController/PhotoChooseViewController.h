//
//  ViewController.h
//  Makeup
//
//  Created by Sun Jimmy on 8/10/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumContentsTableViewCell.h"

@interface PhotoChooseViewController : UIViewController
           <UITableViewDelegate, UITableViewDataSource, AlbumContentsTableViewCellSelectionDelegate>
{
    IBOutlet UIView *albumPopupUIView;
    IBOutlet UIImageView *openGallaryButton;
    IBOutlet UITableView *photoTableView;
    IBOutlet UIButton *selectButton;
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
    NSMutableArray *assets;
    int selectedIndex;
}
@end
