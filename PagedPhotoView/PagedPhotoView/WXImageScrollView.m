//
//  ImageScrollView.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXImageScrollView.h"

@interface WXImageScrollView()

@end

@implementation WXImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        _imageView.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView.clipsToBounds = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

        self.minimumZoomScale = 1;
        self.maximumZoomScale = 2;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    if (image) {
        [self.imageView sizeToFit];
        self.imageView.center = self.center;

    }
}

- (UIImage *)image
{
    return self.imageView.image;
}

@end
