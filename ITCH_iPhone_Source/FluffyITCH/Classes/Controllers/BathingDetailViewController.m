//
//  BathingDetailViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BathingDetailViewController.h"
#import "Dog.h"
#import "Bathing.h"
#import "JSON.h"
#import "Utils.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "ITCHAppDelegate.h"

@interface BathingDetailViewController ()

@end

@implementation BathingDetailViewController

@synthesize lblTitle, onSwitch, btnCycle, btnStart, btnStop, btnContinue, viewSchedule, btnSave;
@synthesize dog, bathing;

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
    
    self.lblTitle.text = bathing.name;
    
    onSwitch.arrange = CustomSwitchArrangeONLeftOFFRight;
    onSwitch.onImage = [UIImage imageNamed:@"switch_on.png"];
    onSwitch.offImage = [UIImage imageNamed:@"switch_off.png"];
    onSwitch.status = CustomSwitchStatusOn;
    
    if(!bathing.isOn)
        [viewSchedule setHidden:YES];
    else
        [viewSchedule setHidden:NO];
    
    onSwitch.status = bathing.isOn;
    
    if(bathing.startedDate)
    {
        [btnStart setHidden:YES];
        [btnStop setHidden:NO];
        [btnContinue setHidden:NO];
    }
    
    if(bathing.stopDate)
    {
        [btnStart setHidden:NO];
        [btnStop setHidden:YES];
        [btnContinue setHidden:YES];
        
        [btnSave setHidden:YES];
    }
    
    [self initCycleList];
	
    if(bathing.cycle == 0)
        [btnCycle setTitle:[cycleList objectAtIndex:0] forState:UIControlStateNormal];
    else
        [btnCycle setTitle:[cycleList objectAtIndex:bathing.cycle - 1] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Init Cycle List;
- (void)initCycleList
{
    cycleList = [NSMutableArray new];
    
    for (int i = 1; i < 8; i++)
    {
        if(i == 1)
            [cycleList addObject:@"1 Day"];
        else
            [cycleList addObject:[NSString stringWithFormat:@"%d Days", i]];
    }
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnSaveClicked:(id)sender
{
    [self btnStartClicked:sender];
}

- (IBAction)btnStartClicked:(id)sender
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, START_BATHING_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        bathing.isOn = onStatus;
        bathing.startedDate = [Utils getStringFromNSDate:[NSDate date]];
        bathing.cycle = selFreqIdx + 1;
        bathing.stopDate = nil;
        
        [btnSave setHidden:NO];
        
        [self.navigationController popViewControllerAnimated:YES];
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
    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
    [request addPostValue:[NSNumber numberWithInt:bathing.bathingId] forKey:PARAM_KEY_BATHING_ID];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_DATE];
    [request addPostValue:[NSNumber numberWithInt:selFreqIdx + 1] forKey:PARAM_KEY_CYCLE];
    [request addPostValue:[NSNumber numberWithInt:onStatus] forKey:PARAM_KEY_IS_ON];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (IBAction)btnStopClicked:(id)sender
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, STOP_BATHING_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        bathing.stopDate = [Utils getStringFromNSDate:[NSDate date]];
        
        [btnSave setHidden:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    int userId = [defaults integerForKey:PARAM_KEY_USERID];
//    
//    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
//    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
//    [request addPostValue:[NSNumber numberWithInt:bathing.bathingId] forKey:PARAM_KEY_BATHING_ID];
    [request addPostValue:[NSNumber numberWithInt:bathing.usedId] forKey:PARAM_KEY_ID];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_STOP_DATE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (IBAction)btnContinueClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCycleClicked:(id)sender
{
    if(cycleDropDown == nil)
    {
        CGFloat height = 200;
        cycleDropDown = [[NIDropDown alloc] showDropDown:sender :&height :cycleList :nil :@"down"];
        cycleDropDown.delegate = self;
    }
    else
    {
        [cycleDropDown hideDropDown:sender];
        [self rel];
    }
}

#pragma mark
#pragma mark - NLDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selIndex:(int)selIndex
{
    selFreqIdx = selIndex;
    [self rel];
}

-(void)rel
{
    cycleDropDown = nil;
}

#pragma mark
#pragma mark - CustomSwitch delegate
-(void)customSwitchSetStatus:(CustomSwitchStatus)status
{
    onStatus = status;
    
    switch (status) {
        case CustomSwitchStatusOn:
            [viewSchedule setHidden:NO];
            break;
        case CustomSwitchStatusOff:
            [viewSchedule setHidden:YES];
            break;
        default:
            break;
    }
}

@end
