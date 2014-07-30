//
//  ChangeDogViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FROM_RECORD_VIEW            0
#define FROM_HISTORY_VIEW           1
#define FROM_REPORT_VIEW            2

@class Dog;

@interface ChangeDogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    Dog     *selectedDog;
}

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;

@property (nonatomic, strong) NSMutableArray        *dogList;

@property int                                       from;

- (IBAction)btnCloseClicked:(id)sender;
- (IBAction)btnAddClicked:(id)sender;

@end
