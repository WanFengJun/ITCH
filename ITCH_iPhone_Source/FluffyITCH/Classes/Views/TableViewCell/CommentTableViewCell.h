//
//  CommentTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *lblUsername;
@property (nonatomic, strong) IBOutlet UILabel      *lblDate;
@property (nonatomic, strong) IBOutlet UITextView   *tvComment;
@property (nonatomic, strong) IBOutlet UIImageView  *imgUser;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCaptured;

@property (nonatomic, strong) Comment      *comment;

- (void)initCell;

@end
