//
//  TabBarViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "TabBarViewController.h"
#import "RecordViewController.h"
#import "HistoryViewController.h"
#import "ReportViewController.h"
#import "CommunityViewController.h"
#import "ProfileViewController.h"
#import "CustomTabBar.h"
#import "Constants.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface TabBarViewController ()

@end

@implementation TabBarViewController

@synthesize photoRequest;

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
    
    CGFloat orginHeight = self.view.frame.size.height- TAB_BAR_HEIGHT;
//    if (iPhone5) {
//        orginHeight = self.view.frame.size.height- TAB_BAR_HEIGHT + addHeight;
//    }
    
    _tabbar = [[CustomTabBar alloc]initWithFrame:CGRectMake(0, orginHeight, 320, TAB_BAR_HEIGHT)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    UIViewController *viewController = [_arrayViewcontrollers objectAtIndex:index];;
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TAB_BAR_HEIGHT);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabViewControllers = nil;
    
    RecordViewController *recordVC = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    UINavigationController *navRecord = [[UINavigationController alloc] initWithRootViewController:recordVC];
    [navRecord.navigationBar setHidden:YES];
    
    HistoryViewController *historyVC = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    UINavigationController *navHistory = [[UINavigationController alloc] initWithRootViewController:historyVC];
    [navHistory.navigationBar setHidden:YES];
    
    ReportViewController *reportVC = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
    UINavigationController *navReport = [[UINavigationController alloc] initWithRootViewController:reportVC];
    [navReport.navigationBar setHidden:YES];
    
    CommunityViewController *commVC = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:nil];
    UINavigationController *navComm = [[UINavigationController alloc] initWithRootViewController:commVC];
    [navComm.navigationBar setHidden:YES];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *navProfile = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [navProfile.navigationBar setHidden:YES];
    
    
    tabViewControllers = [NSArray arrayWithObjects:navRecord, navHistory, navReport, navComm, navProfile, nil];
    
    return tabViewControllers;
}

#pragma mark
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:image forKey:@"dog_photo"];
    
    if(photoRequest == PHOTO_REQUEST_FROM_DOG_PROFILE)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAGE_DOG_PHOTO object:nil userInfo:dic];
    else if(photoRequest == PHOTO_REQUEST_FROM_DOG_PROFILE)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_DOG_PHOTO object:nil userInfo:dic];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
