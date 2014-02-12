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
@property (nonatomic) bool isLoading;
@end

@implementation WXImageViewController

@synthesize pageIndex = _pageIndex;

+ (id)imageViewControllerForImage:(UIImage *)image andPageIndex:(NSUInteger)pageIndex
{
    WXImageViewController *imageViewController = [[self alloc] initWithPageIndex:pageIndex];
    imageViewController.imageScrollView.image = image;
    return imageViewController;
}

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

- (NSUInteger)pageIndex
{
    return _pageIndex;
}

- (void)setImage:(UIImage *)image forPageIndex:(NSUInteger)pageIndex
{
    NSLog(@"set image at index: %d, current index: %d", pageIndex, self.pageIndex);
    if (self.pageIndex == pageIndex) {
        self.imageScrollView.image = image;
    }
}

- (void)setProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex
{
    if (self.pageIndex == pageIndex) {
        self.progressView.progress = progress;
    }
}

- (void)setProgressViewHidden:(BOOL)hidden atPageIndex:(NSUInteger)pageIndex
{
    if (self.pageIndex == pageIndex) {
        if (self.progressView.hidden != hidden) {
            self.progressView.hidden = hidden;
        }
        self.isLoading = !hidden;
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

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}

- (void)tapGestureHander:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.isChromeVisbile) {
            [self setChromeVisibility:YES animated:YES];
        } else {
            [self setChromeVisibility:NO animated:YES];
        }
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
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.isLoading ? nil : [(WXImageScrollView *)self.view imageView];
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{

    [self.imageScrollView fitImage];
}

@end
