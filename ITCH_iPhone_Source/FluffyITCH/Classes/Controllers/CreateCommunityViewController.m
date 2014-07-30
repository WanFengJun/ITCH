//
//  CreateCommunityViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CreateCommunityViewController.h"
#import "ITCHAppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Dog.h"
#import "Community.h"

@interface CreateCommunityViewController ()

@end

@implementation CreateCommunityViewController

@synthesize tvTitle, tvMessage, imgCaptured;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDoneClicked:(id)sender
{
    NSString *title = tvTitle.text;
    NSString *message = tvMessage.text;
    
    if(!title || title.length == 0)
    {
        [Utils showAlertMessage:@"Please input title and try again"];
        return;
    }
    
    if(!message || message.length == 0)
    {
        [Utils showAlertMessage:@"Please input message and try again"];
        return;
    }
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int userId = [[defaults objectForKey:PARAM_KEY_USERID] intValue];
    NSString *username = [defaults objectForKey:PARAM_KEY_USERNAME];
    
    int dogId = 0;
    if(!appDelegate.dogList || [appDelegate.dogList count] == 0)
    {
        [Utils showAlertMessage:@"Please add your dog and try again."];
        return;
    }
    
    Dog *dog = [appDelegate.dogList objectAtIndex:0];
    dogId = dog.dogId;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, ADD_COMMUNITY_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
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
        
        int communityId = [[jsonValues objectForKey:PARAM_KEY_COMMUNITY_ID] intValue];
        NSString *serverCurTime = [jsonValues objectForKey:PARAM_KEY_SERVER_CUR_TIME];
        NSString *photoUrl = [jsonValues objectForKey:PARAM_KEY_PHOTO];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        Community *item = [Community new];
        item.communityId = communityId;
        item.title = title;
        item.content = tvMessage.text;
        item.photoUrl = photoUrl;
        item.date = serverCurTime;
        item.serverCurTime = serverCurTime;
        item.dogId = dogId;
        item.userId = userId;
        item.username = username;
        item.commentCount = 0;
        item.dogPhoto = dog.photo;
        
        [dic setValue:item forKey:@"community"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDED_COMMUNITY object:nil userInfo:dic];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[NSNumber numberWithInteger:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInteger:dogId] forKey:PARAM_KEY_DOG_ID];
    
    [request addPostValue:tvTitle.text forKey:PARAM_KEY_TITLE];
    [request addPostValue:tvMessage.text forKey:PARAM_KEY_CONTENT];
    [request addPostValue:[Utils getStringFromNSDateTime:[NSDate date]] forKey:PARAM_KEY_DATE];
    
    UIImage *image = imgCaptured.image;
    if(image)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
        [request addData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:PARAM_KEY_PHOTO];
    }
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Adding new community..."];
}

- (IBAction)btnTakePhotoClicked:(id)sender
{
    [self takePhoto];
}

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    imgCaptured.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark
#pragma mark - UITouch Event Function

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tvTitle resignFirstResponder];
    [tvMessage resignFirstResponder];
}

@end
