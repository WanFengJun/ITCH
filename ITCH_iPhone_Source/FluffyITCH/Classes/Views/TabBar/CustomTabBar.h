//
//  CustomTabBar.h
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"

#define TAB_BAR_HEIGHT          51

@interface CustomTabBar : UIView

@property(nonatomic,strong) UIImageView *tabbarView;

@property(nonatomic,strong) UIButton *button_1;
@property(nonatomic,strong) UIButton *button_2;
@property(nonatomic,strong) UIButton *button_3;
@property(nonatomic,strong) UIButton *button_4;
@property(nonatomic,strong) UIButton *button_5;

@property(nonatomic,weak) id<TabBarDelegate> delegate;

@end
