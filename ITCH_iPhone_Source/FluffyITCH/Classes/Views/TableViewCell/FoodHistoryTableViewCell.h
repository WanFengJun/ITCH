//
//  FoodHistoryTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Food;

@interface FoodHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *lblName;

@property (nonatomic, strong) Food              *food;

- (void) initCell;

@end
