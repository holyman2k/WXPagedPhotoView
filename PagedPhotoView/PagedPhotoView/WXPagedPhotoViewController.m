//
//  PagedPhotoViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXPagedPhotoViewController.h"

@interface WXPagedPhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation WXPagedPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupToolBar];
}

#pragma mark - WXPagedPhotoViewController methods

- (WXImageViewController *)imageViewController
{
    return (WXImageViewController *)self.pageViewController.viewControllers[0];
}

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
    self.title = self.viewTitle;

    WXImageViewController *controller = [self viewControllerAtPageIndex:self.pageIndex];
    [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:nil transitionCompleted:YES];
}

- (void)didLoadImage:(UIImage *)image atPageIndex:(NSUInteger)pageIndex;
{
    [self.imageViewController setImage:image forPageIndex:pageIndex];
    [self.imageViewController setProgressViewHidden:YES atPageIndex:pageIndex];
}

- (void)photoDownloadProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex
{
    [self.imageViewController setProgress:progress atPageIndex:pageIndex];
}

- (NSString *)viewTitle
{
    return [NSString stringWithFormat:@"%ld of %ld", (unsigned long)(self.pageIndex + 1), (unsigned long)[self.dataSource numberOfPhoto]];
}

- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated
{
    [self.imageViewController setChromeVisibility:isVisible animated:animated];
}

- (void)reloadPhoto
{
    id view = [self viewControllerAtPageIndex:self.pageIndex];
    if (view) {
        [self.pageViewController setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:nil transitionCompleted:YES];
    }
    self.title = self.viewTitle;
}

#pragma mark - private methods

#pragma mark - UIPageViewController datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    WXImageViewController *controller = [self viewControllerAtPageIndex:self.pageIndex - 1];
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    WXImageViewController *controller = [self viewControllerAtPageIndex:self.pageIndex + 1];
    return controller;
}


- (WXImageViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex
{
    BOOL hasPhoto = [self.dataSource photoExistAtIndex:pageIndex];
    if (hasPhoto){
        WXImageViewController *controller = [WXImageViewController imageViewControllerForImage:nil andPageIndex:pageIndex];
        controller.view.tintColor = self.view.tintColor;
        [(UIScrollView *)controller.view setZoomScale:1];
        controller.view.tintColor = self.view.tintColor;
        BOOL isLoading = YES;
        UIImage *image = [self.dataSource pagedPhotoViewController:self imageAtIndex:controller.pageIndex isLoading:&isLoading];
        [controller setImage:image forPageIndex:controller.pageIndex];
        if (!isLoading) {
            [controller setProgressViewHidden:YES atPageIndex:controller.pageIndex];
        } else {
            [controller setProgressViewHidden:NO atPageIndex:controller.pageIndex];
        }
        return controller;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed){
//        BOOL isLoading = YES;
//        UIImage *image = [self.dataSource pagedPhotoViewController:self imageAtIndex:self.imageViewController.pageIndex isLoading:&isLoading];
//        [self.imageViewController setImage:image forPageIndex:self.imageViewController.pageIndex];
//        if (!isLoading) {
//            [self.imageViewController setProgressViewHidden:YES atPageIndex:self.imageViewController.pageIndex];
//        } else {
//            [self.imageViewController setProgressViewHidden:NO atPageIndex:self.imageViewController.pageIndex];
//        }
        self.pageIndex = self.imageViewController.pageIndex;
        self.title = self.viewTitle;
        [self.delegate pagePhotoViewController:self didScrollToPageIndex:self.pageIndex];
    }
}

#pragma mark - setup toolbars

- (void)nextPhoto:(id)sender
{
    id view = [self pageViewController:self.pageViewController viewControllerAfterViewController:self.pageViewController.viewControllers[0]];
    if (view) {
        id previousViewControllers = self.pageViewController.viewControllers;
        [self.pageViewController setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:previousViewControllers transitionCompleted:YES];
    }
}

- (void)previousPhoto:(id)sender
{
    id view = [self pageViewController:self.pageViewController viewControllerBeforeViewController:self.pageViewController.viewControllers[0]];
    if (view) {
        id previousViewControllers = self.pageViewController.viewControllers;
        [self.pageViewController setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:previousViewControllers transitionCompleted:YES];
    }
}

- (void)setupToolBar
{
    UIImage *previousIcon = [UIImage imageNamed:@"arrowLeft"];
    UIImage *nextIcon = [UIImage imageNamed:@"arrowRight"];

    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        previousIcon = [previousIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        nextIcon = [nextIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }

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

#pragma mark - rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.imageViewController;
}
@end
