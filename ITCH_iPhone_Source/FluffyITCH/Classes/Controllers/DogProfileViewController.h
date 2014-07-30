//
//  DogProfileViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;

@interface DogProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UITextField     *etBirthday;
    UITextField     *etGender;
    UITextField     *etIndoor;
    UITextField     *etBreed;
    
    NSString        *newBirthday;
    int             newGender;
    NSString        *newBreed;
    int             newIndoor;
    
    UIImage         *dogPhoto;
}

@property (nonatomic, strong) IBOutlet UITableView      *mTableView;
@property (nonatomic, strong) IBOutlet UILabel          *lblTitle;
@property (nonatomic, strong) IBOutlet UIImageView      *imgDogPhoto;
@property (nonatomic, strong) IBOutlet UIButton         *btnEdit;
@property (nonatomic, strong) IBOutlet UIButton         *btnChangePhoto;
@property (nonatomic, strong) IBOutlet UIDatePicker     *datePicker;
@property (nonatomic, strong) IBOutlet UIView           *dateView;
@property (nonatomic, strong) IBOutlet UIView           *genderView;
@property (nonatomic, strong) IBOutlet UIPickerView     *genderPicker;
@property (nonatomic, strong) IBOutlet UIView           *doorView;
@property (nonatomic, strong) IBOutlet UIPickerView     *doorPicker;

@property BOOL                                          isPossibleEdit;

@property (nonatomic, strong) Dog                       *dog;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnChangeClicked:(id)sender;
- (IBAction)btnEditClicked:(id)sender;
- (IBAction)btnDateDoneClicked:(id)sender;
- (IBAction)btnGenderDoneClicked:(id)sender;
- (IBAction)btnDoorDoneClicked:(id)sender;

@end
