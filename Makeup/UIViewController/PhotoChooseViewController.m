//
//  ViewController.m
//  Makeup
//
//  Created by Sun Jimmy on 8/10/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import "PhotoChooseViewController.h"
#include <AssetsLibrary/AssetsLibrary.h>


@interface PhotoChooseViewController ()

@end

@implementation PhotoChooseViewController{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // attach click event
    UITapGestureRecognizer *tapListener = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTap:)];
    [openGallaryButton addGestureRecognizer:tapListener];
    // release resource
    [tapListener release];
    
    // Load photo group from asset Library
    if (!assetsLibrary) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (!groups) {
        groups = [[NSMutableArray alloc] init];
    } else {
        [groups removeAllObjects];
    }
    if (!assets) {
        assets = [[NSMutableArray alloc] init];
    } else {
        [assets removeAllObjects];
    }
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [groups addObject:group];
        } else {
            [photoTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    
    
    // get photo info from every group
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [assets addObject:result];
        }
    };
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    for (int i=0; i<groups.count; i++){
        ALAssetsGroup *assetsGroup = [groups objectAtIndex:i];
        [assetsGroup setAssetsFilter:onlyPhotosFilter];
        [assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }
    
    // set tableview delgate
    photoTableView.delegate = self;
    photoTableView.dataSource = self;
 }

-(void)handleButtonTap:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView*)recognizer.view;
    
    switch(imageView.tag)
    {
        case 1:
        {
            // open gallery
            albumPopupUIView.hidden = false;
            break;
        }
        case 2:
            // open camera
            break;
        case 3:
            // open sample
            break;
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // get all photos count
    return ceil((float)assets.count/ 4); // there are four photos per row.
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    AlbumContentsTableViewCell *cell = (AlbumContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AlbumContentsTableViewCell" owner:self options:nil];
        cell = tmpCell;
        tmpCell = nil;
    }
    
    cell.rowNumber = indexPath.row;
    cell.selectionDelegate = self;
    
    // Configure the cell...
    NSUInteger firstPhotoInCell = indexPath.row * 4;
    NSUInteger lastPhotoInCell  = firstPhotoInCell + 4;
    
    if (assets.count <= firstPhotoInCell) {
        NSLog(@"We are out of range, asking to start with photo %d but we only have %d", firstPhotoInCell, assets.count);
        return nil;
    }
    
    NSUInteger currentPhotoIndex = 0;
    NSUInteger lastPhotoIndex = MIN(lastPhotoInCell, assets.count);
    for ( ; firstPhotoInCell + currentPhotoIndex < lastPhotoIndex ; currentPhotoIndex++) {
        
        ALAsset *asset = [assets objectAtIndex:firstPhotoInCell + currentPhotoIndex];
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        
        switch (currentPhotoIndex) {
            case 0:
                [cell photo1].image = thumbnail;
                break;
            case 1:
                [cell photo2].image = thumbnail;
                break;
            case 2:
                [cell photo3].image = thumbnail;
                break;
            case 3:
                [cell photo4].image = thumbnail;
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [assetsLibrary release];
    [groups release];
    [assets release];
    [super dealloc];
}

@end
