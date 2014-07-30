//
//  HistoryViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;
@class ITCHRecord;
@class Flea;

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDate      *curDate;
    
    Dog         *curDog;
    ITCHRecord  *itchRecord;
    Flea        *flea;
    NSMutableArray  *medicationList;
    NSMutableArray  *foodList;
    NSMutableArray  *bathingList;
}

@property (nonatomic, strong) IBOutlet UILabel      *lblDate;
@property (nonatomic, strong) IBOutlet UILabel      *lblTitle;

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;

- (IBAction)btnPrevDateClicked:(id)sender;
- (IBAction)btnNextDateClicked:(id)sender;
- (IBAction)btnAddRecordClicked:(id)sender;
- (IBAction)btnChangeDogClicked:(id)sender;

@end
