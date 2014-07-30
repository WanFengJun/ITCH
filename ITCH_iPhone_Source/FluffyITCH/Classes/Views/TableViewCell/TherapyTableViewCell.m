//
//  TherapyTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "TherapyTableViewCell.h"
#import "Therapy.h"
#import "Constants.h"
#import "Utils.h"

@implementation TherapyTableViewCell

@synthesize lblName, lblCycle, checkView1, checkView2, checkView3, imgCheck1, imgCheck2, imgCheck3, imgLineDue, lblDueToday;
@synthesize therapy, delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnCheck1Clicked:(id)sender
{
    if(therapy.checkIndex == 0)
        [self.delegate tickCheck:therapy];
    else
        return;
}

- (IBAction)btnCheck2Clicked:(id)sender
{
    if(therapy.checkIndex == 1)
        [self.delegate tickCheck:therapy];
    else
        return;
}

- (IBAction)btnCheck3Clicked:(id)sender
{
    if(therapy.checkIndex == 2)
        [self.delegate tickCheck:therapy];
    else
        return;
}

#pragma mark
#pragma mark - Init Cell

- (void)initCell
{
    if(!therapy)
        return;
    
    lblName.text = therapy.name;
    
    if(therapy.cycleType == CYCLE_TYPE_HOUR)
        lblCycle.text = therapy.cycle == 1 ? [NSString stringWithFormat:@"%@ EVERY %d Hour", therapy.unit, therapy.cycle] : [NSString stringWithFormat:@"%@ EVERY %d Hours", therapy.unit, therapy.cycle];
    else
        lblCycle.text = therapy.cycle == 1 ? [NSString stringWithFormat:@"%@ EVERY %d Day", therapy.unit, therapy.cycle] : [NSString stringWithFormat:@"%@ EVERY %d Days", therapy.unit, therapy.cycle];
    
    if(therapy.cycleType == CYCLE_TYPE_DAY)
    {
        if(therapy.cycle == 1)
        {
            [lblDueToday setHidden:NO];
            [imgLineDue setImage:[UIImage imageNamed:@"line_due.png"]];
            
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
                [lblDueToday setHidden:YES];
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
                    [lblDueToday setHidden:NO];
                    [checkView1 setHidden:NO];
                }
                else
                    [lblDueToday setHidden:YES];
            }
            
            [imgLineDue setImage:[UIImage imageNamed:@"line_not_due.png"]];
        }
    }
    else
    {
        [lblDueToday setHidden:NO];
        [imgLineDue setImage:[UIImage imageNamed:@"line_due.png"]];
        
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
