//
//  Community.h
//  FluffyITCH
//
//  Created by Mimi on 7/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Community : NSObject

@property int                           communityId;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *photoUrl;
@property (nonatomic, strong) NSString  *date;
@property int                           dogId;
@property int                           userId;
@property (nonatomic, strong) NSString  *dogPhoto;
@property (nonatomic, strong) NSString  *username;
@property int                           commentCount;
@property (nonatomic, strong) NSString  *serverCurTime;

@property (nonatomic, strong) UIImage   *imageDog;
@property (nonatomic, strong) UIImage   *imageComm;

@end
