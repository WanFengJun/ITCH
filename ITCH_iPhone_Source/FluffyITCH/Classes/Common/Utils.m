//
//  Utils.m
//  FluffyITCH
//
//  Created by Mimi on 7/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) showAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (NSDate *)getNSDateFromString:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];    //2014-01-25 10:00:57
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:strDate];
    
    return dateFromString;
}

+ (NSDate *)getNSDateTimeFromString:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];    //2014-01-25 10:00:57
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:strDate];
    
    return dateFromString;
}

+ (NSDateComponents *)getDiffNSDate:(NSDate *)date toDate:(NSDate *)toDate
{
    NSDateComponents *components;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                             fromDate:date
                               toDate:toDate
                              options:0];
    
    return components;
}

+ (NSString *)getStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];    //2014-01-25 10:00:57
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)getStringFromNSDateTime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];    //2014-01-25 10:00:57
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
