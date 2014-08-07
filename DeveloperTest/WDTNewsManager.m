//
//  WDTNewsManager.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTNewsManager.h"
#import "WDTNewsFetcher.h"
#import "WDTNewsBuilder.h"

@implementation WDTNewsManager

- (void)getNews
{
    [self.newsFetcher fetchNews];
}

#pragma mark - WDTNewsFetcherDelegate

- (void)receivedNewsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *news = [WDTNewsBuilder newsStoriesFromJSON:objectNotation error:&error];
    if (error != nil) {
        [self.delegate fetchingNewsFailedWithError:error];
        
    } else {
        [self.delegate didReceiveNews:news];
    }
}

- (void)fetchingNewsFailedWithError:(NSError *)error
{
    [self.delegate fetchingNewsFailedWithError:error];
}

- (void)dealloc
{
    self.newsFetcher = nil;
    [super dealloc];
}

@end
