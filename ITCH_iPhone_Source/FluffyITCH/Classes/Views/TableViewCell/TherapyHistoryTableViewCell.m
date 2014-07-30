//
//  TherapyHistoryTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "TherapyHistoryTableViewCell.h"
#import "Therapy.h"
#import "Constants.h"
#import "Utils.h"

@implementation TherapyHistoryTableViewCell

@synthesize lblName, lblCycle, imgCheck1, imgCheck2, imgCheck3, checkView1, checkView2, checkView3, lblGiven;
@synthesize therapy;

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
    if(!therapy)
        return;
    
    lblName.text = therapy.name;
    [lblGiven setHidden:YES];
    
    if(therapy.cycleType == CYCLE_TYPE_HOUR)
        lblCycle.text = therapy.cycle == 1 ? [NSString stringWithFormat:@"%@ EVERY %d Hour", therapy.unit, therapy.cycle] : [NSString stringWithFormat:@"%@ EVERY %d Hours", therapy.unit, therapy.cycle];
    else
        lblCycle.text = therapy.cycle == 1 ? [NSString stringWithFormat:@"%@ EVERY %d Day", therapy.unit, therapy.cycle] : [NSString stringWithFormat:@"%@ EVERY %d Days", therapy.unit, therapy.cycle];
    
    if(therapy.cycleType == CYCLE_TYPE_DAY)
    {
        if(therapy.cycle == 1)
        {
            [lblGiven setHidden:NO];
            
            [checkView1 setHidden:NO];
            [checkView2 setHidden:YES];
            [checkView3 setHidden:YES];
        }
        else
        {
            [checkView1 setHidden:YES];
            [checkView2 setHidden:YES];
            [checkView3 setHidden:YES];
            
            if(!therapy.startedDate || therapy.startedDate.length == 0)
            {
                [lblGiven setHidden:NO];
            }
            else
            {
                // Calculate 'Due Today'
                NSDate *startedDate = [Utils getNSDateFromString:therapy.startedDate];
                if(!startedDate)
                    startedDate = [Utils getNSDateTimeFromString:therapy.startedDate];
                
                NSDate *today = [NSDate date];
                NSDateComponents *diff = [Utils getDiffNSDate:startedDate toDate:today];
                
                int day = diff.day;
                if(day == therapy.cycle)
                {
                    [lblGiven setHidden:NO];
                    [checkView1 setHidden:NO];
                }
                else
                    [lblGiven setHidden:NO];
            }
        }
    }
    else
    {
        [lblGiven setHidden:NO];
        
        if(therapy.cycle == 8 || therapy.cycle == 6)
        {
            [checkView1 setHidden:NO];
            [checkView2 setHidden:NO];
            [checkView3 setHidden:NO];
        }
        else if(therapy.cycle >= 12)
        {
            [checkView1 setHidden:NO];
            [checkView2 setHidden:NO];
            [checkView3 setHidden:YES];
        }
    }
    
    if(therapy.checkIndex == 0)
    {
        [imgCheck1 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        [imgCheck2 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        [imgCheck3 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
    }
    else if(therapy.checkIndex == 1)
    {
        [imgCheck1 setImage:[UIImage imageNamed:@"due_check.png"]];
        [imgCheck2 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        [imgCheck3 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
    }
    else if(therapy.checkIndex == 2)
    {
        [imgCheck1 setImage:[UIImage imageNamed:@"due_check.png"]];
        [imgCheck2 setImage:[UIImage imageNamed:@"due_check.png"]];
        [imgCheck3 setImage:[UIImage imageNamed:@"due_uncheck.png"]];
    }
    else if(therapy.checkIndex == 3)
    {
        [imgCheck1 setImage:[UIImage imageNamed:@"due_check.png"]];
        [imgCheck2 setImage:[UIImage imageNamed:@"due_check.png"]];
        [imgCheck3 setImage:[UIImage imageNamed:@"due_check.png"]];
    }
}

@end
