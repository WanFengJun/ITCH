//
//  TherapyTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Therapy;

@protocol MedTickCheckDelegate <NSObject>
-(void)tickCheck:(Therapy *)therapy;
@end

@interface TherapyTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *lblName;
@property (nonatomic, strong) IBOutlet UILabel      *lblCycle;
@property (nonatomic, strong) IBOutlet UIView       *checkView1;
@property (nonatomic, strong) IBOutlet UIView       *checkView2;
@property (nonatomic, strong) IBOutlet UIView       *checkView3;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck1;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck2;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck3;
@property (nonatomic, strong) IBOutlet UIImageView  *imgLineDue;
@property (nonatomic, strong) IBOutlet UILabel      *lblDueToday;

@property (nonatomic, strong) Therapy               *therapy;

@property id<MedTickCheckDelegate>                  delegate;

- (IBAction)btnCheck1Clicked:(id)sender;
- (IBAction)btnCheck2Clicked:(id)sender;
- (IBAction)btnCheck3Clicked:(id)sender;

- (void)initCell;

@end
