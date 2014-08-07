//
//  WDTNewsFetcher.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  This class fetches the news feed.  The result (data or error) is passed to WDTNewsFetcherDelegate,
//  which is implemented by WDTNewsManager.
//

#import <Foundation/Foundation.h>

@protocol WDTNewsFetcherDelegate;

@interface WDTNewsFetcher : NSObject

@property (assign, nonatomic) id <WDTNewsFetcherDelegate> delegate;

- (void)fetchNews;

@end
