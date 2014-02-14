//
//  WXViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXViewController.h"
#import "WXPhoto.h"
#import "WXKit.h"
#import "AFNetworking.h"

@interface WXViewController () <WXPagedPhotoViewControllerDataSource>

@property (strong, nonatomic) NSArray *images;
@property (nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSTimer *autoPlayTimer;
@property (strong, nonatomic) NSMutableDictionary *operations;
@property (strong, nonatomic) NSCache *cache;
@end

@implementation WXViewController

- (NSCache *)cache
{
    if (!_cache) _cache = [[NSCache alloc]init];
    return _cache;
}

- (NSMutableDictionary *)operations
{
    if (!_operations) _operations = [[NSMutableDictionary alloc] init];
    return _operations;
}

- (NSArray *)images
{
    if (!_images) {
        _images = @[
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://www.afhdr.org/AfHDR/images/pdf-icon.gif"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://jasonlefkowitz.net/wp-content/uploads/2013/07/cats-16140154-1920-1080.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://4.bp.blogspot.com/-MzZCzWI_6Xc/UIUQp1qPfzI/AAAAAAAAHpA/OTwHCJSWFAY/s1600/cats_animals_kittens_cat_kitten_cute_desktop_1680x1050_hd-wallpaper-753974.jpeg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://static.tumblr.com/ce35b04e242c6b8073f3ff7801147e9f/sz5wgey/obSmpcvso/tumblr_static_o-cats-kill-billions-facebook.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://jasonlefkowitz.net/wp-content/uploads/2013/07/Cute-Cats-cats-33440930-1280-800.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://images4.fanpop.com/image/photos/22000000/-_-cats-cats-22066039-1280-1024.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://www.bubblews.com/assets/images/news/1771886411_1372179047.jpg"]],
                    ];
    }
    return _images;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    [self initalize];

    NSMutableArray *toolbarItems = self.toolbarItems.mutableCopy;

    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(setAutoPlay:)];
    UIBarButtonItem *fixWidthLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *fixWidthRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixWidthLeft.width = 20;
    fixWidthRight.width = 20;

    [toolbarItems removeObjectAtIndex:2];

    [toolbarItems insertObject:fixWidthLeft atIndex:2];
    [toolbarItems insertObject:playButton atIndex:2];
    [toolbarItems insertObject:fixWidthRight atIndex:2];

    self.toolbarItems = toolbarItems;
}

- (void)setAutoPlay:(UIBarButtonItem *)sender
{
    NSMutableArray *toolbarItems = self.toolbarItems.mutableCopy;
    if (self.isPlaying) {
        UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(setAutoPlay:)];
        [toolbarItems removeObjectAtIndex:3];
        [toolbarItems insertObject:pauseButton atIndex:3];
        self.isPlaying = NO;
        [self.autoPlayTimer invalidate];
        self.autoPlayTimer = nil;
    } else {
        [self setChromeHidden:YES animated:YES];
        UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(setAutoPlay:)];
        [toolbarItems removeObjectAtIndex:3];
        [toolbarItems insertObject:playButton atIndex:3];
        self.isPlaying = YES;
        self.autoPlayTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(autoPlayNextPhoto) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:self.autoPlayTimer forMode:NSRunLoopCommonModes];
    }
    self.toolbarItems = toolbarItems;
}

- (void)autoPlayNextPhoto
{
    if (self.pageIndex == self.images.count - 1) {
        [self setAutoPlay:nil];
        [self setChromeHidden:YES animated:YES];
    } else {
        [self nextPhoto:self];
    }
}

#pragma mark - WXPhotoViewController delegate

- (BOOL)photoExistAtIndex:(NSUInteger)pageIndex
{
    return [self.images objectOrNilAtIndex:pageIndex] != nil;
}

- (UIImage *)pagedPhotoViewController:(WXPagedPhotoViewController *)pagedPhotoViewController imageAtIndex:(NSUInteger)pageIndex isLoading:(BOOL *)isLoading
{
    WXPhoto *photo = [self.images objectOrNilAtIndex:pageIndex];
    if (!photo) return nil;

    if (![self.operations objectForKey:photo.photoUrl.absoluteString]) {
        *isLoading = YES;
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:photo.photoUrl]];
        [self.operations setObject:operation forKey:photo.photoUrl.absoluteString];
        operation.responseSerializer = [AFImageResponseSerializer serializer];

        __weak WXViewController *me = self;
        __weak NSMutableDictionary *operations = self.operations;

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage *image) {
            [me didLoadImage:image atPageIndex:pageIndex];
            [operations removeObjectForKey:photo.photoUrl.absoluteString];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [me didLoadImage:me.downloadFailedPhoto atPageIndex:pageIndex];
            [operations removeObjectForKey:photo.photoUrl.absoluteString];
        }];

        [operation setDownloadProgressBlock: ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {

            if (pageIndex == self.pageIndex) {
                [self.imageViewController setProgressViewHidden:NO atPageIndex:pageIndex];
                double percent = (double)totalBytesRead / (double)totalBytesExpectedToRead;
                [me photoDownloadProgress:percent atPageIndex:pageIndex];
            }
        }];

        [operation start];
    }
    return nil;
}

- (NSUInteger)numberOfPhoto
{
    return self.images.count;
}

@end
