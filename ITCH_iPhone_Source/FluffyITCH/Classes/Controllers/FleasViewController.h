//
//  FleasViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;

@interface FleasViewController : UIViewController {
    NSMutableArray  *fleasList;
    
    int selectedIdx;
}

@property (nonatomic, strong) IBOutlet UITableView      *mTableView;

@property (nonatomic, strong) Dog               *dog;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end
