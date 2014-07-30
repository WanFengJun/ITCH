//
//  TherapyDetailViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "TherapyDetailViewController.h"
#import "ITCHAppDelegate.h"
#import "Therapy.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "Utils.h"
#import "Dog.h"
#import "MedAmount.h"
#import "MedFrequency.h"

@interface TherapyDetailViewController ()

@end

@implementation TherapyDetailViewController

@synthesize lblTitle, onSwitch, btnUnit, btnCycle, btnStart, btnStop, btnContinue, viewSchedule, btnSave;
@synthesize therapy, dog;

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
    
    self.lblTitle.text = therapy.name;
    
    onSwitch.arrange = CustomSwitchArrangeONLeftOFFRight;
    onSwitch.onImage = [UIImage imageNamed:@"switch_on.png"];
    onSwitch.offImage = [UIImage imageNamed:@"switch_off.png"];
    
    [self initUnitList];
    [self initCycleList];
	
	[btnUnit setTitle:therapy.amount.name forState:UIControlStateNormal];
    [btnCycle setTitle:therapy.frequency.name forState:UIControlStateNormal];
    
    if(!therapy.isOn)
        [viewSchedule setHidden:YES];
    else
        [viewSchedule setHidden:NO];
    
    onSwitch.status = therapy.isOn;
    
    if(therapy.startedDate)
    {
        [btnStart setHidden:YES];
        [btnStop setHidden:NO];
        [btnContinue setHidden:NO];
    }
    
    if(therapy.stopDate)
    {
        [btnStart setHidden:NO];
        [btnStop setHidden:YES];
        [btnContinue setHidden:YES];
        
        [btnSave setHidden:YES];
    }
    
    // Init selAmountIdx, selFreqIdx;
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < [appDelegate.medAmountList count]; i++)
    {
        MedAmount *amount = [appDelegate.medAmountList objectAtIndex:i];
        if(amount.amountId == therapy.amountId)
        {
            selAmountIdx = i;
            break;
        }
    }
    
    for (int i = 0; i < [appDelegate.medFrequencyList count]; i++)
    {
        MedFrequency *freq = [appDelegate.medFrequencyList objectAtIndex:i];
        if(freq.frequencyId == therapy.frequencyId)
        {
            selFreqIdx = i;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUnitList
{
    unitList = [NSMutableArray new];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < [appDelegate.medAmountList count]; i++)
    {
        NSString *unit = ((MedAmount *)[appDelegate.medAmountList objectAtIndex:i]).name;
        [unitList addObject:unit];
    }
}

- (void)initCycleList
{
    cycleList = [NSMutableArray new];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < [appDelegate.medFrequencyList count]; i++)
    {
        NSString *unit = ((MedFrequency *)[appDelegate.medFrequencyList objectAtIndex:i]).name;
        [cycleList addObject:unit];
    }
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnUnitClicked:(id)sender
{
    if(unitDropDown == nil)
    {
        CGFloat height = 200;
        unitDropDown = [[NIDropDown alloc] showDropDown:sender :&height :unitList :nil :@"down"];
        unitDropDown.delegate = self;
    }
    else
    {
        [unitDropDown hideDropDown:sender];
        [self rel];
    }
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

- (IBAction)btnSaveClicked:(id)sender
{
    [self btnStartClicked:sender];
}

- (IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnStartClicked:(id)sender
{
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, START_MEDICATION_URL];
    
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
        
        therapy.isOn = onStatus;
        therapy.startedDate = [Utils getStringFromNSDate:[NSDate date]];
        therapy.amount = (MedAmount *)[appDelegate.medAmountList objectAtIndex:selAmountIdx];
        therapy.frequency = (MedFrequency *)[appDelegate.medFrequencyList objectAtIndex:selFreqIdx];
        therapy.amountId = therapy.amount.amountId;
        therapy.frequencyId = therapy.frequency.frequencyId;
        therapy.stopDate = nil;
        
        if(therapy.frequencyId == 1 || therapy.frequencyId == 2 || therapy.frequencyId == 3)
        {
            therapy.cycle = [therapy.frequency.name intValue];
            therapy.cycleType = CYCLE_TYPE_HOUR;
        }
        else if(therapy.frequencyId == 4)
        {
            therapy.cycleType = CYCLE_TYPE_DAY;
            therapy.cycle = 1;
        }
        else
        {
            therapy.cycleType = CYCLE_TYPE_DAY;
            therapy.cycle = [therapy.frequency.name intValue];
        }
        
        therapy.unit = therapy.amount.name;
        therapy.stopDate = nil;
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
    [request addPostValue:[NSNumber numberWithInt:therapy.therapyId] forKey:PARAM_KEY_MEDID];
    
    [request addPostValue:[NSNumber numberWithInt:((MedAmount *)[appDelegate.medAmountList objectAtIndex:selAmountIdx]).amountId] forKey:PARAM_KEY_UNIT_ID];
    [request addPostValue:[NSNumber numberWithInt:((MedFrequency *)[appDelegate.medFrequencyList objectAtIndex:selFreqIdx]).frequencyId] forKey:PARAM_KEY_FREQUENCY_ID];
    
    [request addPostValue:[NSNumber numberWithInt:0] forKey:PARAM_KEY_CHECK_COUNT];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_START_DATE];
    
    [request addPostValue:[NSNumber numberWithInt:onStatus] forKey:PARAM_KEY_IS_ON];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (IBAction)btnStopClicked:(id)sender
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, STOP_MEDICATION_URL];
    
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
        
        therapy.stopDate = [Utils getStringFromNSDate:[NSDate date]];
        
        [btnSave setHidden:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[NSNumber numberWithInt:therapy.usedId] forKey:PARAM_KEY_ID];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_STOP_DATE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (IBAction)btnContiuneClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - NLDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selIndex:(int)selIndex
{
    if([sender isEqual:unitDropDown])
        selAmountIdx = selIndex;
    else
        selFreqIdx = selIndex;
    
    [self rel];
}

-(void)rel
{
    unitDropDown = nil;
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
