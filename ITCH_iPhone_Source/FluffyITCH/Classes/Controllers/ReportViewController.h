//
//  ReportViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCLineChartView, Dog;

@interface ReportViewController : UIViewController {
    PCLineChartView *lineChartView;
    NSMutableArray *graphComponents;
    NSMutableArray *xLabels;
    
    NSMutableArray  *dateList;
    NSMutableArray  *weatherList;
    NSMutableArray  *graphDateItemList;
}

@property (nonatomic, strong) IBOutlet UIView       *graphView;
@property (nonatomic, strong) IBOutlet UIImageView  *imgTempeCheck;
@property (nonatomic, strong) IBOutlet UIImageView  *imgRHCheck;
@property (nonatomic, strong) IBOutlet UIImageView  *imgWindCheck;
@property (nonatomic, strong) IBOutlet UIImageView  *imgPollenCheck;
@property (nonatomic, strong) IBOutlet UIImageView  *imgOzoneCheck;

@property (nonatomic, strong) Dog                   *curDog;

- (IBAction)btnCompareClicked:(id)sender;
- (IBAction)btnTemperCheckClicked:(id)sender;
- (IBAction)btnRHCheckClicked:(id)sender;
- (IBAction)btnWindCheckClicked:(id)sender;
- (IBAction)btnPollenCheckClicked:(id)sender;
- (IBAction)btnOzoneCheckClicked:(id)sender;

@end
