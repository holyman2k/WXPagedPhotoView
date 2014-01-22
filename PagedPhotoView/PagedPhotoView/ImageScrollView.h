//
//  ImageScrollView.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView


@property (strong, nonatomic, readonly) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

@end
