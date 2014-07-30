//
//  LineChartView.h
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView

//Horizontal and vertical axis distance interval
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

//Horizontal and vertical axis shows the labels
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//Point of information
@property (nonatomic, strong) NSArray *array;

@end
