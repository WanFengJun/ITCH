//
//  CreateCommentViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "ITCHAppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Dog.h"
#import "Community.h"
#import "Comment.h"

@interface CreateCommentViewController ()

@end

@implementation CreateCommentViewController

@synthesize tvMessage, imgCaptured;
@synthesize community;

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
- (IBAction)btnCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDoneClicked:(id)sender
{
    NSString *message = tvMessage.text;
    
    if(!message || message.length == 0)
    {
        [Utils showAlertMessage:@"Please input message and try again"];
        return;
    }
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int userId = [[defaults objectForKey:PARAM_KEY_USERID] intValue];
    
    int dogId = 0;
    if(!appDelegate.dogList || [appDelegate.dogList count] == 0)
    {
        [Utils showAlertMessage:@"Please add your dog and try again."];
        return;
    }
    
    Dog *dog = [appDelegate.dogList objectAtIndex:0];
    dogId = dog.dogId;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, ADD_COMMENT_URL];
    
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
        
        int commentId = [[jsonValues objectForKey:PARAM_KEY_COMMENT_ID] intValue];
        NSString *photoUrl = [jsonValues objectForKey:PARAM_KEY_PHOTO];
        
        Comment *comment = [Comment new];
        comment.commentId = commentId;
        comment.photoUrl = photoUrl;
        comment.communityId = community.communityId;
        comment.message = tvMessage.text;
        comment.dogPhoto = community.dogPhoto;
        comment.username = community.username;
        comment.date = [Utils getStringFromNSDateTime:[NSDate date]];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setValue:comment forKey:@"comment"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDED_COMMENT object:nil userInfo:dic];
        
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
    [request addPostValue:[NSNumber numberWithInt:community.communityId] forKey:PARAM_KEY_COMMUNITY_ID];
    [request addPostValue:tvMessage.text forKey:PARAM_KEY_COMMENT];
    [request addPostValue:@"" forKey:PARAM_KEY_TITLE];
    [request addPostValue:[Utils getStringFromNSDateTime:[NSDate date]] forKey:PARAM_KEY_DATE];
    
    UIImage *image = imgCaptured.image;
    if(image)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
        [request addData:imageData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:PARAM_KEY_PHOTO];
    }
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Adding new comment..."];
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
    [tvMessage resignFirstResponder];
}

@end
