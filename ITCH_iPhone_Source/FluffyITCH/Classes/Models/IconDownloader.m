//
//  IconDownloader.m
//  DailyDeal
//
//  Created by Mimi on 2/7/14.
//  Copyright (c) 2014 Mimi. All rights reserved.
//

#import "IconDownloader.h"
#import "Constants.h"
#import "Dog.h"
#import "Community.h"
#import "Comment.h"

#define kAppIconSize 110

@interface IconDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


@implementation IconDownloader

@synthesize data;

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request;
    
    if([data isKindOfClass:[Dog class]])
    {
        Dog *dog = (Dog *)self.data;
        NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, PHOTO_BASE_URL, dog.photo];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else if([data isKindOfClass:[Community class]])
    {
        Community *community = (Community *)self.data;
        NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, PHOTO_BASE_URL, community.dogPhoto];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else if([data isKindOfClass:[Comment class]])
    {
        Comment *comment = (Comment *)self.data;
        NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, COMMENT_PHOTO_BASE_URL, comment.photoUrl];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
    [self.activeDownload appendData:_data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
        
        if([data isKindOfClass:[Dog class]])
        {
            Dog *dog = (Dog *)self.data;
            dog.image = UIGraphicsGetImageFromCurrentImageContext();
        }
        else if([data isKindOfClass:[Community class]])
        {
            Community *community = (Community *)self.data;
            community.imageDog = UIGraphicsGetImageFromCurrentImageContext();
        }
        else if([data isKindOfClass:[Comment class]])
        {
            Comment *comment = (Comment *)self.data;
            comment.image = UIGraphicsGetImageFromCurrentImageContext();
        }
        
		UIGraphicsEndImageContext();
    }
    else
    {
        if([data isKindOfClass:[Dog class]])
        {
            Dog *dog = (Dog *)self.data;
            dog.image = image;
        }
        else if([data isKindOfClass:[Community class]])
        {
            Community *community = (Community *)self.data;
            community.imageDog = image;
        }
        else if([data isKindOfClass:[Comment class]])
        {
            Comment *comment = (Comment *)self.data;
            comment.image = image;
        }
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}
@end
