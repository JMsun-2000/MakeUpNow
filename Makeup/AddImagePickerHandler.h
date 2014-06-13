//
//  AddImagePickerHandler.h
//  A360Mobile
//
//  Created by Kalicy Zhou on 9/2/12.
//  Copyright (c) 2012 Autodesk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AddImageStagePhoto = 0,
    AddImageStageAlbum
} AddImageStage;

typedef enum 
{
    AddImageDisplayModeFullScreen = 0,
    AddImageDisplayModePopover
} AddImageDisplayMode;


@protocol AddImagePickerHandlerDelegate <NSObject>
@required
- (void)pickImage:(UIImage *)image;
@end

@interface AddImagePickerHandler : NSObject
<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    AddImageDisplayMode _displayMode;
}
@property (nonatomic, unsafe_unretained) id<AddImagePickerHandlerDelegate> delegate;

- (void)showImagePicker;
- (id)initWithSuperView:(UIView*)superView buttonItem:(UIBarButtonItem*)buttonItem;
- (void)dismissPopoverMenu;
@end
