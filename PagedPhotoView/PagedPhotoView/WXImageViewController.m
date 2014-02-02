//
//  ImageViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXImageViewController.h"
#import "WXImageScrollView.h"

@interface WXImageViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readonly) NSUInteger pageIndex;
@property (strong, nonatomic) DACircularProgressView *progressView;
@property NSOperation *operation;
@end

@implementation WXImageViewController

@synthesize pageIndex = _pageIndex;

static UIImage *placeholder;

static NSCache *photoCache;

static UIImage *invalidPhoto;

+ (id)imageViewControllerForPhoto:(id<WXPhotoProtocol>)photo andIndex:(NSUInteger)pageIndex;
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

+ (void)setInvalidPhoto:(UIImage *)image
{
    invalidPhoto = image;
}

- (WXImageScrollView *)imageScrollView
{
    return (WXImageScrollView *)self.view;
}

- (id)initWithImage:(id<WXPhotoProtocol>)photo atIndex:(NSUInteger)pageIndex
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _photo = photo;
        _pageIndex = pageIndex;
        WXImageScrollView *scrollView = [[WXImageScrollView alloc] initWithFrame:self.view.frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        self.view = scrollView;
        [self setupGestures];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIImage *image = self.photo.photo ? self.photo.photo : [photoCache objectForKey:self.photo.photoUrl];
    if (image) {
        self.imageScrollView.image = image ? image: placeholder;
    } else {
        [self loadNetworkPhoto];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.operation cancel];
    [super viewWillDisappear:animated];
}

- (NSUInteger)pageIndex
{
    return _pageIndex;
}

- (void)loadNetworkPhoto
{
    __weak WXImageScrollView *scrollView = self.imageScrollView;
    scrollView.image = placeholder;
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
        scrollView.image = invalidPhoto;
    }];

    __weak DACircularProgressView *progressView = self.progressView;
    [operation setDownloadProgressBlock: ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double percent = (double)totalBytesRead / (double)totalBytesExpectedToRead;
        if (totalBytesRead == totalBytesExpectedToRead) {
            [progressView removeFromSuperview];
        } else {
            progressView.progress = percent;
        }
    }];
    [operation start];
}

- (void)setupGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHander:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];

    UITapGestureRecognizer *zoomGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomGestureHandler:)];
    zoomGesture.numberOfTapsRequired = 2;
    zoomGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:zoomGesture];

    [tapGesture requireGestureRecognizerToFail:zoomGesture];

    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) gesture.delegate = self;
    }
}

- (void)zoomGestureHandler:(UITapGestureRecognizer *)gesture
{
    if (self.operation.isExecuting) return;

    if (self.imageScrollView.zoomScale == 1) {
        CGFloat scale = .25;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        CGRect frame = CGRectMake(width * scale, height * scale, width - width * scale * 2, height - height * scale * 2);
        [self.imageScrollView zoomToRect:frame animated:YES];
    } else {
        [self.imageScrollView zoomToRect:self.view.frame animated:YES];
    }
}

- (void)tapGestureHander:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.isChromeVisbile) {
            [self setChromeVisibility:YES animated:YES];
        } else {
            [self setChromeVisibility:NO animated:YES];
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)isChromeVisbile
{
    return self.navigationController.navigationBarHidden;
}

- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:!isVisible animated:animated];
    [self.navigationController setToolbarHidden:!isVisible animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:!isVisible withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [(WXImageScrollView *)self.view imageView];
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}
@end
