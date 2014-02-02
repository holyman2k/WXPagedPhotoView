//
//  PagedPhotoViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXPagedPhotoViewController.h"
#import "WXPhotoProtocol.h"
#import "WXImageViewController.h"

@interface WXPagedPhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation WXPagedPhotoViewController

- (NSCache *)photoCache
{
    if (!_photoCache) {
        _photoCache = [[NSCache alloc] init];
        [_photoCache setCountLimit:50];
    }
    return _photoCache;
}

- (void)setPhotoPlaceholder:(UIImage *)photoPlaceholder
{
    _photoPlaceholder = photoPlaceholder;
    [WXImageViewController setPlaceholderPhoto:photoPlaceholder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupToolBar];
}

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

    WXImageViewController *pageZero = [WXImageViewController imageViewControllerForPhoto:[self.dataSource photoAtIndex:self.pageIndex] andIndex:self.pageIndex];
    pageZero.view.frame = self.view.frame;
    [self.pageViewController setViewControllers:@[pageZero] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}

#pragma mark - UIPageViewController datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    id<WXPhotoProtocol> photo = [self.dataSource photoAtIndex:self.pageIndex - 1];
    if (photo){
        self.pageIndex --;
        self.title = self.viewTitle;
        WXImageViewController *controller = [WXImageViewController imageViewControllerForPhoto:photo andIndex:self.pageIndex];
        [(UIScrollView *)controller.view setZoomScale:1];
        return controller;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    id<WXPhotoProtocol> photo = [self.dataSource photoAtIndex:self.pageIndex + 1];
    if (photo){
        self.pageIndex ++;
        self.title = self.viewTitle;
        WXImageViewController *controller = [WXImageViewController imageViewControllerForPhoto:photo andIndex:self.pageIndex];
        [(UIScrollView *)controller.view setZoomScale:1];
        return controller;
    }
    return nil;
}

- (NSString *)viewTitle
{
    return [NSString stringWithFormat:@"%ld of %ld", (unsigned long)(self.pageIndex + 1), (unsigned long)[self.dataSource numberOfPhoto]];
}

- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated
{
    [self.imageViewController setChromeVisibility:isVisible animated:animated];
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
