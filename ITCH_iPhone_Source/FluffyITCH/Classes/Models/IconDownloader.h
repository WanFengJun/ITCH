//
//  IconDownloader.h
//  DailyDeal
//
//  Created by Mimi on 2/7/14.
//  Copyright (c) 2014 Mimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconDownloader : NSObject

@property (nonatomic, strong) id      data;

@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
