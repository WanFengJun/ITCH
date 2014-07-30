//
//  LoginViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField  *etUsername;
@property (nonatomic, strong) IBOutlet UITextField  *etPassword;

- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnSignupClicked:(id)sender;

@end
