//
//  ReportViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ReportViewController.h"
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
#import "PCLineChartView.h"
#import "WeatherData.h"
#import "GraphDateItem.h"
#import "MedAmount.h"
#import "MedFrequency.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

@synthesize graphView, imgTempeCheck, imgRHCheck, imgWindCheck, imgPollenCheck, imgOzoneCheck;
@synthesize curDog;

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
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!appDelegate.dogList || [appDelegate.dogList count] == 0)
        return;
    
    curDog = [appDelegate.dogList objectAtIndex:0];
    
    [self initGraph];
    
    [self loadGraphData];
    
    // Init Date List
    dateList = [NSMutableArray new];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registerDate = [defaults objectForKey:PARAM_KEY_REGISTER_DATE];
    NSDateComponents *diff = [Utils getDiffNSDate:[Utils getNSDateTimeFromString:registerDate] toDate:[NSDate date]];
    NSInteger day = diff.day;
    
    if(day >= 7 * 5)
    {
        NSString *strDate = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:[Utils getStringFromNSDateTime:[NSDate date]]]];
        [dateList addObject:[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        
        for (int i = 4; i > 0; i--)
        {
            strDate = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-i * 7 * 24 * 60 * 60]]]];
            [dateList addObject:[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }
    }
    else
    {
        NSString *strDate = @"";
        
        for (int i = 4; i > 0; i--)
        {
            strDate = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-i * (day / 4) * 24 * 60 * 60]]]];
            [dateList addObject:[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }
        
        strDate = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:[Utils getStringFromNSDateTime:[NSDate date]]]];
//        strDate = [Utils getStringFromNSDate:[Utils getNSDateTimeFromString:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-1*24*60*60]]]]; // for test
        [dateList addObject:[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
    // end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGraph
{
    lineChartView = [[PCLineChartView alloc]initWithFrame:CGRectMake(0, 0, graphView.frame.size.width, graphView.frame.size.height)];
    [lineChartView setBackgroundColor:[UIColor whiteColor]];
    
    lineChartView.minValue = 0;
    lineChartView.maxValue = 10;
    lineChartView.interval = 2;
}

#pragma mark
#pragma mark - Load Data(Record value and Weather data)

- (void)loadGraphData
{
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_GRAPH_DATA_URL];
    
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
        
        NSMutableArray *dicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(!dicList)
        {
            [Utils showAlertMessage:@"No History."];
            return;
        }
        
        graphDateItemList = [NSMutableArray new];
        
        for (int i = 0; i < [dicList count]; i++)
        {
            NSDictionary *dic = [dicList objectAtIndex:i];
            
            GraphDateItem *item = [GraphDateItem new];
            
            item.date = [dic objectForKey:PARAM_KEY_DATE];
            
            NSDictionary *leveDic = [dic objectForKey:PARAM_KEY_ITCH];
            if(leveDic)
            {
                if([leveDic count] > 0)
                {
                    item.levelRecord = [ITCHRecord new];
                    
                    item.levelRecord.recordId = [[leveDic objectForKey:PARAM_KEY_RECORD_ID] intValue];
                    item.levelRecord.dogId = [[leveDic objectForKey:PARAM_KEY_DOG_ID] intValue];
                    item.levelRecord.level = [[leveDic objectForKey:PARAM_KEY_LEVEL] floatValue];
                    item.levelRecord.date = [leveDic objectForKey:PARAM_KEY_DATE];
                    item.levelRecord.latitude = [[leveDic objectForKey:PARAM_KEY_LATITUDE] floatValue];
                    item.levelRecord.longitude = [[leveDic objectForKey:PARAM_KEY_LONGITUDE] floatValue];
                    item.levelRecord.userId = [[leveDic objectForKey:PARAM_KEY_USERID] intValue];
                }
                else
                    item.levelRecord = nil;
            }
            
            NSDictionary *fleaDic = [dic objectForKey:PARAM_KEY_FLEA];
            if(fleaDic)
            {
                if([fleaDic count] > 0)
                {
                    item.flea = [Flea new];
                    
                    item.flea.fleaId = [[fleaDic objectForKey:PARAM_KEY_FLEA_ID] intValue];
                    item.flea.dogId = [[fleaDic objectForKey:PARAM_KEY_DOG_ID] intValue];
                    item.flea.userId = [[fleaDic objectForKey:PARAM_KEY_USERID] intValue];
                    item.flea.countValue = [[fleaDic objectForKey:PARAM_KEY_COUNT_VALUE] intValue];
                    item.flea.date = [fleaDic objectForKey:PARAM_KEY_DATE];
                }
                else
                    item.flea = nil;
            }
            
            NSArray *medDicList = [dic objectForKey:PARAM_KEY_MEDICATION];
            if(medDicList)
            {
                item.medicationList = [NSMutableArray new];
                
                for (int mi = 0; mi < [medDicList count]; mi++)
                {
                    NSDictionary *medDic = [medDicList objectAtIndex:mi];
                    
                    Therapy *tItem = [Therapy new];
                    
                    tItem.therapyId = [[medDic objectForKey:PARAM_KEY_MEDID] intValue];
                    tItem.userId = [[medDic objectForKey:PARAM_KEY_USERID] intValue];
                    tItem.dogId = [[medDic objectForKey:PARAM_KEY_DOG_ID] intValue];
                    tItem.checkCount = [[medDic objectForKey:PARAM_KEY_CHECK_COUNT] intValue];
                    tItem.checkIndex = [[medDic objectForKey:PARAM_KEY_CHECK_INDEX] intValue];
                    tItem.frequencyId = [[medDic objectForKey:PARAM_KEY_FREQUENCY_ID] intValue];
                    tItem.amountId = [[medDic objectForKey:PARAM_KEY_UNIT_ID] intValue];
                    tItem.isOn = [[medDic objectForKey:PARAM_KEY_IS_ON] boolValue];
                    tItem.startedDate = [medDic objectForKey:PARAM_KEY_START_DATE];
                    tItem.stopDate = [medDic objectForKey:PARAM_KEY_STOP_DATE];
                    tItem.usedId = [[medDic objectForKey:PARAM_KEY_ID] intValue];
                    
                    if([tItem.stopDate isKindOfClass:[NSNull class]])
                        tItem.stopDate = nil;
                    else if([tItem.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                        tItem.stopDate = nil;
                    
                    for (int a = 0; a < [appDelegate.fullTherapyList count]; a++)
                    {
                        Therapy *therapy = [appDelegate.fullTherapyList objectAtIndex:a];
                        if(therapy.therapyId == tItem.therapyId)
                        {
                            tItem.name = therapy.name;
                            break;
                        }
                    }
                    
                    for (int ci = 0; ci < [appDelegate.medFrequencyList count]; ci++)
                    {
                        MedFrequency *freq = [appDelegate.medFrequencyList objectAtIndex:ci];
                        if(freq.frequencyId == tItem.frequencyId)
                        {
                            tItem.frequency = freq;
                            break;
                        }
                    }
                    
                    for (int ai = 0; ai < [appDelegate.medAmountList count]; ai++)
                    {
                        MedAmount *amount = [appDelegate.medAmountList objectAtIndex:ai];
                        if(amount.amountId == tItem.amountId)
                        {
                            tItem.amount = amount;
                            tItem.unit = amount.name;
                            break;
                        }
                    }
                    
                    if(tItem.frequencyId == 1 || tItem.frequencyId == 2 || tItem.frequencyId == 3)
                    {
                        tItem.cycle = [tItem.frequency.name intValue];
                        tItem.cycleType = CYCLE_TYPE_HOUR;
                    }
                    else if(tItem.frequencyId == 4)
                    {
                        tItem.cycleType = CYCLE_TYPE_DAY;
                        tItem.cycle = 1;
                    }
                    else
                    {
                        tItem.cycle = [tItem.frequency.name intValue];
                        tItem.cycleType = CYCLE_TYPE_DAY;
                    }
                    
                    [item.medicationList addObject:tItem];
                }
            }
            
            NSArray *foodDicList = [dic objectForKey:PARAM_KEY_FOOD];
            if(foodDicList)
            {
                item.foodList = [NSMutableArray new];
                
                for (int fi = 0; fi < [foodDicList count]; fi++)
                {
                    NSDictionary *medDic = [foodDicList objectAtIndex:fi];
                    
                    Food *fItem = [Food new];
                    
                    fItem.foodId = [[medDic objectForKey:PARAM_KEY_FOOD_ID] intValue];
                    fItem.userId = [[medDic objectForKey:PARAM_KEY_USERID] intValue];
                    fItem.usedId = [[medDic objectForKey:PARAM_KEY_ID] intValue];
                    fItem.dogId = [[medDic objectForKey:PARAM_KEY_DOG_ID] intValue];
                    fItem.startDate = [medDic objectForKey:PARAM_KEY_START_DATE];
                    fItem.stopDate = [medDic objectForKey:PARAM_KEY_STOP_DATE];
                    
                    for (int a = 0; a < [appDelegate.fullFoodList count]; a++)
                    {
                        Food *food = [appDelegate.fullFoodList objectAtIndex:a];
                        if(fItem.foodId == food.foodId)
                        {
                            fItem.name = food.name;
                            break;
                        }
                    }
                    
                    [item.foodList addObject:fItem];
                }
            }
            
            NSArray *bathingDicList = [dic objectForKey:PARAM_KEY_BATHING];
            if(bathingDicList)
            {
                item.bathingList = [NSMutableArray new];
                
                for (int bi = 0; bi < [bathingDicList count]; bi++)
                {
                    NSDictionary *bathingDic = [bathingDicList objectAtIndex:bi];
                    
                    Bathing *bItem = [Bathing new];
                    
                    bItem.usedId = [[bathingDic objectForKey:PARAM_KEY_ID] intValue];
                    bItem.userId = [[bathingDic objectForKey:PARAM_KEY_USERID] intValue];
                    bItem.dogId = [[bathingDic objectForKey:PARAM_KEY_DOG_ID] intValue];
                    bItem.bathingId = [[bathingDic objectForKey:PARAM_KEY_BATHING_ID] intValue];
                    bItem.cycle = [[bathingDic objectForKey:PARAM_KEY_CYCLE] intValue];
                    bItem.isOn = [[bathingDic objectForKey:PARAM_KEY_IS_ON] boolValue];
                    bItem.startedDate = [bathingDic objectForKey:PARAM_KEY_START_DATE];
                    bItem.stopDate = [bathingDic objectForKey:PARAM_KEY_STOP_DATE];
                    
                    if([bItem.stopDate isKindOfClass:[NSNull class]])
                        bItem.stopDate = nil;
                    else if([bItem.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                        bItem.stopDate = nil;
                    
                    for (int a = 0; a < [appDelegate.fullBathingList count]; a++)
                    {
                        Bathing *bathing = [appDelegate.fullBathingList objectAtIndex:a];
                        if(bItem.bathingId == bathing.bathingId)
                        {
                            bItem.name = bathing.name;
                            break;
                        }
                    }
                    
                    [item.bathingList addObject:bItem];
                }
            }
            
            [graphDateItemList addObject:item];
        }
        
        // Draw Graph
        graphComponents = [NSMutableArray array];
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setTitle:@"ITCH Record"];
        
        NSMutableArray *points = [NSMutableArray new];
        xLabels = [NSMutableArray new];
        
        for (int i = 0; i < [graphDateItemList count]; i++)
        {
            GraphDateItem *item = [graphDateItemList objectAtIndex:i];
            
            // make date value string
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:item.date];

            if(!dateFromString)
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                dateFromString = [dateFormatter dateFromString:item.date];
            }
            
            [dateFormatter setDateFormat:@"MMM-dd"];
            NSString *dateStr = [dateFormatter stringFromDate:dateFromString];
            
            [xLabels addObject:dateStr];
            //
            
            if(item.levelRecord)
                [points addObject:[NSNumber numberWithFloat:item.levelRecord.level]];
            else
                [points addObject:[NSNumber numberWithInt:0]];
        }
        
        [component setPoints:points];
        [graphComponents addObject:component];
        [lineChartView setComponents:graphComponents];
        [lineChartView setXLabels:xLabels];
        
        [graphView addSubview:lineChartView];
        //
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
    
    // calculate date
    NSString *registerDate = [defaults objectForKey:PARAM_KEY_REGISTER_DATE];
    NSDateComponents *diff = [Utils getDiffNSDate:[Utils getNSDateTimeFromString:registerDate] toDate:[NSDate date]];
    int day = diff.day;

    if(day >= 7 * 5)
    {
        [request addPostValue:[Utils getStringFromNSDateTime:[NSDate date]] forKey:PARAM_KEY_DATE5];
        
        for (int i = 4; i > 0; i--)
        {
            [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-i * 7 * 24 * 60 * 60]] forKey:[NSString stringWithFormat:@"date%d", i]];
        }
    }
    else
    {
//        [request addPostValue:[Utils getStringFromNSDateTime:[NSDate date]] forKey:PARAM_KEY_DATE5];
        [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-2*24*60*60]] forKey:PARAM_KEY_DATE5]; // for test
        [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-1 * (day / 4) * 24 * 60 * 60]] forKey:PARAM_KEY_DATE4];
        [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-2 * (day / 4) * 24 * 60 * 60]] forKey:PARAM_KEY_DATE3];
        [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-3 * (day / 4) * 24 * 60 * 60]] forKey:PARAM_KEY_DATE2];
        [request addPostValue:[Utils getStringFromNSDateTime:[[NSDate date] dateByAddingTimeInterval:-4 * (day / 4) * 24 * 60 * 60]] forKey:PARAM_KEY_DATE1];
    }
    // end
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (void)loadWeatherData
{
    if(!dateList)
        return;
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *curLocation = appDelegate.curLocation;
    
    weatherList = [NSMutableArray new];
    
//    [ITCHAppDelegate showWaitView:@"Loading..."];
    
    for (int i = 0; i < [dateList count]; i++)
    {
//        http://api.wunderground.com/api/29177338b96ec02f/history_20140713/q/39.1167,122.3833.json
        
        NSString *strDate = [dateList objectAtIndex:i];
        
        NSString *url = [NSString stringWithFormat:@"%@/api/%@/history_%@/q/%.5f,%.5f.json", WEATHER_SERVER_URL, WEATHER_API_KEY, strDate, curLocation.coordinate.latitude, curLocation.coordinate.longitude];
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if(error)
        {
            [ITCHAppDelegate hideWaitView];
            [Utils showAlertMessage:[error domain]];
            return;
        }
        
        NSDictionary* jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:kNilOptions
                                 error:nil];
        if(!jsonDic)
        {
            [ITCHAppDelegate hideWaitView];
            [Utils showAlertMessage:@"Error : Parse json data from weather server."];
            return;
        }
        
        NSDictionary *historyDic = [jsonDic objectForKey:@"history"];
        if(!historyDic)
        {
            [ITCHAppDelegate hideWaitView];
            [Utils showAlertMessage:@"No History : Parse json data from weather server."];
            return;
        }
        
        NSMutableArray *dailyDicList = [historyDic objectForKey:@"dailysummary"];
        if(!dailyDicList)
        {
            [ITCHAppDelegate hideWaitView];
            [Utils showAlertMessage:@"No Daily : Parse json data from weather server."];
            return;
        }
        
        if([dailyDicList count] == 0)
        {
            [ITCHAppDelegate hideWaitView];
            [Utils showAlertMessage:@"History Empty : Parse json data from weather server."];
            return;
        }
        
        NSDictionary *dailyDic = [dailyDicList objectAtIndex:0];
        
        if(dailyDic)
        {
            int temperature = [[dailyDic objectForKey:@"meantempm"] intValue];
            int humidity = [[dailyDic objectForKey:@"humidity"] intValue];
            int windSpeed = [[dailyDic objectForKey:@"meanwindspdi"] intValue];
            
            WeatherData *item = [WeatherData new];
            item.temperature = temperature;
            item.humidity = humidity;
            item.windSpeed = windSpeed;
            
            [weatherList addObject:item];
        }
    }
    
//    [ITCHAppDelegate hideWaitView];
}

#pragma mark
#pragma mark UIButton Click Handler
- (IBAction)btnCompareClicked:(id)sender
{
    
}

- (IBAction)btnTemperCheckClicked:(id)sender
{
    UIImage *curImage = [imgTempeCheck image];
    
    if([curImage isEqual:[UIImage imageNamed:@"flea_check.png"]])
    {
        [imgTempeCheck setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        
        for (int i = 0; i < [graphComponents count]; i++)
        {
            PCLineChartViewComponent *component = [graphComponents objectAtIndex:i];
            if([component.title isEqualToString:@"T"])
            {
                [graphComponents removeObjectAtIndex:i];
                break;
            }
        }
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
    else
    {
        if(!weatherList)
        {
            [ITCHAppDelegate showWaitView:@"Loading..."];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                [self loadWeatherData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    
                    [imgTempeCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
                    
                    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
                    [component setTitle:@"T"];
                    
                    NSMutableArray *points = [NSMutableArray new];
                    
                    for (int i = 0; i < [weatherList count]; i++)
                    {
                        WeatherData *item = [weatherList objectAtIndex:i];
                        
                        [points addObject:[NSNumber numberWithFloat:((float)item.temperature) / 4]];
                    }
                    
                    [component setPoints:points];
                    [component setColour:PCColorRed];
                    
                    [graphComponents addObject:component];
                    
                    [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];

                    [ITCHAppDelegate hideWaitView];
                });
            });
            
            return;
        }
        
        [imgTempeCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
        
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setTitle:@"T"];
        
        NSMutableArray *points = [NSMutableArray new];
        
        for (int i = 0; i < [weatherList count]; i++)
        {
            WeatherData *item = [weatherList objectAtIndex:i];
            
            [points addObject:[NSNumber numberWithFloat:((float)item.temperature) / 4]];
        }
        
        [component setPoints:points];
        [component setColour:PCColorRed];
        
        [graphComponents addObject:component];
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
}

- (IBAction)btnRHCheckClicked:(id)sender
{
    UIImage *curImage = [imgRHCheck image];
    
    if([curImage isEqual:[UIImage imageNamed:@"flea_check.png"]])
    {
        [imgRHCheck setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        
        for (int i = 0; i < [graphComponents count]; i++)
        {
            PCLineChartViewComponent *component = [graphComponents objectAtIndex:i];
            if([component.title isEqualToString:@"RH"])
            {
                [graphComponents removeObjectAtIndex:i];
                break;
            }
        }
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
    else
    {
        if(!weatherList)
        {
            [ITCHAppDelegate showWaitView:@"Loading..."];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                [self loadWeatherData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    
                    [imgRHCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
                    
                    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
                    [component setTitle:@"RH"];
                    
                    NSMutableArray *points = [NSMutableArray new];
                    
                    for (int i = 0; i < [weatherList count]; i++)
                    {
                        WeatherData *item = [weatherList objectAtIndex:i];
                        
                        [points addObject:[NSNumber numberWithFloat:((float)item.humidity) / 10]];
                    }
                    
                    [component setPoints:points];
                    [component setColour:PCColorGreen];
                    
                    [graphComponents addObject:component];
                    
                    [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
                    
                    [ITCHAppDelegate hideWaitView];
                });
            });
            
            return;
        }
        
        [imgRHCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
        
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setTitle:@"RH"];
        
        NSMutableArray *points = [NSMutableArray new];
        
        for (int i = 0; i < [weatherList count]; i++)
        {
            WeatherData *item = [weatherList objectAtIndex:i];
            
            [points addObject:[NSNumber numberWithFloat:((float)item.humidity) / 10]];
        }
        
        [component setPoints:points];
        [component setColour:PCColorGreen];
        
        [graphComponents addObject:component];
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
}

- (IBAction)btnWindCheckClicked:(id)sender
{
    UIImage *curImage = [imgWindCheck image];
    
    if([curImage isEqual:[UIImage imageNamed:@"flea_check.png"]])
    {
        [imgWindCheck setImage:[UIImage imageNamed:@"due_uncheck.png"]];
        
        for (int i = 0; i < [graphComponents count]; i++)
        {
            PCLineChartViewComponent *component = [graphComponents objectAtIndex:i];
            if([component.title isEqualToString:@"WIND"])
            {
                [graphComponents removeObjectAtIndex:i];
                break;
            }
        }
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
    else
    {
        if(!weatherList)
        {
            [ITCHAppDelegate showWaitView:@"Loading..."];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                [self loadWeatherData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    
                    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
                    [component setTitle:@"WIND"];
                    
                    NSMutableArray *points = [NSMutableArray new];
                    
                    for (int i = 0; i < [weatherList count]; i++)
                    {
                        WeatherData *item = [weatherList objectAtIndex:i];
                        
                        [points addObject:[NSNumber numberWithFloat:((float)item.windSpeed) / 2]];
                    }
                    
                    [component setPoints:points];
                    [component setColour:PCColorYellow];
                    
                    [graphComponents addObject:component];
                    
                    [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
                });
            });
            
            return;
        }
        
        [imgWindCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
        
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setTitle:@"WIND"];
        
        NSMutableArray *points = [NSMutableArray new];
        
        for (int i = 0; i < [weatherList count]; i++)
        {
            WeatherData *item = [weatherList objectAtIndex:i];
            
            [points addObject:[NSNumber numberWithFloat:((float)item.windSpeed) / 2]];
        }
        
        [component setPoints:points];
        [component setColour:PCColorYellow];
        
        [graphComponents addObject:component];
        
        [lineChartView setNeedsDisplayInRect:CGRectMake(lineChartView.frame.origin.x, lineChartView.frame.origin.y, lineChartView.frame.size.width, lineChartView.frame.size.height)];
    }
}

- (IBAction)btnPollenCheckClicked:(id)sender
{
    UIImage *curImage = [imgPollenCheck image];
    
    if([curImage isEqual:[UIImage imageNamed:@"flea_check.png"]])
    {
        [imgPollenCheck setImage:[UIImage imageNamed:@"due_uncheck.png"]];
    }
    else
    {
        [imgPollenCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
    }
}

- (IBAction)btnOzoneCheckClicked:(id)sender
{
    UIImage *curImage = [imgOzoneCheck image];
    
    if([curImage isEqual:[UIImage imageNamed:@"flea_check.png"]])
    {
        [imgOzoneCheck setImage:[UIImage imageNamed:@"due_uncheck.png"]];
    }
    else
    {
        [imgOzoneCheck setImage:[UIImage imageNamed:@"flea_check.png"]];
    }
}

@end
