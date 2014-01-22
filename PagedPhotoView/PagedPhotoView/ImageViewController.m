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
@property (strong, nonatomic) UIImage *image;
@end

@implementation ImageViewController

@synthesize pageIndex = _pageIndex;

+ (id)imageViewControllerForImage:(UIImage *)image andIndex:(NSUInteger)pageIndex;
{
    if (image) {
        return [[self alloc] initWithImage:image atIndex:pageIndex];
    }
    return nil;
}

- (id)initWithImage:(UIImage *)image atIndex:(NSUInteger)pageIndex
{
    if ((self = [super initWithNibName:nil bundle:nil])) {        _pageIndex = pageIndex;

        ImageScrollView *scrollView = [[ImageScrollView alloc] initWithFrame:self.view.frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        scrollView.image = image;
        self.view = scrollView;
        [self setupGestures];

    }
    return self;
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
