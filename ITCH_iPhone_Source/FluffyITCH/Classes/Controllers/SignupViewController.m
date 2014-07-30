//
//  SignupViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SignupViewController.h"
#import "ITCHAppDelegate.h"
#import "SignupViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utils.h"
#import "Constants.h"
#import "JSON.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize etUsername, etPassword, etConfirmPassword, etEmail;

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
    
    self.navigationItem.title = @"Sign up";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnSignupClicked:(id)sender
{
    if(etUsername.text == nil || etUsername.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input username and try again."];
        return;
    }
    
    if(etPassword.text == nil || etPassword.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input password and try again."];
        return;
    }
    
    if(etConfirmPassword.text == nil || etConfirmPassword.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input confirm password and try again."];
        return;
    }
    
    if(![etConfirmPassword.text isEqualToString:etPassword.text])
    {
        [Utils showAlertMessage:@"Password not match. Please input and try again."];
        return;
    }
    
    if(etEmail.text == nil || etEmail.text.length == 0)
    {
        [Utils showAlertMessage:@"Please input email address and try again."];
        return;
    }
    if(![Utils validateEmail:etEmail.text])
    {
        [Utils showAlertMessage:@"Invalid email format. Please input and try again."];
        return;
    }
    
    [self signup];
}

- (void)signup
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SIGNUP_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setTimeOutSeconds:300];[request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        
        // Use when fetching binary data
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] intValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        NSString *registerDate = [jsonValues objectForKey:PARAM_KEY_REGISTER_DATE];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[etUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_USERNAME];
        [defaults setObject:[etPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_PASSWORD];
        [defaults setObject:[etEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_EMAIL];

        int userId = [[jsonValues objectForKey:PARAM_KEY_USERID] intValue];
        [defaults setObject:[NSNumber numberWithInteger:userId] forKey:PARAM_KEY_USERID];
        [defaults setObject:registerDate forKey:PARAM_KEY_REGISTER_DATE];
        
        [defaults synchronize];
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = appDelegate.tabBarVC;

    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[etUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_USERNAME];
    
    NSString *password = [etPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [request addPostValue:password forKey:PARAM_KEY_PASSWORD];
    
    [request addPostValue:etEmail.text forKey:PARAM_KEY_EMAIL];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Connecting"];
}

#pragma mark
#pragma mark - UITouch Event Function

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [etUsername resignFirstResponder];
    [etPassword resignFirstResponder];
    [etConfirmPassword resignFirstResponder];
    [etEmail resignFirstResponder];
}

@end
