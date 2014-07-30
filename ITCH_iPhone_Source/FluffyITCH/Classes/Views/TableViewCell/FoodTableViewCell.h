//
//  FoodTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Food;

@protocol FoodOperationDelegate <NSObject>

-(void)foodStart:(Food *)food;
-(void)foodStop:(Food *)food;
@end

@interface FoodTableViewCell : UITableViewCell {
    
}

@property (nonatomic, strong) IBOutlet UILabel  *lblName;
@property (nonatomic, strong) IBOutlet UIButton *button;
@property id<FoodOperationDelegate>             delegate;

@property (nonatomic, strong) Food              *food;

- (IBAction)buttonClicked:(id)sender;
- (void) initCell;

@end
