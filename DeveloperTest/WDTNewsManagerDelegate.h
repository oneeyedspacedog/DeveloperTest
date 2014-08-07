//
//  WDTNewsManagerDelegate.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  Used by news table view.
//

#import <Foundation/Foundation.h>

@protocol WDTNewsManagerDelegate <NSObject>

- (void)didReceiveNews:(NSArray *)news;
- (void)fetchingNewsFailedWithError:(NSError *)error;

@end
