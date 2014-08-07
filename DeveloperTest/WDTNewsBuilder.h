//
//  WDTNewsBuilder.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  This class serialises the JSON feed and stores some of the data in an array of WDTNewsStoryData objects.
//  The news stories array is sorted in descending order of date.
//

#import <Foundation/Foundation.h>

@interface WDTNewsBuilder : NSObject

+ (NSArray *)newsStoriesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
