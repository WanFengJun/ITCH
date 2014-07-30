//
//  AddDogViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/6/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UITextField     *etName;
    UITextField     *etBirthday;
    UITextField     *etGender;
    UITextField     *etIndoor;
    UITextField     *etBreed;
    
    NSString        *newName;
    NSString        *newBirthday;
    int             newGender;
    NSString        *newBreed;
    int             newIndoor;
    
    UIImage         *dogPhoto;    
}

@property (nonatomic, strong) IBOutlet UITableView      *mTableView;
@property (nonatomic, strong) IBOutlet UIImageView      *imgDogPhoto;
@property (nonatomic, strong) IBOutlet UIDatePicker     *datePicker;
@property (nonatomic, strong) IBOutlet UIView           *dateView;
@property (nonatomic, strong) IBOutlet UIView           *genderView;
@property (nonatomic, strong) IBOutlet UIPickerView     *genderPicker;
@property (nonatomic, strong) IBOutlet UIView           *doorView;
@property (nonatomic, strong) IBOutlet UIPickerView     *doorPicker;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnPhotoClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnDateDoneClicked:(id)sender;
- (IBAction)btnGenderDoneClicked:(id)sender;
- (IBAction)btnDoorDoneClicked:(id)sender;

@end
