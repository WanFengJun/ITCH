//
//  CreateCommunityViewController.h
//  FluffyITCH
//
//  Created by Mimi on 7/15/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCommunityViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField  *tvTitle;
@property (nonatomic, strong) IBOutlet UITextView   *tvMessage;
@property (nonatomic, strong) IBOutlet UIImageView  *imgCaptured;

- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnTakePhotoClicked:(id)sender;

@end
