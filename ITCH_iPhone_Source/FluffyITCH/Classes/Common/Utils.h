//
//  Utils.h
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void) showAlertMessage:(NSString *)message;
+ (NSDate *)getNSDateFromString:(NSString *)strDate;
+ (NSDate *)getNSDateTimeFromString:(NSString *)strDate;
+ (NSDateComponents *)getDiffNSDate:(NSDate *)date toDate:(NSDate *)toDate;
+ (NSString *)getStringFromNSDate:(NSDate *)date;
+ (NSString *)getStringFromNSDateTime:(NSDate *)date;
+ (BOOL) validateEmail: (NSString *) candidate;

@end
