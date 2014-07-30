//
//  TabBarViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PHOTO_REQUEST_FROM_DOG_PROFILE          100
#define PHOTO_REQUEST_FROM_ADD_DOG              101

@class CustomTabBar;

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88

@protocol TabBarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@interface TabBarViewController : UIViewController <TabBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong) CustomTabBar *tabbar;
@property(nonatomic,strong) NSArray *arrayViewcontrollers;

@property int       photoRequest;

@end


