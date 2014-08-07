//
//  WDTNewsTableViewController.m
// DeveloperTest
//
//  Created by Jamie Cooper on 27/07/2014.
//  Copyright (c) 2014 Jamie Cooper. All rights reserved.
//

#import "WDTNewsTableViewController.h"
#import "WDTNewsStoryWebViewController.h"
#import "WDTNewsStoryData.h"
#import "WDTNewsManager.h"
#import "WDTNewsFetcher.h"
#import "WDTThumbnailImageDownloader.h"

#define kArtificialRefreshTimeInterval 0.5

@interface WDTNewsTableViewController () <WDTNewsManagerDelegate, UIScrollViewDelegate>
{
    WDTNewsManager *_newsManager;
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (retain, nonatomic) NSMutableDictionary *imageDownloadsInProgress;
@property (retain, nonatomic) NSArray *newsStories;

@end


@implementation WDTNewsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.newsStories = [NSArray array];

    self.title = @"News";
    self.tableView.rowHeight = 85;
    UIBarButtonItem *refreshBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(refreshTableView)] autorelease];
    [self.navigationItem setLeftBarButtonItem:refreshBarButtonItem];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectMake(0, 0, 20, 0);
    [_activityIndicatorView startAnimating];
    UIBarButtonItem *spinnerBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView] autorelease];
    [self.navigationItem setRightBarButtonItem:spinnerBarButtonItem];

    _newsManager = [[WDTNewsManager alloc] init];
    _newsManager.newsFetcher = [[WDTNewsFetcher alloc] init];
    _newsManager.newsFetcher.delegate = _newsManager;
    _newsManager.delegate = self;
    [_newsManager getNews];

    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self cancelThumbnailDownloads];
}

- (void)dealloc
{
    self.newsStories = nil;
    _newsManager.newsFetcher.delegate = nil;
    _newsManager.delegate = nil;
    [_newsManager release];
    [_activityIndicatorView release];
    [self cancelThumbnailDownloads];
    self.imageDownloadsInProgress = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsStories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    if ([[self.newsStories objectAtIndex:0] isKindOfClass:[NSString class]]) {
        // If there was an error fetching the news feed show an error message.
        cell.detailTextLabel.text = [self.newsStories objectAtIndex:0];
    }
    else {
        WDTNewsStoryData *newsStoryData = [self.newsStories objectAtIndex:indexPath.row];
        cell.textLabel.text = newsStoryData.headLine;
        cell.detailTextLabel.text = newsStoryData.slugLine;
        if (!newsStoryData.thumbnailImage) {
            // If this news story does not have an image, the thumbnailImageHref value will be NSNull.
            if (((NSObject *)newsStoryData.thumbnailImageHref != [NSNull null]) &&
                (self.tableView.dragging == NO && self.tableView.decelerating == NO))
            {
                [self startIconDownload:newsStoryData forIndexPath:indexPath];
            }
            // If a download is deferred or in progress, do not show an image.
            cell.imageView.image = nil;
        }
        else {
            cell.imageView.image = newsStoryData.thumbnailImage;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.newsStories objectAtIndex:0] isKindOfClass:[NSString class]]) return;
    WDTNewsStoryWebViewController *webViewController = [[[WDTNewsStoryWebViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    webViewController.title = [[self.newsStories objectAtIndex:indexPath.row] headLine];
    webViewController.url = [NSURL URLWithString:[[self.newsStories objectAtIndex:indexPath.row] tinyUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - News Manager Delegate

- (void)didReceiveNews:(NSArray *)news
{
    self.newsStories = news;

    [self performSelectorOnMainThread:@selector(enableRefreshButton) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(stopActivityViewAnimation) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(reloadTableViewDataOnMainThread) withObject:nil waitUntilDone:NO];
}

- (void)fetchingNewsFailedWithError:(NSError *)error
{
    NSLog(@"%s error:%@", __PRETTY_FUNCTION__, error);

    self.newsStories = [NSArray arrayWithObject:[NSString stringWithFormat:@"Could not fetch the news, check you are connected to the internet."]];

    [self performSelectorOnMainThread:@selector(enableRefreshButton) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(stopActivityViewAnimation) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(reloadTableViewDataOnMainThread) withObject:nil waitUntilDone:NO];
}

- (void)reloadTableViewDataOnMainThread
{
    [self.tableView reloadData];
}

- (void)stopActivityViewAnimation
{
    [_activityIndicatorView stopAnimating];
}

- (void)enableRefreshButton
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark - Refresh the table view

- (void)refreshTableView
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [_activityIndicatorView startAnimating];

    [self cancelThumbnailDownloads];
    self.newsStories = [NSArray array];
    [self.tableView reloadData];
    [self performSelector:@selector(refreshNews) withObject:nil afterDelay:kArtificialRefreshTimeInterval];
}

- (void)refreshNews
{
    [_newsManager getNews];
}

#pragma mark - Table cell image support

- (void)cancelThumbnailDownloads
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)startIconDownload:(WDTNewsStoryData *)newsStoryData forIndexPath:(NSIndexPath *)indexPath
{
    WDTThumbnailImageDownloader *thumbnailDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (thumbnailDownloader == nil)
    {
        thumbnailDownloader = [[WDTThumbnailImageDownloader alloc] init];
        thumbnailDownloader.newsStoryData = newsStoryData;
        [thumbnailDownloader setCompletionHandler:^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // Display the newly loaded image.
            cell.imageView.image = newsStoryData.thumbnailImage;
            // Remove the thumbnailDownloader from the in progress list, it will be deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
        }];
        [self.imageDownloadsInProgress setObject:thumbnailDownloader forKey:indexPath];
        [thumbnailDownloader startDownload];
        [thumbnailDownloader release];
    }
}

- (void)loadImagesForOnscreenRows
{
    //  This method is used in case the user scrolled into a set of cells that don't
    //  have their thumbnails yet.
    if ([self.newsStories count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            WDTNewsStoryData *newsStoryData = [self.newsStories objectAtIndex:indexPath.row];
            if (!newsStoryData.thumbnailImage)
            {
                if ((NSObject *)newsStoryData.thumbnailImageHref != [NSNull null]) {
                    [self startIconDownload:newsStoryData forIndexPath:indexPath];
                }
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Disable the refresh button while the user is scrolling.
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //  Load images for all onscreen rows when scrolling is finished.
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
    if (!decelerate) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

@end
