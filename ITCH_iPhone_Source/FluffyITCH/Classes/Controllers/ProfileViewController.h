//
//  ProfileViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;

@interface ProfileViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *dogList;
}

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end
