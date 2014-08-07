//
//  WDTThumbnailImageDownloader.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  This class manages the download of the thumbnail image for a news story.
//

#import <Foundation/Foundation.h>

@class WDTNewsStoryData;

@interface WDTThumbnailImageDownloader : NSObject

@property (retain, nonatomic) WDTNewsStoryData *newsStoryData;
@property (copy, nonatomic) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
