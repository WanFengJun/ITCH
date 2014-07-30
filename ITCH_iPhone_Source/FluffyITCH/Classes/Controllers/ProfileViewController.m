//
//  ProfileViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ProfileViewController.h"
#import "DogProfileViewController.h"
#import "ProfileDogTableViewCell.h"
#import "ProfileStringTableViewCell.h"
#import "ITCHAppDelegate.h"
#import "Dog.h"
#import "IconDownloader.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize mTableView;
@synthesize imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageDownloadsInProgress = [NSMutableDictionary new];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];

    dogList = appDelegate.dogList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([dogList count] == 0)
        return 70.f;
    else
    {
        if(indexPath.row < [dogList count])
            return 115.f;
        else
            return 70.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCnt = 0;
    
    rowCnt = [dogList count] + 2;
    
    return rowCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dogList count] > 0 && indexPath.row < [dogList count])
    {
        ProfileDogTableViewCell *cell = (ProfileDogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileDogTableViewCell"];
        
        if(!cell)
        {
            NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileDogTableViewCell" owner:self options:nil];
            for(id currentObject in topObjects)
            {
                if([currentObject isKindOfClass:[ProfileDogTableViewCell class]])
                {
                    cell = (ProfileDogTableViewCell *)currentObject;
                    break;
                }
            }
            
            int row = indexPath.row;
            Dog *dog = [dogList objectAtIndex:row];
            if(dog)
            {
                cell.lblName.text = dog.name;
                
                if (!dog.image)
                {
                    if (self.mTableView.dragging == NO && self.mTableView.decelerating == NO)
                    {
                        [self startIconDownload:dog forIndexPath:indexPath];
                    }
                    // if a download is deferred or in progress, return a placeholder image
                    //            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
                }
                else
                {
                    cell.imgPhoto.image = dog.image;
                }
            }
            
            return cell;
        }
    }
    
    ProfileStringTableViewCell *cell = (ProfileStringTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileStringTableViewCell"];
    
    if(!cell)
    {
        NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileStringTableViewCell" owner:self options:nil];
        for(id currentObject in topObjects)
        {
            if([currentObject isKindOfClass:[ProfileStringTableViewCell class]])
            {
                cell = (ProfileStringTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    if(indexPath.row == [dogList count])
    {
        cell.lblName.text = @"Settings";
    }
    else
    {
        cell.lblName.text = @"Share Profile";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dogList count] > 0 && indexPath.row < [dogList count])
    {
        Dog *dog = [dogList objectAtIndex:indexPath.row];
        
        DogProfileViewController *vc = [[DogProfileViewController alloc] initWithNibName:@"DogProfileViewController" bundle:nil];
        vc.dog = dog;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Dog *)dog forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.data = dog;
        [iconDownloader setCompletionHandler:^{
            
            ProfileDogTableViewCell *cell = (ProfileDogTableViewCell *)[self.mTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imgPhoto.image = dog.image;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([dogList count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.row == [dogList count])
                break;
            
            Dog *dog = [dogList objectAtIndex:indexPath.row];
            
            if (!dog.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:dog forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
