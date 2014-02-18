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

#pragma mark - setter and getter

- (UIImage *)image
{
    return self.imageView.image;
}

#pragma mark - Initalizer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        self.bounces = NO;
        self.bouncesZoom = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (image) {
        self.imageView.image = image;
        [self fitImage];
    }
}

- (void)fitImage
{
    if (self.image) {
        [self.imageView fitIntoSize:self.bounds.size];
        self.imageView.center = self.center;
        self.contentSize = self.imageView.bounds.size;
        self.maximumZoomScale = [self maximumZoomScaleForSize:self.imageView.frame.size];


    } else {
        self.imageView.center = self.center;
    }
}

- (CGFloat)maximumZoomScaleForSize:(CGSize)size;
{
    CGSize frameSize = self.bounds.size;

    return MAX(frameSize.width / size.width, frameSize.height / size.height);

}
@end
