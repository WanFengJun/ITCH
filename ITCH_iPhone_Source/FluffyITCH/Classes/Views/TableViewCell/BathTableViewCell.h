//
//  BathTableViewCell.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bathing;

@interface BathTableViewCell : UITableViewCell {
    
}

@property (nonatomic, strong) IBOutlet UILabel  *lblName;
@property (nonatomic, strong) IBOutlet UILabel  *lblCycle;
@property (nonatomic, strong) IBOutlet UIView   *checkView;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCheck;

@property (nonatomic, strong) Bathing           *bathing;

- (IBAction)btnCheckClicked:(id)sender;

- (void)initCell;

@end
