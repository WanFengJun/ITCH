//
//  Dog.h
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GENDER_MALE         1
#define GENDER_FEMALE       0

#define INDOOR              1
#define OUTDOOR             0

@interface Dog : NSObject

@property int                               dogId;
@property (nonatomic, strong) NSString      *name;
@property int                               gender;
@property (nonatomic, strong) NSString      *birth;
@property (nonatomic, strong) NSString      *breed;
@property int                               door;
@property (nonatomic, strong) NSString      *photo;
@property (nonatomic, strong) UIImage       *image;

@end
