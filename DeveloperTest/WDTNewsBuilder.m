//
//  WDTNewsBuilder.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  Example date strings
//  dateLine = "2014-07-25T11:23:11+10:00";
//  dateLine = "2014-07-25T23:30:00+10:00";

#import "WDTNewsBuilder.h"
#import "WDTNewsStoryData.h"

@implementation WDTNewsBuilder

+ (NSArray *)newsStoriesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *serializationError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&serializationError];
    if (serializationError != nil) {
        if (error != NULL) {
            *error = serializationError;
        }
        return nil;
    }

    // Create an array to hold the news story data objects built from the serialised JSON data.
    NSMutableArray *newsStories = [[[NSMutableArray alloc] init] autorelease];

    // Serialised JSON data.
    NSArray *items = [parsedObject valueForKey:@"items"];

    // Go through all the JSON items and create a news story data object for each item.
    for (NSDictionary *storyDictionary in items) {
        WDTNewsStoryData *storyData = [[[WDTNewsStoryData alloc] init] autorelease];
        for (NSString *key in storyDictionary) {
            if ([key isEqualToString:@"dateLine"]) {
                // Convert the date string to an NSDate object so the news stories can be sorted.
                NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"];
                [storyData setValue:[dateFormatter dateFromString:[storyDictionary valueForKey:key]] forKey:@"date"];
            }
            else if ([storyData respondsToSelector:NSSelectorFromString(key)]) {
                [storyData setValue:[storyDictionary valueForKey:key] forKey:key];
            }
        }
        [newsStories addObject:storyData];
    }

    return ([newsStories sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]]);
}

@end
