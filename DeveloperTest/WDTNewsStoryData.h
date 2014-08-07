//
//  WDTNewsStoryData.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  This class stores a subset of the news feed data.
//  date:                Used to sort the news table view.
//  headLine:            Shown in news table view.
//  slugLine:            Shown in news table view.
//  tinyUrl:             Used in news story web view.
//  thumbnailImageHref:  Used in thumbnail image downloader.
//  thumbnailImage:      Fetched by thumbnail image downloader and show in news table view.
//  Note that the variable names exactly match the JSON pair name strings (required by WDTNewsBuilder).
//

#import <Foundation/Foundation.h>

@interface WDTNewsStoryData : NSObject

@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSString *headLine;
@property (retain, nonatomic) NSString *slugLine;
@property (retain, nonatomic) NSString *tinyUrl;
@property (retain, nonatomic) NSString *thumbnailImageHref;
@property (retain, nonatomic) UIImage *thumbnailImage;

@end
