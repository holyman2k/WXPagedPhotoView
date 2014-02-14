//
//  ImageViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXImageViewController : UIViewController

@property (nonatomic, readonly) BOOL isChromeHidden;

+ (id)imageViewControllerForImage:(UIImage *)image andPageIndex:(NSUInteger)pageIndex;

- (NSUInteger)pageIndex;

- (void)setImage:(UIImage *)image forPageIndex:(NSUInteger)pageIndex;

- (void)setProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex;

- (void)setProgressViewHidden:(BOOL)hidden atPageIndex:(NSUInteger)pageIndex;

- (void)setChromeHidden:(BOOL)hidden animated:(BOOL)animated;

@end
