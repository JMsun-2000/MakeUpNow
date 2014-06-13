//
//  AddImagePickerHandler.m
//  A360Mobile
//
//  Created by Kalicy Zhou on 9/2/12.
//  Copyright (c) 2012 Autodesk. All rights reserved.
//

#import "AddImagePickerHandler.h"
#import "UIImage+Resize.h"


@implementation AddImagePickerHandler {
    __unsafe_unretained UIView * _superView;
    __unsafe_unretained UIBarButtonItem* _buttonItem;
    UIPopoverController *_addImagePopover;
    UIActionSheet * _imageSelectorSheet;
}
@synthesize delegate = _delegate;


- (id)initWithSuperView:(UIView*)superView buttonItem:(UIBarButtonItem*)buttonItem
{
    if (self = [super init]) {
        _displayMode = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)?AddImageDisplayModePopover:AddImageDisplayModeFullScreen;
        if (_displayMode == AddImageDisplayModePopover) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        _superView = superView;
        _buttonItem = buttonItem;
    }
    return self;
}

- (void)dealloc {
    if (_displayMode == AddImageDisplayModePopover) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)showImagePicker
{
    if ([_addImagePopover isPopoverVisible]) {
        [_addImagePopover dismissPopoverAnimated:YES];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (_imageSelectorSheet) {
            [_imageSelectorSheet dismissWithClickedButtonIndex:-1 animated:YES];
            _imageSelectorSheet = nil;
            return;
        }
        
        switch (_displayMode) {
            case AddImageDisplayModePopover:
                _imageSelectorSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self 
                                                        cancelButtonTitle:nil 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:NSLocalizedString(@"From Camera", @"take picture"), NSLocalizedString(@"From Gallery", @"select picture from gallery"), nil];
                
                [_imageSelectorSheet showFromBarButtonItem:_buttonItem animated:YES];
                break;
            case AddImageDisplayModeFullScreen:
                _imageSelectorSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self 
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", @"'Cancel' button") 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:NSLocalizedString(@"From Camera", @"take picture"), NSLocalizedString(@"From Gallery", @"select picture from gallery"), nil];
                
                [_imageSelectorSheet showInView:_superView];
                break;
        }        
        
    } else {    
        // open album 
        [self createImagePicker:AddImageStageAlbum];
    }
}

- (void)createImagePicker:(AddImageStage)stage
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    [imagePicker setSourceType:(stage == AddImageStagePhoto)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    imagePicker.navigationBar.barStyle = UIBarStyleDefault;
    [self presentImagePicker:imagePicker];
}

- (void)presentImagePicker:(UIImagePickerController *)imagePicker {
    if (_displayMode == AddImageDisplayModeFullScreen || imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [_superView.window.rootViewController presentModalViewController:imagePicker animated:YES];
    }
    else {
        if (_addImagePopover) {
            [_addImagePopover setContentViewController:imagePicker animated:YES];
        } else {
            _addImagePopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        }
        [_addImagePopover presentPopoverFromBarButtonItem:_buttonItem permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)dismissImagePicker:(UIImagePickerController *)imagePicker {
    if (_displayMode == AddImageDisplayModeFullScreen || imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [imagePicker dismissModalViewControllerAnimated:NO];
    }
    else {
        [_addImagePopover dismissPopoverAnimated:YES];
    }
}

- (void)dismissPopoverMenu {
    if ([_addImagePopover isPopoverVisible]) {
        [_addImagePopover dismissPopoverAnimated:NO];
    }
    else if ([_imageSelectorSheet isVisible] && _displayMode == AddImageDisplayModePopover) {
        [_imageSelectorSheet dismissWithClickedButtonIndex:-1 animated:NO];
    }
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0 && buttonIndex != 1) {
        return;
    }
    [self createImagePicker:buttonIndex];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _imageSelectorSheet = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissImagePicker:picker];
    // resize image
    if (image.size.width > 720.0 || image.size.height > 720.0) {
        image = [image scaledToSize:CGSizeMake(720.0,720.0) method:ImageResizeScaleAspectFit];
    }
    [self.delegate pickImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{ 
    [self dismissImagePicker:picker];
}

#pragma mark - keyboard
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self dismissPopoverMenu];
}
@end
