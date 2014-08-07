//
//  WDTNewsStoryWebViewController.h
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//
//  Web view to show a news story.
//

#import <UIKit/UIKit.h>

@interface WDTNewsStoryWebViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) NSURL *url;

@end
