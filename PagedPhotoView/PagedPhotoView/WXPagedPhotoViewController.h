//
//  PagedPhotoViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPhotoProtocol.h"

@class WXPagedPhotoViewController;

@protocol WXPagedPhotoViewControllerDataSource <NSObject>

- (id<WXPhotoProtocol>)photoAtIndex:(NSUInteger)pageIndex;
- (NSUInteger)numberOfPhoto;
@end

@protocol WXPagedPhotoViewControllerDelegate <NSObject>
@optional
- (void)pagePhotoViewController:(WXPagedPhotoViewController *)pagePhotoViewController
                   didLoadPhoto:(id<WXPhotoProtocol>)photo
                    atPageIndex:(NSUInteger)pageIndex;
@end

@interface WXPagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDataSource> dataSource;
@property (weak, nonatomic) id<WXPagedPhotoViewControllerDelegate> delegate;
@property (nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSCache *photoCache;
@property (strong, nonatomic) UIImage *photoPlaceholder;

- (void)initalize;
- (void)nextPhoto:(id)sender;
- (void)previousPhoto:(id)sender;
- (void)reloadPhoto;
- (NSString *)viewTitle;
- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated;
@end
