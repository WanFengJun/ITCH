//
//  TherapyDetailViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CustomSwitch.h"

@class Therapy;
@class Dog;

@interface TherapyDetailViewController : UIViewController <NIDropDownDelegate, CustomSwitchDelegate> {
    NIDropDown      *unitDropDown;
    NIDropDown      *cycleDropDown;
    
    NSMutableArray  *unitList;
    NSMutableArray  *cycleList;
    
    int             selAmountIdx;
    int             selFreqIdx;
    
    int             onStatus;
}

@property (nonatomic, strong) IBOutlet UILabel      *lblTitle;
@property (nonatomic, strong) IBOutlet CustomSwitch *onSwitch;
@property (nonatomic, strong) IBOutlet UIButton     *btnUnit;
@property (nonatomic, strong) IBOutlet UIButton     *btnCycle;
@property (nonatomic, strong) IBOutlet UIButton     *btnStart;
@property (nonatomic, strong) IBOutlet UIButton     *btnStop;
@property (nonatomic, strong) IBOutlet UIButton     *btnContinue;
@property (nonatomic, strong) IBOutlet UIView       *viewSchedule;
@property (nonatomic, strong) IBOutlet UIButton     *btnSave;

@property (nonatomic, strong) Therapy       *therapy;
@property (nonatomic, strong) Dog           *dog;

- (IBAction)btnUnitClicked:(id)sender;
- (IBAction)btnCycleClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnStartClicked:(id)sender;
- (IBAction)btnStopClicked:(id)sender;
- (IBAction)btnContiuneClicked:(id)sender;

@end
