//
//  FoodTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "FoodTableViewCell.h"
#import "Food.h"

@implementation FoodTableViewCell

@synthesize lblName, button;
@synthesize food;
@synthesize delegate;

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
    
    if((food.stopDate && ![food.stopDate isEqualToString:@"0000-00-00 00:00:00"]) || !food.startDate)
    {
        [button setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)buttonClicked:(id)sender
{
    if((food.stopDate && ![food.stopDate isEqualToString:@"0000-00-00 00:00:00"]) || !food.startDate)
        [self.delegate foodStart:food];
    else
        [self.delegate foodStop:food];
}

@end
