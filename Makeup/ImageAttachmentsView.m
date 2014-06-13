//
//  ImageAttachmentsView.m
//  A360Mobile
//
//  Created by Kalicy Zhou on 9/11/12.
//  Copyright (c) 2012 Autodesk. All rights reserved.
//

#import "ImageAttachmentsView.h"
#import "AttachmentItem.h"
#import "DataManager.h"
#import "ContactResourceIdentity.h"
#import "ImageResouceIdentity.h"
#import "EmptyResultUIView.h"
#import "MarkupItem.h"
#import "MarkupManager.h"
#import "DownloadImageOperation.h"
#import "ImageCacheManager.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kAttachmentPadPadding       ((CGSize){12.f, 6.f})
#define kAttachmentPhonePadding     ((CGSize){12.f, 5.f})

@interface ImageAttachmentsView()
@property (nonatomic) BOOL pageControlUsed;
@end

@implementation ImageAttachmentsView
@synthesize pageControl = _pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize pageArray = _pageArray;
@synthesize scrollView = _scrollView;
@synthesize topBar = _topBar;
@synthesize attachmentView = _attachmentView;
@synthesize imageCollection = _imageCollection;

#define kButtonWidth 55
#define kPageControlHeight 60
- (id)initWithFrame:(CGRect)frame withPages:(NSSet*)pageArray andDefault:(NSInteger)defaultPage{
	if ((self = [super initWithFrame:frame])) {
        self.backgroundColor =[UIColor colorWithWhite:0.0f alpha:.5f];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UIView* attachmentView = [[UIView alloc]initWithFrame:frame];
        attachmentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        self.attachmentView = attachmentView;
        [self addSubview:self.attachmentView];
        
        // init scroll view properties
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, kToolbarHeight, frame.size.width, frame.size.height -kToolbarHeight*2)];
        scrollView.backgroundColor = [UIColor lightGrayColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        self.scrollView = scrollView;
        [self.attachmentView addSubview:self.scrollView];
        
        // Top bar
        UIToolbar* topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kToolbarHeight)];
        topBar.barStyle = UIBarStyleBlack;
        topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *separator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];    
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
        topBar.items = [NSArray arrayWithObjects:separator, doneButton, nil];
        self.topBar = topBar;
        [self.attachmentView addSubview:topBar];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kToolbarHeight)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.contentMode = UIViewContentModeCenter;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:kTextBoldFont size:20.f];
        titleLabel.text = NSLocalizedString(@"Attachments", @"Title of attachments view");
        [self.topBar addSubview:titleLabel];
        
        _pageControl = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-kToolbarHeight, self.frame.size.width, kToolbarHeight)];
        CGSize padding = kAttachmentPhonePadding;
        CGRect subFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-kToolbarHeight*2);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.attachmentView.frame = CGRectMake(0.f, 0.f, kAttachmentsWidth, kAttachmentsHeight);
            self.attachmentView.center = self.center;
            self.attachmentView.layer.cornerRadius = 8;
            self.attachmentView.clipsToBounds = YES;
            self.pageControl.frame = CGRectMake(0, kAttachmentsHeight-kPageControlHeight, kAttachmentsWidth, kPageControlHeight);
            self.scrollView.frame = CGRectMake(0.f, kToolbarHeight, kAttachmentsWidth, kAttachmentsHeight -kToolbarHeight-kPageControlHeight);
            padding = kAttachmentPadPadding;
            subFrame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        self.pageControl.backgroundColor = [UIColor colorWithWhite:58.f/255.f alpha:1.f];
        [self.attachmentView addSubview:self.pageControl];
        ImageCollectionScrollView* imageCollection = [[ImageCollectionScrollView alloc] initWithFrame:self.pageControl.frame paddingSize:padding];
        [imageCollection setCollectionDelegate:self];
        [imageCollection addImageWithAttachments:pageArray];
        
        for (NSUInteger i = 0; i < pageArray.count; i++) {
            AttachmentItem* attachment = pageArray.allObjects[i];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(subFrame.origin.x+kSpace, subFrame.origin.y+kSpace, subFrame.size.width-kSpace*2, subFrame.size.height -kSpace*2)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            UIImage* image = [[MarkupManager sharedInstance] getAttachmentByMarkupId:attachment.markup.identity withIndex:[[pageArray allObjects] indexOfObject:attachment]];
            if (image == nil) {
                NSString* attchmentTempId = ATTACHMENT_TEMPID(attachment.markup.identity,i);
                image = [[ImageCacheManager sharedInstance]getImageWithKey:IMAGE_KEY(attchmentTempId)];
            }
            if (image == nil) {
                image = [[ImageCacheManager sharedInstance]getImageWithKey:URL_KEY(attachment.identity)];
            }
            if (image != nil) {
                [imageView setImage:image];
                [self adjustViewContent:imageView];
            }
            else if ([attachment.url length] > 0) {
                [self downloadImageFromUrl:attachment view:imageView];
            }
            subFrame.origin.x += subFrame.size.width;
            [self.scrollView addSubview:imageView];
        }
        imageCollection.frame = CGRectMake(0, 0, imageCollection.contentSize.width, imageCollection.frame.size.height);
        imageCollection.center = self.pageControl.center;
        [imageCollection highlightItem:defaultPage];
        [self.attachmentView addSubview:imageCollection];
        self.imageCollection = imageCollection;
        // init pages
        self.pageArray = pageArray;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [pageArray count], self.scrollView.frame.size.height);
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * defaultPage, self.scrollView.contentOffset.y) ;

    }
    return self;
}

-(void) adjustViewContent:(UIImageView*)view {
    if (view.image.size.width < view.frame.size.width-20 && view.image.size.height < view.frame.size.height-20) {
        [view setContentMode:UIViewContentModeCenter];
    }
    else {
        [view setContentMode:UIViewContentModeScaleAspectFit];
    }
}

-(void)downloadImageFromUrl:(AttachmentItem*)attachment view:(UIImageView*)imageView{
    NSOperationQueue* queue = [ApplicationDelegate getCurrentOperationQueue];
    if (queue) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(imageView.frame.size.width/2-20, imageView.frame.size.height/2 -20, 40.0f, 40.0f);
        activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        [imageView addSubview:activityView];
        [activityView startAnimating];
        DownloadImageOperation* op = [[DownloadImageOperation alloc]initWithURL:attachment.url withIdentity:URL_KEY(attachment.identity)];
        __block id doneObserver, errorObserver;
        doneObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kOperationDone object:op queue:nil usingBlock:^(NSNotification *notification){
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
                imageView.image = [[ImageCacheManager sharedInstance]getImageWithKey:op.identity];
                [self adjustViewContent:imageView];
            });
            [[NSNotificationCenter defaultCenter] removeObserver:doneObserver];
        }];
        errorObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kOperationError object:op queue:nil usingBlock:^(NSNotification *notification){
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
                imageView.image = nil;
                EmptyResultUIView *view = [EmptyResultUIView emptyResultUIViewWithType:UIDownloadMarkupAttachment andFrame:CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height)];
                [imageView addSubview:view];
            });
            [[NSNotificationCenter defaultCenter] removeObserver:errorObserver];
        }];
        [queue addOperation:op];
    }
}

#pragma mark - Event Handler
- (void)doneButtonClicked:(UIButton *)sender
{
    self.scrollView.delegate = nil;
    [self removeFromSuperview];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.imageCollection highlightItem:page];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

#pragma mark ImageCollectionScrollViewDelegate
- (void)navigateItem:(NSInteger)position data:(id)data {
    [self.imageCollection highlightItem:position];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = (frame.size.width * position);
    [self.scrollView scrollRectToVisible:frame animated:YES];
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

@end
