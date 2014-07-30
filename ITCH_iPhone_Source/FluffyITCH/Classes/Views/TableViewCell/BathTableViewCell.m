//
//  BathTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BathTableViewCell.h"
#import "Bathing.h"
#import "Utils.h"

@implementation BathTableViewCell

@synthesize bathing;
@synthesize lblName, lblCycle, checkView, imgCheck;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnCheckClicked:(id)sender
{
    
}

- (void)initCell
{
    if(!bathing)
        return;
    
    lblName.text = bathing.name;
    lblCycle.text = bathing.cycle == 1 ? @"EVERY DAY" : [NSString stringWithFormat:@"EVERY %d DAYS", bathing.cycle];
    
    // Calculate 'Due Today'
    NSDate *startedDate = [Utils getNSDateFromString:bathing.startedDate];
    if(!startedDate)
        startedDate = [Utils getNSDateTimeFromString:bathing.startedDate];
    
    NSDate *today = [NSDate date];
    NSDateComponents *diff = [Utils getDiffNSDate:startedDate toDate:today];
    
    int day = diff.day;
    if(day == bathing.cycle)
        [checkView setHidden:NO];
    else if(bathing.cycle == 1)
        [checkView setHidden:NO];
    else
    {
        [lblName setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y, lblName.frame.size.width + 50, lblName.frame.size.height)];
        [checkView setHidden:YES];
    }
    
    if(bathing.stopDate)
       [checkView setHidden:YES];
}

@end
