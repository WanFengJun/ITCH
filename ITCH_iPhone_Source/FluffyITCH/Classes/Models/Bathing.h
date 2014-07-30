//
//  Bathing.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bathing : NSObject

@property int                           bathingId;
@property (nonatomic, strong) NSString  *name;
@property int                           cycle;
@property BOOL                          isOn;
@property (nonatomic, strong) NSString  *startedDate;
@property (nonatomic, strong) NSString  *stopDate;
@property int                           usedId;
@property int                           dogId;
@property int                           userId;

@end
