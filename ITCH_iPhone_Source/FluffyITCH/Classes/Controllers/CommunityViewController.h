//
//  CommunityViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView      *mTableView;

@property (nonatomic, strong) NSMutableArray            *communicationList;

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (IBAction)btnCreateClicked:(id)sender;

@end
