//
//  CommunityTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Community;

@interface CommunityTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView      *imgUser;
@property (nonatomic, strong) IBOutlet UILabel          *lblName;
@property (nonatomic, strong) IBOutlet UILabel          *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel          *lblMsg;
@property (nonatomic, strong) IBOutlet UILabel          *lblDate;
@property (nonatomic, strong) IBOutlet UILabel          *lblCommentCnt;

@property (nonatomic, strong) Community                 *community;

- (void)initCell;

@end
