//
//  GraphDateItem.h
//  FluffyITCH
//
//  Created by Mimi on 7/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITCHRecord, Flea;

@interface GraphDateItem : NSObject

@property (nonatomic, strong) NSString          *date;
@property (nonatomic, strong) ITCHRecord        *levelRecord;
@property (nonatomic, strong) Flea              *flea;
@property (nonatomic, strong) NSMutableArray    *medicationList;
@property (nonatomic, strong) NSMutableArray    *foodList;
@property (nonatomic, strong) NSMutableArray    *bathingList;

@end
