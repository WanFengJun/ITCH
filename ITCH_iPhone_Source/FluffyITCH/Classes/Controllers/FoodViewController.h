//
//  FoodViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTableViewCell.h"

@class Dog;

@interface FoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FoodOperationDelegate> {
    NSMutableArray  *autoCompleteList;
    NSMutableArray  *fullFoodList;
}

@property (nonatomic, strong) Dog               *dog;
@property (nonatomic, strong) NSMutableArray    *usedFoodList;

@property (nonatomic, strong) IBOutlet UITableView  *mTableView;
@property (nonatomic, strong) IBOutlet UITableView  *mAutoCompleteTableView;
@property (nonatomic, strong) IBOutlet UILabel      *lblDogName;
@property (nonatomic, strong) IBOutlet UISearchBar  *searchBar;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
