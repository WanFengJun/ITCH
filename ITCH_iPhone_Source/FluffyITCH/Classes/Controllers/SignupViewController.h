//
//  SignupViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField  *etUsername;
@property (nonatomic, strong) IBOutlet UITextField  *etPassword;
@property (nonatomic, strong) IBOutlet UITextField  *etConfirmPassword;
@property (nonatomic, strong) IBOutlet UITextField  *etEmail;

- (IBAction)btnSignupClicked:(id)sender;


@end
