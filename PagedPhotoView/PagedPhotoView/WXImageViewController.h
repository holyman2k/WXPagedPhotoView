//
//  ImageViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXImageViewController : UIViewController

+ (id)imageViewControllerForImage:(UIImage *)image andPageIndex:(NSUInteger)pageIndex;

@property (nonatomic) bool isLoading;

- (NSUInteger)pageIndex;

- (void)setImage:(UIImage *)image forPageIndex:(NSUInteger)pageIndex;

- (void)setProgress:(CGFloat)progress atPageIndex:(NSUInteger)pageIndex;

- (void)setProgressViewHidden:(BOOL)hidden atPageIndex:(NSUInteger)pageIndex;

- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated;

- (BOOL)isChromeVisbile;

@end
