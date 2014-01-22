//
//  ImageScrollView.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXImageScrollView : UIScrollView

@property (strong, nonatomic, readonly) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

- (id)imageView;

@end
