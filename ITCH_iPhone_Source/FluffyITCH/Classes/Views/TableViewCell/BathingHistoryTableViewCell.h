//
//  BathingHistoryTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bathing;

@interface BathingHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *lblName;

@property (nonatomic, strong) Bathing           *bathing;

- (void)initCell;

@end
