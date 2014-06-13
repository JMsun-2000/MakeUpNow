//
//  ImageCollectionItem.m
//  A360Mobile
//
//  Created by Federico Lagarmilla on 9/4/12.
//  Copyright (c) 2012 Globant. All rights reserved.
//

#import "ImageCollectionItem.h"
#import "DataButton.h"
#import "ImageResouceIdentity.h"
#import "DataManager.h"
#import "ContactResourceIdentity.h"
#import "ImageResouceIdentity.h"
#import "AttachmentItem.h"
#import "MarkupItem.h"
#import "MarkupManager.h"
#import "DownloadImageOperation.h"
#import "ImageCacheManager.h"
#import "AppDelegate.h"

@interface ImageCollectionItem ()

@property (nonatomic, strong) UIImageView *imageV;
- (UIButton *)createDeleteButton;
- (void)onDeleteItemTouch:(id)sender;

@end

@implementation ImageCollectionItem {
    DownloadImageOperation* _operation;
}
@synthesize imageV = _imageV;
@synthesize position = _position;
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition image:(UIImage *)aImage {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:aDelegate];
        [self setPosition:aPosition];
        CGRect imageFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageV = [[UIImageView alloc] initWithFrame:imageFrame];
        [self.imageV setImage:aImage];
        [self.imageV setContentMode:UIViewContentModeScaleAspectFill];
        self.imageV.clipsToBounds = YES;
        [self addSubview:self.imageV];
    }
    return self;
}

- (id)initWithDeleteButtonAndFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition image:(UIImage *)aImage
{
    // leave padding for image
    CGRect newFrame = CGRectMake(frame.origin.x - kDeleteButtonPadding,
                                 frame.origin.y - kDeleteButtonPadding,
                                 frame.size.width + kDeleteButtonPadding,
                                 frame.size.height + kDeleteButtonPadding);
    self = [self initWithFrame:newFrame delegate:aDelegate position:aPosition image:aImage];
    if (self) {
        newFrame = CGRectMake(kDeleteButtonPadding,
                              kDeleteButtonPadding,
                              frame.size.width,
                              frame.size.height);
        [self.imageV setFrame:newFrame];
        [self addSubview:[self createDeleteButton]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<ImageCollectionItemDelelgate>)aDelegate position:(NSInteger)aPosition array:(NSSet*)attachments
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"related_data_default" ofType:@"png"];
    UIImage *defaultImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    self = [self initWithFrame:frame delegate:aDelegate position:aPosition image:defaultImage];
    if (self) {
        AttachmentItem * attachment = [attachments allObjects][aPosition];
        UIImage* image = [[MarkupManager sharedInstance] getAttachmentByMarkupId:attachment.markup.identity withIndex:aPosition];
        if (image == nil) {
            NSString* attchmentTempId = ATTACHMENT_TEMPID(attachment.markup.identity,aPosition);
            image = [[ImageCacheManager sharedInstance]getImageWithKey:IMAGE_KEY(attchmentTempId)];
        }
        if (image == nil) {
            image = [[ImageCacheManager sharedInstance]getImageWithKey:IMAGE_KEY(attachment.identity)];
        }
        if (image != nil) {
            [self.imageV setImage:image];
        }
        else if ([attachment.image length] > 0) {
            NSOperationQueue* queue = [ApplicationDelegate getCurrentOperationQueue];
            if (queue) {
                _operation = [[DownloadImageOperation alloc]initWithURL:attachment.image withIdentity:IMAGE_KEY(attachment.identity)];
                [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updatePreviewImage:) name:kOperationDone object: _operation];
                [queue addOperation:_operation];
            }
        }
        DataButton *btnNav = [[DataButton alloc]initWithFrame:self.imageV.frame];
        btnNav.data = attachments;
        [btnNav addTarget:self action:@selector(onNavigateItemTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnNav];
    }
    return self;
}

- (UIButton *)createDeleteButton
{
    CGRect btnFrame = CGRectMake(0, 0,
                                 kDeleteButtonSideLength, kDeleteButtonSideLength);
    UIButton *btnDelete = [[UIButton alloc]initWithFrame:btnFrame];
    [btnDelete addTarget:self action:@selector(onDeleteItemTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *imageOffPath = [mainBundle pathForResource:@"iosminus" ofType:@"png"];
    NSString *imageOnPath = [mainBundle pathForResource:@"iosminus_down" ofType:@"png"];
    [btnDelete setImage:[[UIImage alloc] initWithContentsOfFile:imageOffPath] forState:UIControlStateNormal];
    [btnDelete setImage:[[UIImage alloc] initWithContentsOfFile:imageOnPath] forState:UIControlStateSelected];

    return btnDelete;
}

- (void)updateImage:(UIImage *)newImage withPosition:(NSInteger)newPosition
{
    [self.imageV setImage:newImage];
    [self setPosition:newPosition];
} 
    
- (void)onDeleteItemTouch:(id)sender
{
    [self.delegate deletedItemAtPosition:self.position];
}

- (void)onNavigateItemTouch:(DataButton*)sender
{
    [self.delegate navigateItemAtPosition:self.position data:sender.data];
}

- (UIImage *)image
{
    return self.imageV.image;
}

- (BOOL)checkNotification:(NSNotification *)notification action:(SEL)aSelector{
    if (![notification.object isKindOfClass:[DownloadImageOperation class]])
        return NO;
    
    // Ensure that this operation starts on the main thread
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:aSelector withObject:notification waitUntilDone:NO];
        return NO;
    }
    return YES;
}

- (void)updatePreviewImage:(NSNotification *)notification {
    if ([self checkNotification:notification action:@selector(updatePreviewImage:)]) {
        
        DownloadImageOperation * operation = notification.object;
        
        self.imageV.image = [[ImageCacheManager sharedInstance]getImageWithKey:operation.identity];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:kOperationDone object:operation];
        
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kOperationDone object:nil];
    if (_operation) {
        [_operation cancel];
    }
}
@end
