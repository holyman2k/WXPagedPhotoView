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
- (UIImage *)pagedPhotoViewController:(WXPagedPhotoViewController *)pagedPhotoViewController imageAtIndex:(NSUInteger)pageIndex isLoading:(BOOL *)isLoading;
- (NSUInteger)numberOfPhoto;

@end

@protocol WXPagedPhotoViewControllerDelegate <NSObject>
@optional
- (void)pagePhotoViewController:(WXPagedPhotoViewController *)pagePhotoViewController didScrollToPageIndex:(NSUInteger)pageIndex;
@end


@interface WXPagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDataSource> dataSource;
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDelegate> delegate;
@property (nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) UIImage *placeholderPhoto;
@property (strong, nonatomic) UIImage *downloadFailedPhoto;

- (void)didLoadImage:(UIImage *)image atPageIndex:(NSUInteger)pageIndex;
- (void)photoDownloadProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex;
- (void)initalize;
- (void)nextPhoto:(id)sender;
- (void)previousPhoto:(id)sender;
- (void)reloadPhoto;
- (NSString *)viewTitle;
- (void)setChromeHidden:(BOOL)hidden animated:(BOOL)animated;
- (WXImageViewController *)imageViewController;
@end
