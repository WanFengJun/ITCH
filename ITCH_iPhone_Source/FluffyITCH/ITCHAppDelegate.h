//
//  AppDelegate.h
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface ITCHAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet TabBarViewController     *tabBarVC;
@property (strong, nonatomic) IBOutlet UINavigationController   *loginNav;

@property (strong, nonatomic) NSMutableArray                *dogList;
@property (strong, nonatomic) NSMutableArray                *fullTherapyList;
@property (strong, nonatomic) NSMutableArray                *fullFoodList;
@property (strong, nonatomic) NSMutableArray                *fullBathingList;
@property (strong, nonatomic) NSMutableArray                *medAmountList;
@property (strong,nonatomic) NSMutableArray                 *medFrequencyList;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation        *curLocation;

@property (nonatomic, retain) MBProgressHUD                         *loadingView;

+ (void) showWaitView :(NSString *) caption;
+ (void) hideWaitView;

- (void)loadDataList:(int)userId;

@end
