//
//  FoodHistoryTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "FoodHistoryTableViewCell.h"
#import "Food.h"

@implementation FoodHistoryTableViewCell

@synthesize lblName;
@synthesize food;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initCell
{
    if(!food)
        return;
    
    lblName.text = food.name;
}

@end
