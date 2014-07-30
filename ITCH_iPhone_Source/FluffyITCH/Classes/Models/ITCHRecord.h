//
//  ITCHRecord.h
//  FluffyITCH
//
//  Created by Mimi on 7/11/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITCHRecord : NSObject

@property int   recordId;
@property int   dogId;
@property float level;
@property (nonatomic, strong) NSString  *date;
@property float latitude;
@property float longitude;
@property int   userId;


@end
