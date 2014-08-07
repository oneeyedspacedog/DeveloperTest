//
//  WDTNewsFetcherDelegate.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  Used by WDTNewsManager.
//

#import <Foundation/Foundation.h>

@protocol WDTNewsFetcherDelegate <NSObject>

- (void)receivedNewsJSON:(NSData *)objectNotation;
- (void)fetchingNewsFailedWithError:(NSError *)error;

@end
