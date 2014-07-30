//
//  RecordViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;

@interface RecordViewController : UIViewController {
    Dog     *curDog;
    float   backupValue;
}

@property (nonatomic, strong) IBOutlet UISlider *faderSlider;
@property (nonatomic, strong) IBOutlet UILabel  *lblDogName;
@property (nonatomic, strong) IBOutlet UILabel  *lblLevel;
@property (nonatomic, strong) IBOutlet UIButton *btnRecord;

@property (nonatomic, strong) IBOutlet UIView   *transparentView;
@property (nonatomic, strong) IBOutlet UIView   *normalView;
@property (nonatomic, strong) IBOutlet UIView   *veryMildView;
@property (nonatomic, strong) IBOutlet UIView   *mildView;
@property (nonatomic, strong) IBOutlet UIView   *moderateView;
@property (nonatomic, strong) IBOutlet UIView   *severeView;
@property (nonatomic, strong) IBOutlet UIView   *extramelySevereView;

- (IBAction)btnProfileClicked:(id)sender;
- (IBAction)btnChangeDogClicked:(id)sender;
- (IBAction)btnRecordClicked:(id)sender;
- (IBAction)btnAddMedicationClicked:(id)sender;
- (IBAction)btnAddFoodClicked:(id)sender;
- (IBAction)btnAddFealClicked:(id)sender;
- (IBAction)btnAddBathingClicked:(id)sender;

@end
