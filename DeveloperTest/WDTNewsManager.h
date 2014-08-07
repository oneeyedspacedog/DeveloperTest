//
//  WDTNewsManager.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  This class manages the retrival of the news feed, and the serialisation of the news feed results into
//  an array of news story data objects for use by the news table view.
//

#import <Foundation/Foundation.h>
#import "WDTNewsManagerDelegate.h"
#import "WDTNewsFetcherDelegate.h"

@class WDTNewsFetcher;

@interface WDTNewsManager : NSObject <WDTNewsFetcherDelegate>

@property (retain, nonatomic) WDTNewsFetcher *newsFetcher;
@property (assign, nonatomic) id <WDTNewsManagerDelegate> delegate;

- (void)getNews;

@end
