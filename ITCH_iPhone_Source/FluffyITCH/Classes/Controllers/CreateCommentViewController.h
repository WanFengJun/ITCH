//
//  CreateCommentViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Community;

@interface CreateCommentViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextView   *tvMessage;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCaptured;

@property (nonatomic, strong) Community             *community;

- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnTakePhotoClicked:(id)sender;

@end
