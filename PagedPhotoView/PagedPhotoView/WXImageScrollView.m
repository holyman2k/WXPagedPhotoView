//
//  ImageScrollView.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXImageScrollView.h"
#import "UIImageView+WXKit.h"

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
//        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        _imageView.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView.clipsToBounds = NO;
        _imageView.backgroundColor = [UIColor grayColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        NSLog(@"set image with size: %@", NSStringFromCGSize(image.size));
        self.imageView.image = image;
        [self fitImage];
    }
}

- (void)fitImage
{
    if (self.imageView.image) {
        [self.imageView fitToSize:self.bounds.size];
        self.imageView.center = self.center;
        self.contentSize = self.imageView.bounds.size;
        self.minimumZoomScale = self.zoomScale;
        self.maximumZoomScale = MAX(self.imageView.image.size.width / self.imageView.bounds.size.width, 1);
    }
}

- (UIImage *)image
{
    return self.imageView.image;
}

@end
