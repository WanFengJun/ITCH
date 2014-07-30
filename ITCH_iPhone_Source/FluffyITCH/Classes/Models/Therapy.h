//
//  Therapy.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MedAmount;
@class MedFrequency;

@interface Therapy : NSObject

@property int                           therapyId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *unit;
@property int                           cycleType; // Hour, Day
@property int                           cycle;
@property BOOL                          isOn;
@property BOOL                          isNew;
@property (nonatomic, strong) NSString  *startedDate;
@property (nonatomic, strong) NSString  *stopDate;
@property int                           checkCount;
@property int                           checkIndex;
@property int                           dogId;
@property int                           userId;
@property int                           amountId;
@property int                           frequencyId;
@property int                           usedId;

@property (nonatomic, strong) MedAmount         *amount;
@property (nonatomic, strong) MedFrequency      *frequency;

@end
