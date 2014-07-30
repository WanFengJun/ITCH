//
//  CommunityStoryViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/9/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Community;

@interface CommunityStoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITextView  *tempTextView;
    UIImage     *dogPhoto;
}

@property (nonatomic, strong) Community         *community;
@property (nonatomic, strong) NSMutableArray    *commentList;

@property (nonatomic, strong) IBOutlet UITextView   *tvTitle;
@property (nonatomic, strong) IBOutlet UILabel      *lblUsername;
@property (nonatomic, strong) IBOutlet UILabel      *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView  *imgPhoto;
@property (nonatomic, strong) IBOutlet UITextView   *tvMessage;
@property (nonatomic, strong) IBOutlet UIView       *communityView;

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;

@property (nonatomic, strong) NSMutableDictionary   *imageDownloadsInProgress;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnAddCommentClicked:(id)sender;

- (void)addComment:(NSNotification*)notification;

@end
