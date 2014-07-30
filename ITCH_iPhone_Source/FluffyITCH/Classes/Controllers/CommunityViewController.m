//
//  CommunityViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CommunityViewController.h"
#import "ITCHAppDelegate.h"
#import "CommunityTableViewCell.h"
#import "CommunityStoryViewController.h"
#import "CreateCommunityViewController.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Community.h"
#import "IconDownloader.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

@synthesize mTableView;
@synthesize communicationList;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommunity:) name:NOTIFICATION_ADDED_COMMUNITY object:nil];
    
    self.imageDownloadsInProgress = [NSMutableDictionary new];
    
    [self loadCommunityList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCommunity:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    Community *community = [userDic objectForKey:@"community"];
    if(!community)
        return;
    
    [self.communicationList insertObject:community atIndex:0];
    [mTableView reloadData];
}

#pragma mark
#pragma mark Load Community List
- (void)loadCommunityList
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_COMMUNITY_LIST_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] intValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        NSArray *dicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(!dicList)
        {
            [Utils showAlertMessage:@"No Community"];
            return;
        }
        
        self.communicationList = [NSMutableArray new];
        
        NSString *serverCurTime = [jsonValues objectForKey:PARAM_KEY_SERVER_CUR_TIME];
        
        for (int i = 0; i < [dicList count]; i++)
        {
            NSDictionary *dic = [dicList objectAtIndex:i];
            
            Community *item = [Community new];
            
            item.communityId = [[dic objectForKey:PARAM_KEY_COMMUNITY_ID] intValue];
            item.title = [dic objectForKey:PARAM_KEY_TITLE];
            item.content = [dic objectForKey:PARAM_KEY_CONTENT];
            item.photoUrl = [dic objectForKey:PARAM_KEY_PHOTO_URL];
            item.date = [dic objectForKey:PARAM_KEY_DATE];
            item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
            item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
            item.dogPhoto = [dic objectForKey:PARAM_KEY_DOG_PHOTO];
            item.username = [dic objectForKey:PARAM_KEY_USERNAME];
            item.commentCount = [[dic objectForKey:PARAM_KEY_COMMENT_COUNT] intValue];
            item.serverCurTime = serverCurTime;
            
            [self.communicationList addObject:item];
        }
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 120.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.communicationList)
        return 0;
    else
        return [self.communicationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:mTableView])
    {
        CommunityTableViewCell *cell = (CommunityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommunityTableViewCell"];
        
        if(!cell)
        {
            NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"CommunityTableViewCell" owner:self options:nil];
            for(id currentObject in topObjects)
            {
                if([currentObject isKindOfClass:[CommunityTableViewCell class]])
                {
                    cell = (CommunityTableViewCell *)currentObject;
                    break;
                }
            }
        }
        
        Community *item = [self.communicationList objectAtIndex:indexPath.row];
        if(item)
        {
            cell.community = item;
            [cell initCell];
            
            if (!item.imageDog)
            {
                if (self.mTableView.dragging == NO && self.mTableView.decelerating == NO)
                {
                    [self startIconDownload:item forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                //            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imgUser.image = item.imageDog;
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityStoryViewController *vc = [[CommunityStoryViewController alloc] initWithNibName:@"CommunityStoryViewController" bundle:nil];
    
    Community *community = [self.communicationList objectAtIndex:indexPath.row];
    vc.community = community;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Community *)community forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.data = community;
        [iconDownloader setCompletionHandler:^{
            
            CommunityTableViewCell *cell = (CommunityTableViewCell *)[self.mTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imgUser.image = community.imageDog;
            
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
    if ([communicationList count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.row == [communicationList count])
                break;
            
            Community *community = [communicationList objectAtIndex:indexPath.row];
            
            if (!community.imageDog)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:community forIndexPath:indexPath];
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

#pragma mark
#pragma mark - UIButton Click Handler

- (IBAction)btnCreateClicked:(id)sender
{
    CreateCommunityViewController *vc = [[CreateCommunityViewController alloc] initWithNibName:@"CreateCommunityViewController" bundle:nil];
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarVC presentViewController:vc animated:YES completion:nil];
}

@end
