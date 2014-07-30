//
//  TherapyHistoryTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Therapy;

@interface TherapyHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *lblName;
@property (nonatomic, strong) IBOutlet UILabel      *lblCycle;
@property (nonatomic, strong) IBOutlet UIView       *checkView1;
@property (nonatomic, strong) IBOutlet UIView       *checkView2;
@property (nonatomic, strong) IBOutlet UIView       *checkView3;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck1;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck2;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck3;
@property (nonatomic, strong) IBOutlet UILabel      *lblGiven;

@property (nonatomic, strong) Therapy               *therapy;

- (void) initCell;

@end
