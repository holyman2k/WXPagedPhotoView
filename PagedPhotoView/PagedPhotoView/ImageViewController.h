//
//  ImageViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

+ (id)imageViewControllerForImage:(UIImage *)image andIndex:(NSUInteger)index;

- (NSUInteger)pageIndex;

@end
