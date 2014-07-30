//
//  CommentTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Comment.h"
#import "Utils.h"

@implementation CommentTableViewCell

@synthesize lblUsername, lblDate, tvComment, imgUser, imgCaptured;
@synthesize comment;

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
    if(!comment)
        return;
    
    NSDate *date = [Utils getNSDateTimeFromString:comment.date];
    NSDateComponents *diff = [Utils getDiffNSDate:date toDate:[NSDate date]];
    
    int day = (int)diff.day;
    int month = (int)diff.month;
    int year = (int)diff.year;
    
    NSString *diffStr = @"";
    if(year > 0)
        diffStr = year == 1 ? [NSString stringWithFormat:@"%d year ago", year] : [NSString stringWithFormat:@"%d years ago", year];
    else if(month > 0)
        diffStr = month == 1 ? [NSString stringWithFormat:@"%d month ago", month] : [NSString stringWithFormat:@"%d months ago", month];
    else if(day > 0)
        diffStr = day == 1 ? [NSString stringWithFormat:@"%d day ago", day] : [NSString stringWithFormat:@"%d days ago", day];
    else if(day == 0)
        diffStr = @"Today";
    
    lblUsername.text = comment.username;
    lblDate.text = diffStr;
    tvComment.text = comment.message;

    // Get frame size of message textview
    [tvComment setScrollEnabled:YES];
    [tvComment sizeToFit];
    [tvComment setScrollEnabled:NO];
    CGRect textRect = tvComment.frame;
    //
    
    [tvComment removeFromSuperview];
    [tvComment setFrame:CGRectMake(tvComment.frame.origin.x, tvComment.frame.origin.y, textRect.size.width, textRect.size.height)];
    [self.contentView addSubview:tvComment];
    
    if(comment.photoUrl && comment.photoUrl.length > 0)
    {
        [imgCaptured setFrame:CGRectMake(imgCaptured.frame.origin.x, 50 + textRect.size.height + 10, imgCaptured.frame.size.width, imgCaptured.frame.size.height)];
        [imgCaptured removeFromSuperview];
        [self.contentView addSubview:imgCaptured];
    }
    else
        [imgCaptured setHidden:YES];
}

@end
