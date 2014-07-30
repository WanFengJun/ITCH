//
//  Flea.h
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flea : NSObject

@property int               fleaId;
@property (nonatomic, strong) NSString  *fleaDesc;
@property BOOL              isSelected;
@property int               dogId;
@property int               userId;
@property int               countValue;
@property (nonatomic, strong)   NSString    *date;

@end
