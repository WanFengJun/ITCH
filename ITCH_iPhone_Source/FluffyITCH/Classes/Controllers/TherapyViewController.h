//
//  TherapyViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TherapyTableViewCell.h"

@class Dog;

@interface TherapyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MedTickCheckDelegate> {
    NSMutableArray  *autoCompleteList;
}

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;
@property (nonatomic, strong) IBOutlet UITableView  *mAutoCompleteTableView;
@property (nonatomic, strong) IBOutlet UISearchBar  *searchBar;
@property (nonatomic, strong) IBOutlet UILabel      *lblDogName;

@property (nonatomic) int count;

@property (nonatomic, strong) Dog               *dog;
@property (nonatomic, strong) NSMutableArray    *usedTherapyList;
@property (nonatomic, strong) NSMutableArray    *fullTherapyList;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
