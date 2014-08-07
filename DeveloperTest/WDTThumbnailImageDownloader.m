//
//  WDTThumbnailImageDownloader.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTThumbnailImageDownloader.h"
#import "WDTNewsStoryData.h"

@interface WDTThumbnailImageDownloader ()

@property (retain, nonatomic) NSMutableData *activeDownload;
@property (retain, nonatomic) NSURLConnection *imageConnection;

@end

#define kAppIconSize 60

@implementation WDTThumbnailImageDownloader

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsStoryData.thumbnailImageHref]];
    NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    self.imageConnection = connection;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)dealloc
{
    [_activeDownload release];
    [_imageConnection release];
    self.newsStoryData = nil;
    self.completionHandler = nil;
    [super dealloc];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
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
    UIImage *image = [[[UIImage alloc] initWithData:self.activeDownload] autorelease];
    
    if (image.size.height != kAppIconSize)
    {
        CGSize itemSize = CGSizeMake((kAppIconSize / image.size.height) * image.size.width, kAppIconSize);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.newsStoryData.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        self.newsStoryData.thumbnailImage = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}

@end
