//
//  DogProfileViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "DogProfileViewController.h"
#import "DogProfileTableViewCell.h"
#import "ITCHAppDelegate.h"
#import "Dog.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface DogProfileViewController ()

@end

@implementation DogProfileViewController

@synthesize mTableView, lblTitle, imgDogPhoto, btnChangePhoto, btnEdit, datePicker, dateView, genderPicker, genderView, doorPicker, doorView;
@synthesize dog, isPossibleEdit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(dog)
        lblTitle.text = [NSString stringWithFormat:@"%@\' Profile", dog.name];
    
    newBirthday = nil;
    newGender = dog.gender;
    newBreed = nil;
    newIndoor = dog.door;
    
    if(isPossibleEdit)
       [btnEdit setHidden:YES];
    
    if(dog.image)
        imgDogPhoto.image = dog.image;
    else
    {
        if(dog.photo)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, PHOTO_BASE_URL, dog.photo];
            NSURL *imageURL = [NSURL URLWithString:url];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    self.dog.image = [UIImage imageWithData:imageData];
                    imgDogPhoto.image = dog.image;
                });
            });
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDogPhoto:) name:NOTIFICATION_CHAGE_DOG_PHOTO object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DogProfileTableViewCell *cell = (DogProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DogProfileTableViewCell"];
    
    if(!cell)
    {
        NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"DogProfileTableViewCell" owner:self options:nil];
        for(id currentObject in topObjects)
        {
            if([currentObject isKindOfClass:[DogProfileTableViewCell class]])
            {
                cell = (DogProfileTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0:
            cell.lblTitle.text = @"Date of Birth:";
            
            if(!newBirthday)
                cell.etValue.text = dog.birth;
            else
                cell.etValue.text = newBirthday;
            
            etBirthday = cell.etValue;
            break;
        case 1:
            cell.lblTitle.text = @"Gender:";
            
            if(newGender != -1)
                cell.etValue.text = newGender == GENDER_MALE ? @"Male" : @"Female";
            else
                cell.etValue.text = dog.gender == GENDER_MALE ? @"Male" : @"Female";
            
            etGender = cell.etValue;
            break;
        case 2:
            cell.lblTitle.text = @"Breed";
            
            if(!newBreed)
                cell.etValue.text = dog.breed;
            else
                cell.etValue.text = newBreed;
            
            etBreed = cell.etValue;
            break;
        case 3:
            cell.lblTitle.text = @"Indoor/Outdoor";
            
            if(newIndoor != -1)
                cell.etValue.text = newIndoor == INDOOR ? @"Indoor" : @"Outdoor";
            else
            {
                cell.etValue.text = dog.door == INDOOR ? @"Indoor" : @"Outdoor";
                newIndoor = dog.door;
            }
            
            
            etIndoor = cell.etValue;
            break;
            
        default:
            break;
    }

    cell.etValue.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    if([thePickerView isEqual:genderPicker])
    {
        if(row == 0)
            title = @"Male";
        else
            title = @"Female";
    }
    else
    {
        if(row == 0)
            title = @"Indoor";
        else
            title = @"Outdoor";
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([thePickerView isEqual:genderPicker])
    {
        if(row == 0)
            newGender = GENDER_MALE;
        else
            newGender = GENDER_FEMALE;
    }
    else
    {
        if(row == 0)
            newIndoor = INDOOR;
        else
            newIndoor = OUTDOOR;
    }
    
    [mTableView reloadData];
}

#pragma mark
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([btnEdit.titleLabel.text isEqualToString:@"EDIT"])
        return NO;
    else
    {
        if([textField isEqual:etBirthday])  //Birthday TextField
        {
            [self showDateView:YES];
            return NO;
        }
        else if([textField isEqual:etGender])
        {
            [self showGenderView:YES];
            return NO;
        }
        else if([textField isEqual:etIndoor])
        {
            [self showDoorView:YES];
            return NO;
        }
        
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    etBreed.text = textField.text;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark - Picker View Show / Hide
- (void)showDateView:(BOOL)flag
{
    if(flag)
    {
        [dateView setFrame:CGRectMake(0, 279, 320, 240)];
        [self.view addSubview:dateView];
    }
    else
        [dateView removeFromSuperview];
}

- (void)showGenderView:(BOOL)flag
{
    if(flag)
    {
        [genderView setFrame:CGRectMake(0, 339, 320, 240)];
        [self.view addSubview:genderView];
    }
    else
        [genderView removeFromSuperview];
}

- (void)showDoorView:(BOOL)flag
{
    if(flag)
    {
        [doorView setFrame:CGRectMake(0, 339, 320, 240)];
        [self.view addSubview:doorView];
    }
    else
        [doorView removeFromSuperview];
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnBackClicked:(id)sender
{
    if(isPossibleEdit)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChangeClicked:(id)sender
{
    [self takePhoto];
}

- (IBAction)btnEditClicked:(id)sender
{
    if([btnEdit.titleLabel.text isEqualToString:@"EDIT"])
    {
        [btnEdit setTitle:@"SAVE" forState:UIControlStateNormal];
        [btnEdit setTitle:@"SAVE" forState:UIControlStateHighlighted];
        
        [btnChangePhoto setHidden:NO];
    }
    else
    {
        [btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
        [btnEdit setTitle:@"EDIT" forState:UIControlStateHighlighted];
        
        [btnChangePhoto setHidden:YES];
        
        // Save
        if(!etBirthday.text || etBirthday.text.length == 0)
        {
            [Utils showAlertMessage:@"Please input dog's birthday and try again."];
            return;
        }
        else if(!etGender.text || etGender.text.length == 0)
        {
            [Utils showAlertMessage:@"Please input dog's gender and try again."];
            return;
        }
        else if(!etBreed.text || etBreed.text.length == 0)
        {
            [Utils showAlertMessage:@"Please input dog's breed and try again."];
            return;
        }
        else if(newIndoor == -1)
        {
            [Utils showAlertMessage:@"Please input dog's door and try again."];
            return;
        }
        
        [self save];
    }
    
    [mTableView reloadData];
}

- (void)save
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, UPDATE_DOG_PROFILE_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setTimeOutSeconds:300];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        NSInteger success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        NSString *photo = [jsonValues objectForKey:PARAM_KEY_DOG_PHOTO];
        
        dog.birth = etBirthday.text;
        dog.gender = newGender;
        dog.breed = etBreed.text;
        dog.door = newIndoor;
        dog.photo = photo;
        
        dog.image = dogPhoto;
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger userId = [[defaults objectForKey:PARAM_KEY_USERID] integerValue];
    
    [request addPostValue:[NSNumber numberWithInteger:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
    [request addPostValue:dog.name forKey:PARAM_KEY_DOG_NAME];
    [request addPostValue:etBirthday.text forKey:PARAM_KEY_DOG_BIRTH];
    [request addPostValue:etBreed.text forKey:PARAM_KEY_DOG_BREED];
    [request addPostValue:[NSNumber numberWithInt:newGender] forKey:PARAM_KEY_DOG_GENDER];
    [request addPostValue:[NSNumber numberWithInt:newIndoor] forKey:PARAM_KEY_DOG_DOOR];
    
    if(dogPhoto)
    {
        NSData *imageData = UIImageJPEGRepresentation(dogPhoto, 0.1f);
        [request addData:imageData withFileName:@"dog_photo.jpg" andContentType:@"image/jpeg" forKey:PARAM_KEY_DOG_PHOTO];
    }
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Updating dog..."];
}

- (IBAction)btnDateDoneClicked:(id)sender
{
    [self showDateView:NO];
    
    newBirthday = [Utils getStringFromNSDate:datePicker.date];
    
    [mTableView reloadData];
}

- (IBAction)btnGenderDoneClicked:(id)sender
{
    [self showGenderView:NO];
    
    [mTableView reloadData];
}

- (IBAction)btnDoorDoneClicked:(id)sender
{
    [self showDoorView:NO];
    
    [mTableView reloadData];
}

#pragma mark
#pragma mark - Take Photo Function

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    imagePickerController.delegate = appDelegate.tabBarVC;
    appDelegate.tabBarVC.photoRequest = PHOTO_REQUEST_FROM_DOG_PROFILE;
    [appDelegate.tabBarVC presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)changeDogPhoto:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    UIImage *_dogPhoto = [userDic objectForKey:@"dog_photo"];
    if(!_dogPhoto)
        return;
    
    dogPhoto = _dogPhoto;
    imgDogPhoto.image = dogPhoto;
}

@end
