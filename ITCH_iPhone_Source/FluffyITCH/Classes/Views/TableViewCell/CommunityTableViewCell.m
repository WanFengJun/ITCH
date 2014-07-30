//
//  CommunityTableViewCell.m
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CommunityTableViewCell.h"
#import "Community.h"
#import "Utils.h"

@implementation CommunityTableViewCell

@synthesize imgUser, lblName, lblMsg, lblTitle, lblDate, lblCommentCnt;
@synthesize community;

- (void)awakeFromNib
{
    // Initialization code

}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//	
//	CGSize optimumSize = [self.lblInfo optimumSize];
//	CGRect frame = [self.lblInfo frame];
//	frame.size.height = (int)optimumSize.height+5; // +5 to fix height issue, this should be automatically fixed in iOS5
//	[self.lblInfo setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell
{
    if(!community)
        return;
    
    lblTitle.text = community.title;
    lblName.text = community.username;
    if(community.commentCount > 1)
        lblCommentCnt.text = [NSString stringWithFormat:@"%d comments", community.commentCount];
    else
        lblCommentCnt.text = [NSString stringWithFormat:@"%d comment", community.commentCount];
    
    NSDate *addedDate = [Utils getNSDateTimeFromString:community.date];
    NSDate *serverCurTime = [Utils getNSDateTimeFromString:community.serverCurTime];

    NSDateComponents *diff = [Utils getDiffNSDate:addedDate toDate:serverCurTime];
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
    
    lblDate.text = diffStr;
    lblMsg.text = community.content;
}

@end
