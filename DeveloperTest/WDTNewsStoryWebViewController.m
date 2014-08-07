//
//  WDTNewsStoryWebViewController.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTNewsStoryWebViewController.h"

@interface WDTNewsStoryWebViewController () {
    UIWebView *_webView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@end

@implementation WDTNewsStoryWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create web view.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_webView];
    
    // Create activity indicator overlay view, shown while the web page is loading.
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = self.view.bounds;
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _webView.delegate = nil;
    self.url = nil;
    [_webView release];
    [_activityIndicatorView release];
    [super dealloc];
}

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView stopAnimating];
}

@end
