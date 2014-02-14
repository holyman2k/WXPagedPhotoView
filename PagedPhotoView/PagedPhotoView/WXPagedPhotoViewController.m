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

#pragma mark - setter and getter

- (WXImageViewController *)imageViewController
{
    return (WXImageViewController *)self.pageViewController.viewControllers.firstObject;
}

#pragma mark - Initalizer

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup toolbar
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

#pragma mark - public methods

- (void)initalize
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.doubleSided = YES;
    self.view.frame = self.pageViewController.view.frame;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.title = self.viewTitle;

    WXImageViewController *controller = [self viewControllerAtPageIndex:self.pageIndex];
    if (controller) [self setCurrentPageToViewController:controller];
}

- (NSInteger)pageIndex
{
    if (self.imageViewController) _pageIndex = self.imageViewController.pageIndex;
    return _pageIndex;
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
    id controller = [self viewControllerAtPageIndex:self.pageIndex];
    if (controller) {
        [self setCurrentPageToViewController:controller];
    }
    self.title = self.viewTitle;
}

#pragma mark - UIPageViewController datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger pageIndex = [(WXImageViewController *)viewController pageIndex];
    WXImageViewController *controller = [self viewControllerAtPageIndex:pageIndex - 1];
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger pageIndex = [(WXImageViewController *)viewController pageIndex];
    WXImageViewController *controller = [self viewControllerAtPageIndex:pageIndex + 1];
    return controller;
}

- (WXImageViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex
{
    BOOL hasPhoto = [self.dataSource photoExistAtIndex:pageIndex];
    if (hasPhoto){
        WXImageViewController *controller = [WXImageViewController imageViewControllerForImage:nil andPageIndex:pageIndex];
        controller.view.tintColor = self.view.tintColor;
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
        self.title = self.viewTitle;
        [self.delegate pagePhotoViewController:self didScrollToPageIndex:self.pageIndex];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    WXImageViewController *viewController = pendingViewControllers.lastObject;
    [self prepairToLoadImageForViewController:viewController];
    [self setChromeVisibility:NO animated:YES];
}

#pragma mark - toolbar event handler

- (void)nextPhoto:(id)sender
{
    id controller = [self pageViewController:self.pageViewController viewControllerAfterViewController:self.pageViewController.viewControllers[0]];
    if (controller) [self setCurrentPageToViewController:controller];
}

- (void)previousPhoto:(id)sender
{
    id controller = [self pageViewController:self.pageViewController viewControllerBeforeViewController:self.pageViewController.viewControllers[0]];
    if (controller) [self setCurrentPageToViewController:controller];
}

#pragma mark - private methods

- (void)setCurrentPageToViewController:(WXImageViewController *)viewController
{
    [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:@[self.imageViewController] transitionCompleted:YES];
    [self prepairToLoadImageForViewController:viewController];
}

- (void)prepairToLoadImageForViewController:(WXImageViewController *)viewController
{
    BOOL isLoading = YES;
    UIImage *image = [self.dataSource pagedPhotoViewController:self imageAtIndex:viewController.pageIndex isLoading:&isLoading];
    [viewController setImage:image forPageIndex:viewController.pageIndex];
    if (!isLoading) {
        [viewController setProgressViewHidden:YES atPageIndex:viewController.pageIndex];
    } else {
        [viewController setProgressViewHidden:NO atPageIndex:viewController.pageIndex];
    }
}

#pragma mark - rotation and status bar tweak

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
