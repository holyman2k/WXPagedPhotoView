//
//  PagedPhotoViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXImageViewController.h"

@class WXPagedPhotoViewController;


@protocol WXPagedPhotoViewControllerDataSource <NSObject>

- (BOOL)photoExistAtIndex:(NSUInteger)pageIndex;

- (void)imageViewController:(WXImageViewController *)imageViewController imageAtIndex:(NSUInteger)pageIndex isLoading:(BOOL *)isLoading;

- (NSUInteger)numberOfPhoto;

@end

@protocol WXPagedPhotoViewControllerDelegate <NSObject>
@optional
- (void)pagePhotoViewController:(WXPagedPhotoViewController *)pagePhotoViewController didScrollToPageIndex:(NSUInteger)pageIndex;
@end


@interface WXPagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDataSource> dataSource;
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDelegate> delegate;
@property (nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) UIImage *placeholderPhoto;
@property (strong, nonatomic) UIImage *downloadFailedPhoto;

- (void)didLoadImage:(UIImage *)image forImageViewController:(WXImageViewController *)imageViewController;
- (void)setDownloadProgress:(CGFloat)progress forImageViewController:(WXImageViewController *)imageViewController;
- (void)initalize;
- (void)nextPhoto:(id)sender;
- (void)previousPhoto:(id)sender;
- (void)reloadPhoto;
- (NSString *)viewTitle;
- (void)setChromeHidden:(BOOL)hidden animated:(BOOL)animated;
- (WXImageViewController *)imageViewController;
@end
