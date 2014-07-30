//
//  CommunityStoryViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/9/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CommunityStoryViewController.h"
#import "ITCHAppDelegate.h"
#import "CreateCommentViewController.h"
#import "Community.h"
#import "Comment.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "IconDownloader.h"
#import "CommentTableViewCell.h"

@interface CommunityStoryViewController ()

@end

@implementation CommunityStoryViewController

@synthesize tvTitle, lblUsername, lblDate, imgPhoto, tvMessage, communityView, mTableView;
@synthesize community, commentList, imageDownloadsInProgress;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:NOTIFICATION_ADDED_COMMENT object:nil];
    
    if(community)
    {
        [self initCommunityView];
        
        if(community.photoUrl && community.photoUrl.length > 0)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, COMMUNITY_PHOTO_BASE_URL, community.photoUrl];
            NSURL *imageURL = [NSURL URLWithString:url];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    self.community.imageComm = [UIImage imageWithData:imageData];
                    imgPhoto.image = self.community.imageComm;
                });
            });
        }
        else
        {
            [imgPhoto setHidden:YES];
            [tvMessage setFrame:CGRectMake(tvMessage.frame.origin.x, lblUsername.frame.origin.y + lblUsername.frame.size.height + 5, tvMessage.frame.size.width, tvMessage.frame.size.height)];
            [communityView setFrame:CGRectMake(communityView.frame.origin.x, communityView.frame.origin.y, communityView.frame.size.width, communityView.frame.size.height - imgPhoto.frame.size.height)];
            [mTableView setFrame:CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y, mTableView.frame.size.width, mTableView.frame.size.height + imgPhoto.frame.size.height)];
        }
        
        if(community.imageDog)
            dogPhoto = community.imageDog;
        else if(community.dogPhoto && community.dogPhoto.length > 0)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, PHOTO_BASE_URL, community.dogPhoto];
            NSURL *imageURL = [NSURL URLWithString:url];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    dogPhoto = [UIImage imageWithData:imageData];
                    community.imageDog = dogPhoto;
                    
                    [mTableView reloadData];
                });
            });
        }
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    tempTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 220, 34) textContainer:nil];
    
    self.imageDownloadsInProgress = [NSMutableDictionary new];
    
    [self loadCommentList];
}

- (void)initCommunityView
{
    [tvTitle setScrollEnabled:YES];
    tvTitle.text = community.title;
    [tvTitle sizeToFit];
    [tvTitle setScrollEnabled:NO];
    
    [lblUsername setFrame:CGRectMake(lblUsername.frame.origin.x, tvTitle.frame.origin.y + tvTitle.frame.size.height + 3, lblUsername.frame.size.width, lblUsername.frame.size.height)];
    [lblDate setFrame:CGRectMake(lblDate.frame.origin.x, tvTitle.frame.origin.y + tvTitle.frame.size.height + 3, lblDate.frame.size.width, lblDate.frame.size.height)];
    
    lblUsername.text = community.username;
    lblDate.text = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:community.date]];
    
    [tvMessage setScrollEnabled:YES];
    [tvMessage setText:community.content];
    [tvMessage sizeToFit];
    [tvMessage setScrollEnabled:NO];
    
    if(community.photoUrl)
    {
        [imgPhoto setFrame:CGRectMake(imgPhoto.frame.origin.x, lblUsername.frame.origin.y + lblUsername.frame.size.height + 5, imgPhoto.frame.size.width, imgPhoto.frame.size.height)];
        
        [tvMessage setFrame:CGRectMake(tvMessage.frame.origin.x, imgPhoto.frame.origin.y + imgPhoto.frame.size.height + 5, tvMessage.frame.size.width, tvMessage.frame.size.height)];
    }
    else
    {
        [tvMessage setFrame:CGRectMake(tvMessage.frame.origin.x, lblUsername.frame.origin.y + lblUsername.frame.size.height + 5, tvMessage.frame.size.width, tvMessage.frame.size.height)];
    }
    
    [communityView setFrame:CGRectMake(communityView.frame.origin.x, communityView.frame.origin.y, communityView.frame.size.width, tvMessage.frame.origin.y + tvMessage.frame.size.height + 5)];
}

- (void)addComment:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    Comment *comment = [userDic objectForKey:@"comment"];
    if(!comment)
        return;
    
    [self.commentList insertObject:comment atIndex:0];
    [mTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Load Comment List
- (void)loadCommentList
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_COMMENT_LIST_URL];
    
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
        
        self.commentList = [NSMutableArray new];
        
        for (int i = 0; i < [dicList count]; i++)
        {
            NSDictionary *dic = [dicList objectAtIndex:i];
            
            Comment *item = [Comment new];
           
            item.commentId = [[dic objectForKey:PARAM_KEY_COMMENT_ID] intValue];
            item.communityId = [[dic objectForKey:PARAM_KEY_COMMUNITY_ID] intValue];
            item.message = [dic objectForKey:PARAM_KEY_COMMENT];
            item.photoUrl = [dic objectForKey:PARAM_KEY_PHOTO_URL];
            item.date = [dic objectForKey:PARAM_KEY_DATE];
            item.username = [dic objectForKey:PARAM_KEY_USERNAME];
            item.dogPhoto = [dic objectForKey:PARAM_KEY_DOG_PHOTO];
            
            [self.commentList addObject:item];
        }
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[NSNumber numberWithInt:community.communityId] forKey:PARAM_KEY_COMMUNITY_ID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddCommentClicked:(id)sender
{
    CreateCommentViewController *vc = [[CreateCommentViewController alloc] initWithNibName:@"CreateCommentViewController" bundle:nil];
    vc.community = community;
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarVC presentViewController:vc animated:YES completion:nil];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height = 0.0f;
    
    Comment *comment = [commentList objectAtIndex:indexPath.row];
    NSString *message = comment.message;

    // Get frame size of message textview
    tempTextView.text = message;
    [tempTextView setScrollEnabled:YES];
    [tempTextView sizeToFit];
    [tempTextView setScrollEnabled:NO];
    CGRect textRect = tempTextView.frame;
    //
    
    if(comment.photoUrl && comment.photoUrl.length > 0)
        height = 50 + textRect.size.height + 10 + 150 + 20;
    else
        height = 50 + textRect.size.height + 18;
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.commentList)
        return 0;
    else
        return [self.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    
    if(!cell)
    {
        NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        for(id currentObject in topObjects)
        {
            if([currentObject isKindOfClass:[CommentTableViewCell class]])
            {
                cell = (CommentTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    Comment *comment = [commentList objectAtIndex:indexPath.row];
    if(comment)
    {
        cell.comment = comment;
        [cell initCell];
        
        cell.imgUser.image = dogPhoto;
        
        if (!comment.image)
        {
            if (self.mTableView.dragging == NO && self.mTableView.decelerating == NO)
            {
                [self startIconDownload:comment forIndexPath:indexPath];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Comment *)comment forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.data = comment;
        [iconDownloader setCompletionHandler:^{
            
            CommentTableViewCell *cell = (CommentTableViewCell *)[self.mTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imgCaptured.image = comment.image;
            
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
    if ([commentList count] > 0)
    {
        NSArray *visiblePaths = [self.mTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.row == [commentList count])
                break;
            
            Comment *comment = [commentList objectAtIndex:indexPath.row];
            
            if (!community.imageDog)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:comment forIndexPath:indexPath];
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
