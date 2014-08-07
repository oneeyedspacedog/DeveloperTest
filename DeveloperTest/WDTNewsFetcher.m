//
//  WDTNewsFetcher.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTNewsFetcher.h"
#import "WDTNewsFetcherDelegate.h"

@implementation WDTNewsFetcher

- (void)fetchNews
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobilatr.mob.f2.com.au/services/views/9.json"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *operationQueue = [[[NSOperationQueue alloc] init] autorelease];

    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   [self.delegate fetchingNewsFailedWithError:error];
                               } else {
                                   [self.delegate receivedNewsJSON:data];
                               }
                           }];
}

@end
