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

- (void)setImage:(UIImage *)image;

- (void)setProgress:(CGFloat)progress;

- (void)setProgressViewHidden:(BOOL)hidden;

- (void)setChromeHidden:(BOOL)hidden animated:(BOOL)animated;

@end
