//
//  BathViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;

@interface BathViewController : UIViewController {
    NSMutableArray  *usedBathingList;
    NSMutableArray  *autoCompleteList;
    NSMutableArray  *fullBathingList;
}

@property (nonatomic, strong) Dog   *dog;

@property (nonatomic, strong) IBOutlet UITableView   *mTableView;
@property (nonatomic, strong) IBOutlet UITableView  *mAutoCompleteTableView;
@property (nonatomic, strong) IBOutlet UISearchBar  *searchBar;
@property (nonatomic, strong) IBOutlet UILabel      *lblDogName;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
