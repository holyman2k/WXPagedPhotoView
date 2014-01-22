//
//  PagedPhotoViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "PagedPhotoViewController.h"
#import "ImageViewController.h"

@interface PagedPhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation PagedPhotoViewController

- (void)initalize
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.view.frame = self.pageViewController.view.frame;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = self.viewTitle;

    ImageViewController *pageZero = [ImageViewController imageViewControllerForImage:[self.delegate imageAtIndex:0] andIndex:0];
    pageZero.view.frame = self.view.frame;
    [self.pageViewController setViewControllers:@[pageZero] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self setupToolBar];
}

#pragma mark - UIPageViewController datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UIImage *image = [self.delegate imageAtIndex:self.pageIndex - 1];
    if (image){
        self.pageIndex --;
        self.title = self.viewTitle;
        ImageViewController *controller = [ImageViewController imageViewControllerForImage:image andIndex:self.pageIndex];
        [(UIScrollView *)controller.view setZoomScale:1];
        return controller;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UIImage *image = [self.delegate imageAtIndex:self.pageIndex + 1];
    if (image){
        self.pageIndex ++;
        self.title = self.viewTitle;
        ImageViewController *controller = [ImageViewController imageViewControllerForImage:[self.delegate imageAtIndex:self.pageIndex] andIndex:self.pageIndex];
        [(UIScrollView *)controller.view setZoomScale:1];
        return controller;
    }
    return nil;
}

#pragma mark - setup toolbars

- (NSString *)viewTitle
{
    return [NSString stringWithFormat:@"%d of %d", self.pageIndex + 1, [self.delegate imageCount]];
}

#pragma mark - setup toolbars

- (void)nextPhoto:(id)sender
{
    id view = [self pageViewController:self.pageViewController viewControllerAfterViewController:self.pageViewController.viewControllers[0]];
    if (view) [self.pageViewController setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)previousPhoto:(id)sender
{
    id view = [self pageViewController:self.pageViewController viewControllerBeforeViewController:self.pageViewController.viewControllers[0]];
    if (view) [self.pageViewController setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)setupToolBar
{
    UIImage *previousIcon = [UIImage imageNamed:@"arrowLeft"];
    UIImage *nextIcon = [UIImage imageNamed:@"arrowRight"];
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:previousIcon
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(previousPhoto:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:nextIcon
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(nextPhoto:)];

    UIBarButtonItem *leftFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 50;

    [self setToolbarItems:@[leftFlexibleSpace, previousButton, fixedSpace, nextButton, rightFlexibleSpace] animated:YES];
}

// enable rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
