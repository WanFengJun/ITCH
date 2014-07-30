//
//  BathingHistoryTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BathingHistoryTableViewCell.h"
#import "Bathing.h"

@implementation BathingHistoryTableViewCell

@synthesize lblName;
@synthesize bathing;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell
{
    if(!bathing)
        return;
    
    lblName.text = bathing.name;
}

@end
