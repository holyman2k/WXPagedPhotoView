//
//  PagedPhotoViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXPagedPhotoViewController.h"
#import "WXPhotoProtocol.h"

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

    WXImageViewController *baseViewController = [self viewControllerAtPageIndex:self.pageIndex];
    baseViewController.view.tintColor = self.view.tintColor;
    [self.pageViewController setViewControllers:@[baseViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
    // todo - improve performance by set photo and title not regenerate view
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
    return [self viewControllerAtPageIndex:self.pageIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self viewControllerAtPageIndex:self.pageIndex + 1];
}

- (WXImageViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex
{
    id<WXPhotoProtocol> photo = [self.dataSource photoAtIndex:pageIndex];
    if (photo){
        WXImageViewController *controller = [WXImageViewController imageViewControllerForImage:nil andPageIndex:pageIndex];
        controller.view.tintColor = self.view.tintColor;
        [(UIScrollView *)controller.view setZoomScale:1];
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
        BOOL isLoading = NO;
        WXImageViewController *imageViewController = (WXImageViewController *)self.pageViewController.viewControllers.lastObject;
        UIImage *image = [self.dataSource pagedPhotoViewController:self imageAtIndex:imageViewController.pageIndex isLoading:&isLoading];
        [imageViewController setImage:image forPageIndex:imageViewController.pageIndex];
        if (!isLoading) {
            [self.imageViewController setProgressViewHidden:YES atPageIndex:imageViewController.pageIndex];
        } else {
            [self.imageViewController setProgressViewHidden:NO atPageIndex:imageViewController.pageIndex];
        }
        self.pageIndex = imageViewController.pageIndex;
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
