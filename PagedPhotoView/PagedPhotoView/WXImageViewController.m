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
@end

@implementation WXImageViewController

@synthesize pageIndex = _pageIndex;

+ (id)imageViewControllerForImage:(UIImage *)image andPageIndex:(NSUInteger)pageIndex
{
    WXImageViewController *imageViewController = [[self alloc] initWithPageIndex:pageIndex];
    imageViewController.imageScrollView.image = image;
    return imageViewController;
}

- (WXImageScrollView *)imageScrollView
{
    return (WXImageScrollView *)self.view;
}

- (id)initWithPageIndex:(NSUInteger)pageIndex
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _pageIndex = pageIndex;
        WXImageScrollView *scrollView = [[WXImageScrollView alloc] initWithFrame:self.view.frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        self.view = scrollView;
        [self setupGestures];

        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.progressView.roundedCorners = YES;
        self.progressView.center = self.view.center;
        self.progressView.trackTintColor = [UIColor clearColor];
        self.progressView.progressTintColor = self.view.tintColor;
        [self.view addSubview:self.progressView];
    }
    return self;
}

- (NSUInteger)pageIndex
{
    return _pageIndex;
}

- (void)setImage:(UIImage *)image forPageIndex:(NSUInteger)pageIndex
{
    if (self.pageIndex == pageIndex) {
        self.imageScrollView.image = image;
        self.imageScrollView.zoomScale = 1;
    }
}

- (void)setProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex
{
    if (self.pageIndex == pageIndex) {
        [self.progressView setProgress:progress animated:YES];
    }
}

- (void)setProgressViewHidden:(BOOL)hidden atPageIndex:(NSUInteger)pageIndex
{
    if (self.pageIndex == pageIndex) {
        self.progressView.hidden = hidden;
    }
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
    if (self.isLoading) return;

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
