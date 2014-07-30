//
//  AddDogViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/6/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "AddDogViewController.h"
#import "DogProfileTableViewCell.h"
#import "ITCHAppDelegate.h"
#import "Dog.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface AddDogViewController ()

@end

@implementation AddDogViewController

@synthesize mTableView, imgDogPhoto, datePicker, dateView, genderPicker, genderView, doorView, doorPicker;

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
    
    newBirthday = nil;
    newGender = -1;
    newBreed = nil;
    newIndoor = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDogPhoto:) name:NOTIFICATION_ADD_DOG_PHOTO object:nil];
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
    return 5;
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
            cell.lblTitle.text = @"Name:";
            
            if(newName)
                cell.etValue.text = newName;
            
            etName = cell.etValue;
            break;
        case 1:
            cell.lblTitle.text = @"Date of Birth:";
            
            if(newBirthday)
                cell.etValue.text = newBirthday;
            
            etBirthday = cell.etValue;
            break;
        case 2:
            cell.lblTitle.text = @"Gender:";
            
            if(newGender != -1)
                cell.etValue.text = newGender == GENDER_MALE ? @"Male" : @"Female";
            
            etGender = cell.etValue;
            break;
        case 3:
            cell.lblTitle.text = @"Breed";
            
            if(newBreed)
                cell.etValue.text = newBreed;
            
            etBreed = cell.etValue;
            break;
        case 4:
            cell.lblTitle.text = @"Indoor/Outdoor";
            
            if(newIndoor != -1)
                cell.etValue.text = newIndoor == INDOOR ? @"Indoor" : @"Outdoor";
            
            etIndoor = cell.etValue;
            break;
            
        default:
            break;
    }
    
    cell.etValue.delegate = self;
    
    return cell;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:etName])
        newName = textField.text;
    else if([textField isEqual:etBreed])
        newBreed = textField.text;
    
    [textField resignFirstResponder];
    [mTableView reloadData];
    
    return YES;
}

#pragma mark
#pragma mark - Picker View Show / Hide
- (void)showDateView:(BOOL)flag
{
    if(flag)
    {
        [dateView setFrame:CGRectMake(0, 340, 320, 240)];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPhotoClicked:(id)sender
{
    [self takePhoto];
}

- (IBAction)btnSaveClicked:(id)sender
{
    if(!etName.text || etName.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input dog's name and try again."];
        return;
    }
    else if(!etBirthday.text || etBirthday.text.length == 0)
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
    else if(!etIndoor.text || etIndoor.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input dog's door and try again."];
        return;
    }
    else if(!dogPhoto)
    {
        [Utils showAlertMessage:@"Please take dog's photo and try again."];
        return;
    }
    
    [self save];
}

- (void)save
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, ADD_DOG_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSData *imageData = UIImageJPEGRepresentation(dogPhoto, 0.1f);

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
        
        // Add dog
        int dogId = [[jsonValues objectForKey:PARAM_KEY_DOG_ID] intValue];
        NSString *_dogPhoto = [jsonValues objectForKey:PARAM_KEY_DOG_PHOTO];
        
        Dog *newDog = [Dog new];
        
        newDog.name = etName.text;
        newDog.dogId = dogId;
        newDog.birth = etBirthday.text;
        newDog.gender = newGender;
        newDog.breed = etBreed.text;
        newDog.door = newIndoor;
        newDog.photo = _dogPhoto;
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.dogList addObject:newDog];
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
    [request addPostValue:etName.text forKey:PARAM_KEY_DOG_NAME];
    [request addPostValue:etBirthday.text forKey:PARAM_KEY_DOG_BIRTH];
    [request addPostValue:etBreed.text forKey:PARAM_KEY_DOG_BREED];
    [request addPostValue:[NSNumber numberWithInt:newGender] forKey:PARAM_KEY_DOG_GENDER];
    [request addPostValue:[NSNumber numberWithInt:newIndoor] forKey:PARAM_KEY_DOG_DOOR];
    
    [request addData:imageData withFileName:@"dog_photo.jpg" andContentType:@"image/jpeg" forKey:PARAM_KEY_DOG_PHOTO];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Adding new dog..."];
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
    
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)addDogPhoto:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    UIImage *_dogPhoto = [userDic objectForKey:@"dog_photo"];
    if(!_dogPhoto)
        return;
    
    imgDogPhoto.image = dogPhoto;
}

#pragma mark
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    dogPhoto = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:image forKey:@"dog_photo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_DOG_PHOTO object:nil userInfo:dic];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
