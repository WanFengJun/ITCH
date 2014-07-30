//
//  Comment.h
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOWNLOAD_IMAGE_TYPE_DOG_PHOTO           0
#define DOWNLOAD_IMAGE_TYPE_COMMENT_PHOTO       1

@interface Comment : NSObject

@property int                               commentId;
@property int                               communityId;
@property (nonatomic, strong) NSString      *message;
@property (nonatomic, strong) NSString      *photoUrl;
@property (nonatomic, strong) NSString      *date;
@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *dogPhoto;

@property (nonatomic, strong) UIImage       *image;

@end
