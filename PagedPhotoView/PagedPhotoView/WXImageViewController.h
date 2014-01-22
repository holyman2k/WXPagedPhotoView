//
//  ImageViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPhotoProtocol.h"

@interface WXImageViewController : UIViewController

+ (id)imageViewControllerForPhoto:(id<WXPhotoProtocol>)photo andIndex:(NSUInteger)index;

+ (void)setPlaceholderPhoto:(UIImage *)image;

+ (void)setInvalidPhoto:(UIImage *)image;

+ (void)setPhotoCache:(NSCache *)cache;

@property (strong, nonatomic) UIImage *photoPlaceholder;

- (NSUInteger)pageIndex;


@end
