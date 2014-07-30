//
//  LoginViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "LoginViewController.h"
#import "ITCHAppDelegate.h"
#import "SignupViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utils.h"
#import "Constants.h"
#import "JSON.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize etUsername, etPassword;

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
    
    self.navigationItem.title = @"Login";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnLoginClicked:(id)sender
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
    
    [self login];
}

- (void)login
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, LOGIN_URL];
    
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
        
        int userId = [[jsonValues objectForKey:PARAM_KEY_USERID] intValue];
        NSString *email = [jsonValues objectForKey:PARAM_KEY_EMAIL];
        NSString *registerDate = [jsonValues objectForKey:PARAM_KEY_REGISTER_DATE];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[etUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_USERNAME];
        
        NSString *password = [etPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [defaults setObject:password forKey:PARAM_KEY_PASSWORD];
        [defaults setObject:[NSNumber numberWithInteger:userId] forKey:PARAM_KEY_USERID];
        [defaults setObject:email forKey:PARAM_KEY_EMAIL];
        [defaults setObject:registerDate forKey:PARAM_KEY_REGISTER_DATE];
        
        [defaults synchronize];
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.window.rootViewController = appDelegate.tabBarVC;
        
        [appDelegate loadDataList:userId];
        
        etUsername.text = @"";
        etPassword.text = @"";
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[etUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:PARAM_KEY_USERNAME];
    
    NSString *password = [etPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    password = [password stringByReplacingOccurrencesOfString:@"!" withString:@"&#33;"];
    
    [request addPostValue:password forKey:PARAM_KEY_PASSWORD];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Connecting"];
}

- (IBAction)btnSignupClicked:(id)sender
{
    SignupViewController *vc = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
#pragma mark - UITouch Event Function

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [etUsername resignFirstResponder];
    [etPassword resignFirstResponder];
}

@end
