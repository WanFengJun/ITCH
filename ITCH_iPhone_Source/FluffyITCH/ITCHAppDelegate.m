//
//  AppDelegate.m
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ITCHAppDelegate.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utils.h"
#import "JSON.h"
#import "Therapy.h"
#import "Food.h"
#import "Dog.h"
#import "Bathing.h"
#import "MedAmount.h"
#import "MedFrequency.h"

#ifdef DEBUG_MODE
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

@implementation ITCHAppDelegate

@synthesize window, tabBarVC, loginNav;
@synthesize locationManager, curLocation;
@synthesize dogList, fullTherapyList, fullFoodList, fullBathingList, medAmountList, medFrequencyList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    
    //The desired accuracy that you want, not guaranteed though
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    //The distance in meters a device must move before an update event is triggered
    locationManager.distanceFilter=500;
    
    self.locationManager=locationManager;
    
    if([CLLocationManager locationServicesEnabled])
        [self.locationManager startUpdatingLocation];
    
    //
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:KEY_USERNAME];
    int userId = [prefs integerForKey:PARAM_KEY_USERID];
    
    if(username == nil || username.length == 0)
    {
        self.window.rootViewController = loginNav;
    }
    else
    {
        [self loadDataList:userId];
//        self.window.rootViewController = tabBarVC;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.curLocation = newLocation;
    
    DLog(@"latitude %+.6f, longitude %+.6f\n",
         newLocation.coordinate.latitude,
         newLocation.coordinate.longitude);
    DLog(@"Horizontal Accuracy:%f", newLocation.horizontalAccuracy);
}

#pragma mark - HUD Methods

+ (void) showWaitView :(NSString *) caption
{
	ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.loadingView = [[MBProgressHUD alloc] initWithView:appDelegate.window];
    [appDelegate.window addSubview:appDelegate.loadingView];
    appDelegate.loadingView.labelText = caption;
    [appDelegate.loadingView show:YES];
    
    [appDelegate.window setUserInteractionEnabled:NO];
    
  	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void) hideWaitView
{
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.loadingView != nil) {
        [appDelegate.loadingView hide:YES];
        [appDelegate.loadingView removeFromSuperview];
        appDelegate.loadingView = nil;
        
        [appDelegate.window setUserInteractionEnabled:YES];
    }
  	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark
#pragma mark - Load Data List from Server   : Dog, Medication, Food, Bathing
- (void)loadDataList:(int)userId
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_DATA_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:300];
    
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
        
        // Get Medication List
        NSArray *medDicList = [jsonValues objectForKey:PARAM_KEY_MEDICATION];
        if(!medDicList)
            return;
        
        self.fullTherapyList = [NSMutableArray new];
        
        for (int i = 0; i < [medDicList count]; i++)
        {
            NSDictionary *medDic = [medDicList objectAtIndex:i];
            
            int medId = [[medDic objectForKey:PARAM_KEY_MEDID] intValue];
            NSString *medName = [medDic objectForKey:PARAM_KEY_MED_NAME];
            NSString *medUnit = [medDic objectForKey:PARAM_KEY_MED_UNIT];
            int cycleType = [[medDic objectForKey:PARAM_KEY_MED_CYCLE_TYPE] intValue];
            int cycleValue = [[medDic objectForKey:PARAM_KEY_MED_CYCLE_VALUE] intValue];
            int isOn = [[medDic objectForKey:PARAM_KEY_IS_ON] intValue];
            
            Therapy *item = [Therapy new];
            
            item.therapyId = medId;
            item.name = medName;
            item.unit = medUnit;
            item.cycleType = cycleType;
            item.cycle = cycleValue;
            item.isOn = isOn == 1 ? YES : NO;
            
            [self.fullTherapyList addObject:item];
        }
        
        // Get Dog List
        NSArray *dogDicList = [jsonValues objectForKey:PARAM_KEY_DOG];
        if(!dogDicList)
            return;
        
        self.dogList = [NSMutableArray new];
        
        for(int i = 0; i < [dogDicList count]; i++)
        {
            NSDictionary *dogDic = [dogDicList objectAtIndex:i];
            
            int dogId = [[dogDic objectForKey:PARAM_KEY_DOG_ID] intValue];
            NSString *dogName = [dogDic objectForKey:PARAM_KEY_DOG_NAME];
            NSString *dogBirth = [dogDic objectForKey:PARAM_KEY_DOG_BIRTH];
            NSString *dogBreed = [dogDic objectForKey:PARAM_KEY_DOG_BREED];
            int dogGender = [[dogDic objectForKey:PARAM_KEY_DOG_GENDER] intValue];
            int dogDoor = [[dogDic objectForKey:PARAM_KEY_DOG_DOOR] intValue];
            NSString *photo = [dogDic objectForKey:PARAM_KEY_DOG_PHOTO];
            
            Dog *item = [Dog new];
            item.dogId = dogId;
            item.name = dogName;
            item.birth = dogBirth;
            item.breed = dogBreed;
            item.gender = dogGender;
            item.door = dogDoor;
            item.photo = photo;
            
            [self.dogList addObject:item];
        }
        
        // Get Food List
        NSArray *foodDicList = [jsonValues objectForKey:PARAM_KEY_FOOD];
        if(!foodDicList)
            return;
        
        self.fullFoodList = [NSMutableArray new];
        
        for (int i = 0; i < [foodDicList count]; i++)
        {
            NSDictionary *foodDic = [foodDicList objectAtIndex:i];
            
            int foodId = [[foodDic objectForKey:PARAM_KEY_FOOD_ID] intValue];
            NSString *foodName = [foodDic objectForKey:PARAM_KEY_FOOD_NAME];
            
            Food *food = [Food new];
            food.foodId = foodId;
            food.name = foodName;
            
            [self.fullFoodList addObject:food];
        }
        
        // Get Bathing List
        NSArray *bathingDicList = [jsonValues objectForKey:PARAM_KEY_BATHING];
        if(!bathingDicList)
            return;
        
        self.fullBathingList = [NSMutableArray new];
        for (int i = 0; i < [bathingDicList count]; i++)
        {
            NSDictionary *bathingDic = [bathingDicList objectAtIndex:i];
            
            Bathing *item = [Bathing new];
            
            item.bathingId = [[bathingDic objectForKey:PARAM_KEY_BATHING_ID] intValue];
            item.name = [bathingDic objectForKey:PARAM_KEY_BATHING_NAME];
            
            [self.fullBathingList addObject:item];
        }
        
        // Get Medication Amount List
        NSArray *amountDicList = [jsonValues objectForKey:PARAM_KEY_UNIT];
        if(!amountDicList)
            return;
        
        self.medAmountList = [NSMutableArray new];
        
        for (int i = 0; i < [amountDicList count]; i++)
        {
            NSDictionary *dic = [amountDicList objectAtIndex:i];
            
            MedAmount *item = [MedAmount new];
            
            item.amountId = [[dic objectForKey:PARAM_KEY_ID] intValue];
            item.name = [dic objectForKey:PARAM_KEY_UNIT];
            
            [self.medAmountList addObject:item];
        }
        
        // Get Medication Frequency List
        NSArray *frequencyDicList = [jsonValues objectForKey:PARAM_KEY_FREQUENCY];
        if(!frequencyDicList)
            return;
        
        self.medFrequencyList = [NSMutableArray new];
        for (int i = 0; i < [frequencyDicList count]; i++)
        {
            NSDictionary *dic = [frequencyDicList objectAtIndex:i];
            
            MedFrequency *item = [MedFrequency new];
            
            item.frequencyId = [[dic objectForKey:PARAM_KEY_ID] intValue];
            item.name = [dic objectForKey:PARAM_KEY_FREQUENCY];
            
            [self.medFrequencyList addObject:item];
        }
        /////
        
        self.window.rootViewController = tabBarVC;
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

@end
