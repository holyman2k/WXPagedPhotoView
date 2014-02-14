//
//  ImageViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXImageViewController.h"
#import "WXImageScrollView.h"
#import "DACircularProgressView.h"

@interface WXImageViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readonly) NSUInteger pageIndex;
@property (strong, nonatomic) DACircularProgressView *progressView;
@property (nonatomic) BOOL isLoading;
@end

@implementation WXImageViewController

@synthesize pageIndex = _pageIndex;

#pragma mark - setter and getter

- (DACircularProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _progressView.roundedCorners = YES;
        _progressView.center = self.view.center;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = self.view.tintColor;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (WXImageScrollView *)imageScrollView
{
    return (WXImageScrollView *)self.view;
}

#pragma mark - initalizer

+ (id)imageViewControllerForImage:(UIImage *)image andPageIndex:(NSUInteger)pageIndex
{
    WXImageViewController *imageViewController = [[self alloc] initWithPageIndex:pageIndex];
    imageViewController.imageScrollView.image = image;
    return imageViewController;
}

- (id)initWithPageIndex:(NSUInteger)pageIndex
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _pageIndex = pageIndex;
        WXImageScrollView *scrollView = [[WXImageScrollView alloc] initWithFrame:self.view.frame];
        scrollView.delegate = self;
        self.view = scrollView;
        [self setupGestures];
    }
    return self;
}

#pragma mark - public methods

- (NSUInteger)pageIndex
{
    return _pageIndex;
}

- (void)setImage:(UIImage *)image
{
    self.imageScrollView.image = image;
}

- (void)setProgress:(CGFloat)progress
{
    self.progressView.progress = progress;
}

- (void)setProgressViewHidden:(BOOL)hidden
{
    if (self.progressView.hidden != hidden) {
        self.progressView.hidden = hidden;
    }
    self.isLoading = !hidden;
}

- (void)setChromeHidden:(BOOL)hidden animated:(BOOL)animated;
{
    _isChromeHidden = hidden;
    if (!animated) {
        self.navigationController.navigationBar.alpha = hidden ? 0 : 1;
        self.navigationController.toolbar.alpha = hidden ? 0 : 1;
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [UIView animateWithDuration:.25 animations:^(void) {
            self.navigationController.navigationBar.alpha = hidden ? 0 : 1;
            self.navigationController.toolbar.alpha = hidden ? 0 : 1;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

#pragma mark - gesture handling

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
    if (self.isLoading) return;

    if (self.imageScrollView.zoomScale == 1) {
        CGFloat scale = .25;
        CGFloat width = self.imageScrollView.imageView.bounds.size.width;
        CGFloat height = self.imageScrollView.imageView.bounds.size.height;
        CGRect frame = CGRectMake(width * scale, height * scale, width - width * scale * 2, height - height * scale * 2);
        [self.imageScrollView zoomToRect:frame animated:YES];
    } else {
        [self.imageScrollView zoomToRect:self.view.frame animated:YES];
    }
}

- (void)tapGestureHander:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setChromeHidden:!self.isChromeHidden animated:YES];
    }
}

#pragma mark - scroll view zoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.isLoading ? nil : [(WXImageScrollView *)self.view imageView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView* zoomView = [scrollView.delegate viewForZoomingInScrollView:scrollView];
    CGRect zoomViewFrame = zoomView.frame;
    if (zoomViewFrame.size.width < scrollView.bounds.size.width) {
        zoomViewFrame.origin.x = (scrollView.bounds.size.width - zoomViewFrame.size.width) / 2.0;
    } else {
        zoomViewFrame.origin.x = 0.0;
    }

    if (zoomViewFrame.size.height < scrollView.bounds.size.height) {
        zoomViewFrame.origin.y = (scrollView.bounds.size.height - zoomViewFrame.size.height) / 2.0;
    } else {
        zoomViewFrame.origin.y = 0.0;
    }
    zoomView.frame = zoomViewFrame;
}

#pragma mark - rotation and status bar tweak

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    self.progressView.center = self.view.center;
    [self.imageScrollView fitImage];
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}
@end
