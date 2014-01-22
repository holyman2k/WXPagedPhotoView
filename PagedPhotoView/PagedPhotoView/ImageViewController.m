//
//  ImageViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageScrollView.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, readonly) NSUInteger pageIndex;
@property (strong, nonatomic) id<WXPhotoProtocol> photo;
@property (strong, nonatomic) DACircularProgressView *progressView;
@property NSOperation *operation;
@end

@implementation ImageViewController

@synthesize pageIndex = _pageIndex;

static UIImage *placeholder;

static NSCache *photoCache;

+ (id)imageViewControllerForImage:(id<WXPhotoProtocol>)photo andIndex:(NSUInteger)pageIndex;
{
    if (photo) {
        return [[self alloc] initWithImage:photo atIndex:pageIndex];
    }
    return nil;
}

+ (void)setPlaceholderPhoto:(UIImage *)image
{
    placeholder = image;
}

+ (void)setPhotoCache:(NSCache *)cache
{
    photoCache = cache;
}

- (ImageScrollView *)imageScrollView
{
    return (ImageScrollView *)self.view;
}

- (id)initWithImage:(id<WXPhotoProtocol>)photo atIndex:(NSUInteger)pageIndex
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.photo = photo;
        _pageIndex = pageIndex;
        ImageScrollView *scrollView = [[ImageScrollView alloc] initWithFrame:self.view.frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        self.view = scrollView;
        [self setupGestures];

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    __weak ImageScrollView *scrollView = self.imageScrollView;

    UIImage *image = self.photo.photo ? self.photo.photo : [photoCache objectForKey:self.photo.photoUrl];
    if (image) {
        scrollView.image = image ? image: placeholder;
        return;
    }

    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.progressView.roundedCorners = YES;
    self.progressView.center = self.view.center;
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = self.view.tintColor;
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:self.photo.photoUrl]];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    self.operation = operation;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage *image) {
        scrollView.image = image;
        [photoCache setObject:image forKey:self.photo.photoUrl];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"load failed");
    }];

    [operation setDownloadProgressBlock: ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double percent = (double)totalBytesRead / (double)totalBytesExpectedToRead;
        NSLog(@"download percent %f", percent);
        if (totalBytesRead == totalBytesExpectedToRead) {
            [self.progressView removeFromSuperview];
        } else {
            self.progressView.progress = percent;
        }
    }];
    [operation start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.operation cancel];
}

- (NSUInteger)pageIndex
{
    return self.pageIndex;
}

- (void)setupGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHander:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureHander:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController setToolbarHidden:NO animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setToolbarHidden:YES animated:YES];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [(ImageScrollView *)self.view imageView];
}
@end