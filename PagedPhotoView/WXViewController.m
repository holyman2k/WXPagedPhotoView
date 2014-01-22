//
//  WXViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXViewController.h"
#import "NSArray+WXKit.h"
@interface WXViewController () <PagedPhotoViewControllerProtocol>

@property (strong, nonatomic) NSArray *images;

@end

@implementation WXViewController

- (NSArray *)images
{
    if (!_images) {
        _images = @[[UIImage imageNamed:@"Image"],
                    [UIImage imageNamed:@"Image-1"],
                    [UIImage imageNamed:@"Image-2"]];
    }
    return _images;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self initalize];
}

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    return [self.images objectOrNilAtIndex:index];
}

- (NSUInteger)imageCount
{
    return self.images.count;
}
@end
