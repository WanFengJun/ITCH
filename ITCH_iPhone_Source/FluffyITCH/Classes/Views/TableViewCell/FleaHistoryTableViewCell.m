//
//  FleaHistoryTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "FleaHistoryTableViewCell.h"
#import "Flea.h"

@implementation FleaHistoryTableViewCell

@synthesize checkView1, checkView2, checkView3, checkView4, imgCheck1, imgCheck2, imgCheck3, imgCheck4;
@synthesize flea;

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
    if(!flea)
        return;
    
    if(flea.countValue == 0)
    {
        [checkView1 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:246.f/255.f blue:235.f/255.f alpha:1.f]];
        imgCheck1.image = [UIImage imageNamed:@"flea_check.png"];
        
        [checkView2 setBackgroundColor:[UIColor clearColor]];
        imgCheck2.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView3 setBackgroundColor:[UIColor clearColor]];
        imgCheck3.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView4 setBackgroundColor:[UIColor clearColor]];
        imgCheck4.image = [UIImage imageNamed:@"due_uncheck.png"];
    }
    else if(flea.countValue == 1)
    {
        [checkView2 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:246.f/255.f blue:235.f/255.f alpha:1.f]];
        imgCheck2.image = [UIImage imageNamed:@"flea_check.png"];
        
        [checkView1 setBackgroundColor:[UIColor clearColor]];
        imgCheck1.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView3 setBackgroundColor:[UIColor clearColor]];
        imgCheck3.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView4 setBackgroundColor:[UIColor clearColor]];
        imgCheck4.image = [UIImage imageNamed:@"due_uncheck.png"];
    }
    else if(flea.countValue == 2)
    {
        [checkView3 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:246.f/255.f blue:235.f/255.f alpha:1.f]];
        imgCheck3.image = [UIImage imageNamed:@"flea_check.png"];
        
        [checkView2 setBackgroundColor:[UIColor clearColor]];
        imgCheck2.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView1 setBackgroundColor:[UIColor clearColor]];
        imgCheck1.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView4 setBackgroundColor:[UIColor clearColor]];
        imgCheck4.image = [UIImage imageNamed:@"due_uncheck.png"];
    }
    else
    {
        [checkView4 setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:246.f/255.f blue:235.f/255.f alpha:1.f]];
        imgCheck4.image = [UIImage imageNamed:@"flea_check.png"];
        
        [checkView2 setBackgroundColor:[UIColor clearColor]];
        imgCheck2.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView3 setBackgroundColor:[UIColor clearColor]];
        imgCheck3.image = [UIImage imageNamed:@"due_uncheck.png"];
        
        [checkView1 setBackgroundColor:[UIColor clearColor]];
        imgCheck1.image = [UIImage imageNamed:@"due_uncheck.png"];
    }
}

@end
