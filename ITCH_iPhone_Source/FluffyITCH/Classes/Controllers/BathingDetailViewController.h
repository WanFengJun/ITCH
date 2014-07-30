//
//  BathingDetailViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CustomSwitch.h"

@class Dog;
@class Bathing;

@interface BathingDetailViewController : UIViewController <NIDropDownDelegate, CustomSwitchDelegate> {
    NIDropDown      *cycleDropDown;
    
    NSMutableArray  *cycleList;
    int             selFreqIdx;
    int             onStatus;
}

@property (nonatomic, strong) IBOutlet UILabel      *lblTitle;
@property (nonatomic, strong) IBOutlet CustomSwitch *onSwitch;
@property (nonatomic, strong) IBOutlet UIButton     *btnCycle;
@property (nonatomic, strong) IBOutlet UIButton     *btnStart;
@property (nonatomic, strong) IBOutlet UIButton     *btnStop;
@property (nonatomic, strong) IBOutlet UIButton     *btnContinue;
@property (nonatomic, strong) IBOutlet UIView       *viewSchedule;
@property (nonatomic, strong) IBOutlet UIButton     *btnSave;

@property (nonatomic, strong) Dog                   *dog;
@property (nonatomic, strong) Bathing               *bathing;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnCycleClicked:(id)sender;
- (IBAction)btnStartClicked:(id)sender;
- (IBAction)btnStopClicked:(id)sender;
- (IBAction)btnContinueClicked:(id)sender;

@end
