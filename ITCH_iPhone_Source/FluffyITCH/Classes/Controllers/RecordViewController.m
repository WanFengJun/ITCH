//
//  RecordViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "RecordViewController.h"
#import "ITCHAppDelegate.h"
#import "TherapyViewController.h"
#import "ProfileViewController.h"
#import "ChangeDogViewController.h"
#import "FoodViewController.h"
#import "FleasViewController.h"
#import "BathViewController.h"
#import "DogProfileViewController.h"
#import "Dog.h"
#import "Constants.h"
#import "Utils.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize  faderSlider, lblDogName, lblLevel, btnRecord;
@synthesize transparentView, normalView, mildView, veryMildView, moderateView, severeView, extramelySevereView;
//@synthesize _normalView, _normalLable, _mildView, _mildLabel, _veryMildView, _veryMildLabel, _moderateView, _moderateLabel, _severeView, _severeLabel, _extramelySevereView, _extramelySevereLabel;

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
    
    [self faderSliderInit];
    
    [btnRecord setEnabled:NO];
    
    if([self checkRecordOrRevise])
    {
        [btnRecord setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [btnRecord setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnRecord setImage:[UIImage imageNamed:@"btn_revise.png"] forState:UIControlStateNormal];
        [btnRecord setImage:[UIImage imageNamed:@"btn_revise.png"] forState:UIControlStateHighlighted];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDog:) name:NOTIFICATION_CHANGE_DOG object:nil];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!appDelegate.dogList || [appDelegate.dogList count] == 0)
    {
        [Utils showAlertMessage:@"Please add your dog and contiune."];
        return;
    }
    else
    {
        curDog = [appDelegate.dogList objectAtIndex:0];
        lblDogName.text = curDog.name;
    }
    
    backupValue = 0.0;
    
    [normalView setAlpha:0.5];
    [veryMildView setAlpha:0.5];
    [mildView setAlpha:0.5];
    [moderateView setAlpha:0.5];
    [severeView setAlpha:0.5];
    [extramelySevereView setAlpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeDog:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    Dog *paramDog = [userDic objectForKey:@"dog_data"];
    if(!paramDog)
        return;
    
    curDog = paramDog;
    
    lblDogName.text = curDog.name;
}

#pragma mark -
#pragma mark FaderSlider init and action listner

- (void)faderSliderInit {
    
    //Init Fader slider UI, set listener method and Transform it to vertical
    [faderSlider addTarget:self action:@selector(faderSliderAction:) forControlEvents:UIControlEventValueChanged];
    faderSlider.backgroundColor = [UIColor clearColor];
    
    UIImage *stetchTrack = [UIImage imageNamed:@"slide_1.png"];
    [faderSlider setThumbImage: [UIImage imageNamed:@"slider_ball_1.png"] forState:UIControlStateNormal];
    [faderSlider setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
    [faderSlider setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    faderSlider.transform = trans;
    
    [faderSlider setValue:0.0];
}

#define STEP_INC 1
#define STEP_DEC -1

- (void)faderSliderAction:(id)sender
{
    float value = [faderSlider value];
    
    [lblLevel setText:[NSString stringWithFormat:@"%.1f", value]];
    
    if(value == 0)
        [btnRecord setEnabled:NO];
    else
        [btnRecord setEnabled:YES];
    
    if([self checkRecordOrRevise])
    {
        [btnRecord setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [btnRecord setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btnRecord setImage:[UIImage imageNamed:@"btn_revise.png"] forState:UIControlStateNormal];
        [btnRecord setImage:[UIImage imageNamed:@"btn_revise.png"] forState:UIControlStateHighlighted];
    }
    
    float a = 0.0, b = 0.0;
    int stepmode = STEP_INC;
    
    if(backupValue > value)
        stepmode = STEP_DEC; //dec
    else
        stepmode = STEP_INC; //inc
    
    if(value < 1)
    {
        a = value * 0.5;
        a = a + 0.5;
        [normalView setAlpha:a];
    }
    else if(1 < value && value < 3)
    {
        if(stepmode == STEP_INC)
        {
            b = (value - 1) * 0.5 * 0.5;
            b = 1 - b;
            [normalView setAlpha:b];
        }
        
        a = (value - 1) * 0.5 * 0.5;
        a = a + 0.5;
        [veryMildView setAlpha:a];
    }
    else if(3 < value && value < 5)
    {
        if(stepmode == STEP_INC)
        {
            b = (value - 3) * 0.5 * 0.5;
            b = 1 - b;
            [veryMildView setAlpha:b];
        }
        a = (value - 3) * 0.5 * 0.5;
        a = a + 0.5;
        [mildView setAlpha:a];
    }
    else if(5 < value && value < 7)
    {
        if(stepmode == STEP_INC)
        {
            b = (value - 5) * 0.5 * 0.5;
            b = 1 - b;
            [mildView setAlpha:b];
        }
        a = (value - 5) * 0.5 * 0.5;
        a = a + 0.5;
        [moderateView setAlpha:a];
    }
    else if(7 < value && value < 9)
    {
        if(stepmode == STEP_INC)
        {
            b = (value - 7) * 0.5 * 0.5;
            b = 1 - b;
            [moderateView setAlpha:b];
        }
        a = (value - 7) * 0.5 * 0.5;
        a = a + 0.5;
        [severeView setAlpha:a];
    }
    else if(9 < value && value < 10)
    {
        if(stepmode == STEP_INC)
        {
            b = (value - 9) * 0.5;
            b = 1 - b;
            [severeView setAlpha:b];
            
        }
        a = (value - 9) * 0.5;
        a = a + 0.5;
        [extramelySevereView setAlpha:a];
    }
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnProfileClicked:(id)sender
{
    DogProfileViewController *vc = [[DogProfileViewController alloc] initWithNibName:@"DogProfileViewController" bundle:nil];
    vc.dog = curDog;
    vc.isPossibleEdit = YES;
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarVC presentViewController:vc animated:YES completion:nil];
}

- (IBAction)btnChangeDogClicked:(id)sender
{
    ChangeDogViewController *vc = [[ChangeDogViewController alloc] initWithNibName:@"ChangeDogViewController" bundle:nil];
    vc.from = FROM_RECORD_VIEW;
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarVC presentViewController:vc animated:YES completion:nil];
}

- (IBAction)btnRecordClicked:(id)sender
{
    
    if([self checkRecordOrRevise])
        [self addRecord:faderSlider.value];
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *todayStr = [Utils getStringFromNSDate:[NSDate date]];
        float originalValue = [defaults floatForKey:todayStr];
        
        [self addRecord:originalValue];
    }
}

// If YES, Record. If NO, Revise.
- (BOOL)checkRecordOrRevise
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *todayStr = [Utils getStringFromNSDate:[NSDate date]];
    float originalValue = [defaults floatForKey:todayStr];

    if(originalValue > 0.0f)
        return NO;
    
    return YES;
}

- (void)addRecord:(float)value
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, ADD_ITCH_RECORD_URL];
    
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
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *todayStr = [Utils getStringFromNSDate:[NSDate date]];
        
        [defaults setObject:[NSString stringWithFormat:@"%.1f", faderSlider.value] forKey:todayStr];
        [defaults synchronize];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [defaults integerForKey:PARAM_KEY_USERID];
    
    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInt:curDog.dogId] forKey:PARAM_KEY_DOG_ID];
    [request addPostValue:[NSString stringWithFormat:@"%.1f", value] forKey:PARAM_KEY_LEVEL];
    
    NSString *date = [Utils getStringFromNSDate:[NSDate date]];
    [request addPostValue:date forKey:PARAM_KEY_DATE];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [request addPostValue:[NSNumber numberWithDouble:appDelegate.curLocation.coordinate.longitude] forKey:PARAM_KEY_LONGITUDE];
    [request addPostValue:[NSNumber numberWithDouble:appDelegate.curLocation.coordinate.latitude] forKey:PARAM_KEY_LATITUDE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Connecting"];
}

- (IBAction)btnAddMedicationClicked:(id)sender
{
    TherapyViewController *vc = [[TherapyViewController alloc] initWithNibName:@"TherapyViewController" bundle:nil];
    vc.dog = curDog;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAddFoodClicked:(id)sender
{
    FoodViewController *vc = [[FoodViewController alloc] initWithNibName:@"FoodViewController" bundle:nil];
    vc.dog = curDog;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAddFealClicked:(id)sender
{
    FleasViewController *vc = [[FleasViewController alloc] initWithNibName:@"FleasViewController" bundle:nil];
    vc.dog = curDog;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAddBathingClicked:(id)sender
{
    BathViewController *vc = [[BathViewController alloc] initWithNibName:@"BathViewController" bundle:nil];
    vc.dog = curDog;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
