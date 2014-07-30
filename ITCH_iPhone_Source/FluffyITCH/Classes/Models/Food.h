//
//  Food.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property int           foodId;
@property (nonatomic, strong)       NSString *name;
@property int           userId;
@property int           dogId;
@property int           usedId;
@property (nonatomic, strong)       NSString *startDate;
@property (nonatomic, strong)       NSString *stopDate;

@end
