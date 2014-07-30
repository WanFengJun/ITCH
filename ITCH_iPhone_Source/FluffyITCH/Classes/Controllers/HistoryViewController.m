//
//  HistoryViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "HistoryViewController.h"
#import "Flea.h"
#import "ITCHAppDelegate.h"
#import "JSON.h"
#import "Utils.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "Dog.h"
#import "Therapy.h"
#import "Food.h"
#import "Bathing.h"
#import "ITCHRecord.h"
#import "MedFrequency.h"
#import "MedAmount.h"
#import "ITCHHistoryTableViewCell.h"
#import "FleaHistoryTableViewCell.h"
#import "TherapyHistoryTableViewCell.h"
#import "FoodHistoryTableViewCell.h"
#import "FleaHistoryTableViewCell.h"
#import "BathingHistoryTableViewCell.h"
#import "ChangeDogViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize lblDate, lblTitle, mTableView;

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
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *yesterday = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    curDate = yesterday;
    lblDate.text = [Utils getStringFromNSDate:curDate];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!appDelegate.dogList || [appDelegate.dogList count] == 0)
        return;
    
    curDog = [appDelegate.dogList objectAtIndex:0];
    lblTitle.text = [NSString stringWithFormat:@"%@\' History", curDog.name];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDog:) name:NOTIFICATION_HISTORY_CHANGE_DOG object:nil];
    
    [self loadHistoryData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnPrevDateClicked:(id)sender
{
    itchRecord = nil;
    medicationList = nil;
    foodList = nil;
    flea = nil;
    bathingList = nil;
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *prevDate = [theCalendar dateByAddingComponents:dayComponent toDate:curDate options:0];
    
    curDate = prevDate;
    lblDate.text = [Utils getStringFromNSDate:curDate];
    
    [self loadHistoryData];
}

- (IBAction)btnNextDateClicked:(id)sender
{
    NSDateComponents *diff = [Utils getDiffNSDate:curDate toDate:[NSDate date]];
    int day = diff.day;
    if(day == 1)
        return;
    
    itchRecord = nil;
    medicationList = nil;
    foodList = nil;
    flea = nil;
    bathingList = nil;
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:curDate options:0];
    
    if([[Utils getStringFromNSDate:curDate] isEqualToString:[Utils getStringFromNSDate:[NSDate date]]])
        return;
    
    curDate = nextDate;
    
    lblDate.text = [Utils getStringFromNSDate:curDate];
    
    [self loadHistoryData];
}

- (IBAction)btnAddRecordClicked:(id)sender
{
    
}

- (IBAction)btnChangeDogClicked:(id)sender
{
    ChangeDogViewController *vc = [[ChangeDogViewController alloc] initWithNibName:@"ChangeDogViewController" bundle:nil];
    vc.from = FROM_HISTORY_VIEW;
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarVC presentViewController:vc animated:YES completion:nil];
}

- (void)changeDog:(NSNotification*)notification
{
    NSDictionary *userDic = [notification userInfo];
    Dog *paramDog = [userDic objectForKey:@"dog_data"];
    if(!paramDog)
        return;
    
    curDog = paramDog;
    
    lblTitle.text = [NSString stringWithFormat:@"%@\' History", curDog.name];
    
    [self loadHistoryData];
}

#pragma mark
#pragma mark Load History Data with Date
- (void)loadHistoryData
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_ALL_HISTORY_URL];
    
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
        
        NSDictionary *dicItch = [jsonValues objectForKey:PARAM_KEY_ITCH];
        if(dicItch)
        {
            if([dicItch count] > 0)
            {
                itchRecord = [ITCHRecord new];
                
                itchRecord.recordId = [[dicItch objectForKey:PARAM_KEY_RECORD_ID] intValue];
                itchRecord.dogId = [[dicItch objectForKey:PARAM_KEY_DOG_ID] intValue];
                itchRecord.level = [[dicItch objectForKey:PARAM_KEY_LEVEL] floatValue];
                itchRecord.date = [Utils getStringFromNSDate:curDate];
                itchRecord.latitude = [[dicItch objectForKey:PARAM_KEY_LATITUDE] floatValue];
                itchRecord.longitude = [[dicItch objectForKey:PARAM_KEY_LONGITUDE] floatValue];
                itchRecord.userId = [[dicItch objectForKey:PARAM_KEY_USERID] intValue];
            }
            else
                itchRecord = nil;
        }
        
        NSDictionary *dicFlea = [jsonValues objectForKey:PARAM_KEY_FLEA];
        if(dicFlea)
        {
            if([dicFlea count] > 0)
            {
                flea = [Flea new];
                
                flea.fleaId = [[dicFlea objectForKey:PARAM_KEY_FLEA_ID] intValue];
                flea.dogId = [[dicFlea objectForKey:PARAM_KEY_DOG_ID] intValue];
                flea.userId = [[dicFlea objectForKey:PARAM_KEY_USERID] intValue];
                flea.countValue = [[dicFlea objectForKey:PARAM_KEY_COUNT_VALUE] intValue];
                flea.date = [Utils getStringFromNSDate:curDate];
            }
            else
                flea = nil;
        }
        
        medicationList = [NSMutableArray new];
        foodList = [NSMutableArray new];
        bathingList = [NSMutableArray new];
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *medDicList = [jsonValues objectForKey:PARAM_KEY_MEDICATION];
        if(medDicList)
        {
            for (int i = 0; i < [medDicList count]; i++)
            {
                NSDictionary *dic = [medDicList objectAtIndex:i];
                
                Therapy *item = [Therapy new];
                
                item.therapyId = [[dic objectForKey:PARAM_KEY_MEDID] intValue];
                item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
                item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
                item.checkCount = [[dic objectForKey:PARAM_KEY_CHECK_COUNT] intValue];
                item.checkIndex = [[dic objectForKey:PARAM_KEY_CHECK_INDEX] intValue];
                item.frequencyId = [[dic objectForKey:PARAM_KEY_FREQUENCY_ID] intValue];
                item.amountId = [[dic objectForKey:PARAM_KEY_UNIT_ID] intValue];
                item.isOn = [[dic objectForKey:PARAM_KEY_IS_ON] boolValue];
                item.startedDate = [dic objectForKey:PARAM_KEY_START_DATE];
                item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
                item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
                
                if([item.stopDate isKindOfClass:[NSNull class]])
                    item.stopDate = nil;
                else if([item.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                    item.stopDate = nil;
                
                for (int a = 0; a < [appDelegate.fullTherapyList count]; a++)
                {
                    Therapy *therapy = [appDelegate.fullTherapyList objectAtIndex:a];
                    if(therapy.therapyId == item.therapyId)
                    {
                        item.name = therapy.name;
                        break;
                    }
                }
                
                for (int ci = 0; ci < [appDelegate.medFrequencyList count]; ci++)
                {
                    MedFrequency *freq = [appDelegate.medFrequencyList objectAtIndex:ci];
                    if(freq.frequencyId == item.frequencyId)
                    {
                        item.frequency = freq;
                        break;
                    }
                }
                
                for (int ai = 0; ai < [appDelegate.medAmountList count]; ai++)
                {
                    MedAmount *amount = [appDelegate.medAmountList objectAtIndex:ai];
                    if(amount.amountId == item.amountId)
                    {
                        item.amount = amount;
                        item.unit = amount.name;
                        break;
                    }
                }
                
                if(item.frequencyId == 1 || item.frequencyId == 2 || item.frequencyId == 3)
                {
                    item.cycle = [item.frequency.name intValue];
                    item.cycleType = CYCLE_TYPE_HOUR;
                }
                else if(item.frequencyId == 4)
                {
                    item.cycleType = CYCLE_TYPE_DAY;
                    item.cycle = 1;
                }
                else
                {
                    item.cycle = [item.frequency.name intValue];
                    item.cycleType = CYCLE_TYPE_DAY;
                }
                
                [medicationList addObject:item];
            }
        }
        
        NSMutableArray *foodDicList = [jsonValues objectForKey:PARAM_KEY_FOOD];
        if(foodDicList)
        {
            for (int i = 0; i < [foodDicList count]; i++)
            {
                NSDictionary *dic = [foodDicList objectAtIndex:i];
                
                Food *item = [Food new];
                
                item.foodId = [[dic objectForKey:PARAM_KEY_FOOD_ID] intValue];
                item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
                item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
                item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
                item.startDate = [dic objectForKey:PARAM_KEY_START_DATE];
                item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
                
                for (int a = 0; a < [appDelegate.fullFoodList count]; a++)
                {
                    Food *food = [appDelegate.fullFoodList objectAtIndex:a];
                    if(item.foodId == food.foodId)
                    {
                        item.name = food.name;
                        break;
                    }
                }
                
                [foodList addObject:item];
            }
        }
        
        NSMutableArray *bathingDicList = [jsonValues objectForKey:PARAM_KEY_BATHING];
        if(bathingDicList)
        {
            for (int i = 0; i < [bathingDicList count]; i++)
            {
                NSDictionary *dic = [bathingDicList objectAtIndex:i];
                
                Bathing *item = [Bathing new];
                
                item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
                item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
                item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
                item.bathingId = [[dic objectForKey:PARAM_KEY_BATHING_ID] intValue];
                item.cycle = [[dic objectForKey:PARAM_KEY_CYCLE] intValue];
                item.isOn = [[dic objectForKey:PARAM_KEY_IS_ON] boolValue];
                item.startedDate = [dic objectForKey:PARAM_KEY_START_DATE];
                item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
                
                if([item.stopDate isKindOfClass:[NSNull class]])
                    item.stopDate = nil;
                else if([item.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                    item.stopDate = nil;
                
                for (int a = 0; a < [appDelegate.fullBathingList count]; a++)
                {
                    Bathing *bathing = [appDelegate.fullBathingList objectAtIndex:a];
                    if(item.bathingId == bathing.bathingId)
                    {
                        item.name = bathing.name;
                        break;
                    }
                }
                
                [bathingList addObject:item];
            }
        }
        
        [mTableView reloadData];
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
    [request addPostValue:[Utils getStringFromNSDate:curDate] forKey:PARAM_KEY_DATE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCnt = 0;
    
    switch (section) {
        case 0:
            if(itchRecord)
                rowCnt = 1;
            else
                rowCnt = 0;
            break;
        case 1:
            rowCnt = [medicationList count];
            break;
        case 2:
            rowCnt = [foodList count];
            break;
        case 3:
            if(flea)
                rowCnt = 1;
            else
                rowCnt = 0;
            break;
        case 4:
            rowCnt = [bathingList count];
            break;
            
        default:
            break;
    }
    
    return rowCnt;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"   %@\'s ITCH SCORE", curDog.name];
            break;
        case 1:
            title = [NSString stringWithFormat:@"   %@\'s THERAPY", curDog.name];
            break;
        case 2:
            title = [NSString stringWithFormat:@"   %@\'s FOOD", curDog.name];
            break;
        case 3:
            title = [NSString stringWithFormat:@"   %@\'s FLEAS", curDog.name];
            break;
        case 4:
            title = [NSString stringWithFormat:@"   %@\'s BATHS", curDog.name];
            break;
        default:
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    UITableViewCell *cell;
    
    switch (section) {
        case 0:
            cell = (ITCHHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ITCHHistoryTableViewCell"];
            
            if(!cell)
            {
                NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"ITCHHistoryTableViewCell" owner:self options:nil];
                for(id currentObject in topObjects)
                {
                    if([currentObject isKindOfClass:[ITCHHistoryTableViewCell class]])
                    {
                        cell = (ITCHHistoryTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            ((ITCHHistoryTableViewCell *)cell).lblValue.text = [NSString stringWithFormat:@"%.1f/10", itchRecord.level];
            break;
        case 1:
        {
            cell = (TherapyHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TherapyHistoryTableViewCell"];
            
            if(!cell)
            {
                NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"TherapyHistoryTableViewCell" owner:self options:nil];
                for(id currentObject in topObjects)
                {
                    if([currentObject isKindOfClass:[TherapyHistoryTableViewCell class]])
                    {
                        cell = (TherapyHistoryTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            TherapyHistoryTableViewCell *tCell = (TherapyHistoryTableViewCell *)cell;
            
            Therapy *therapy = [medicationList objectAtIndex:indexPath.row];
            if(therapy)
            {
                tCell.therapy = therapy;
                [tCell initCell];
            }
            
            break;
        }
            
        case 2:
        {
            cell = (FoodHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FoodHistoryTableViewCell"];
            
            if(!cell)
            {
                NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"FoodHistoryTableViewCell" owner:self options:nil];
                for(id currentObject in topObjects)
                {
                    if([currentObject isKindOfClass:[FoodHistoryTableViewCell class]])
                    {
                        cell = (FoodHistoryTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            FoodHistoryTableViewCell *fCell = (FoodHistoryTableViewCell *)cell;
            
            Food *food = [foodList objectAtIndex:indexPath.row];
            if(food)
            {
                fCell.food = food;
                
                [fCell initCell];
            }
            break;
        }
        case 3:
        {
            cell = (FleaHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FleaHistoryTableViewCell"];
            
            if(!cell)
            {
                NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"FleaHistoryTableViewCell" owner:self options:nil];
                for(id currentObject in topObjects)
                {
                    if([currentObject isKindOfClass:[FleaHistoryTableViewCell class]])
                    {
                        cell = (FleaHistoryTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            FleaHistoryTableViewCell *fCell = (FleaHistoryTableViewCell *)cell;
            fCell.flea = flea;
            [fCell initCell];
            
            break;
        }
        case 4:
        {
            cell = (BathingHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BathingHistoryTableViewCell"];
            
            if(!cell)
            {
                NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"BathingHistoryTableViewCell" owner:self options:nil];
                for(id currentObject in topObjects)
                {
                    if([currentObject isKindOfClass:[BathingHistoryTableViewCell class]])
                    {
                        cell = (BathingHistoryTableViewCell *)currentObject;
                        break;
                    }
                }
            }
            
            BathingHistoryTableViewCell *bCell = (BathingHistoryTableViewCell *)cell;
            bCell.bathing = [bathingList objectAtIndex:indexPath.row];
            [bCell initCell];
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

@end
