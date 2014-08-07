//
//  WDTNewsStoryData.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTNewsStoryData.h"

@implementation WDTNewsStoryData

- (NSString *)description
{
    return [NSString stringWithFormat:@"< '%@', '%@', '%@', '%@', '%@' >",
            _date, _headLine, _slugLine, _tinyUrl, _thumbnailImageHref];
}

- (void)dealloc
{
    [_date release];
    [_headLine release];
    [_slugLine release];
    [_tinyUrl release];
    [_thumbnailImageHref release];
    [_thumbnailImage release];
    [super dealloc];
}

@end
