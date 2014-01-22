//
//  WXViewController.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXViewController.h"
#import "WXPhoto.h"

@interface WXViewController () <PagedPhotoViewControllerProtocol>

@property (strong, nonatomic) NSArray *images;

@end

@implementation WXViewController

- (NSArray *)images
{
    if (!_images) {
        _images = @[
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://www.afhdr.org/AfHDR/images/pdf-icon.gif"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://jasonlefkowitz.net/wp-content/uploads/2013/07/cats-16140154-1920-1080.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://4.bp.blogspot.com/-MzZCzWI_6Xc/UIUQp1qPfzI/AAAAAAAAHpA/OTwHCJSWFAY/s1600/cats_animals_kittens_cat_kitten_cute_desktop_1680x1050_hd-wallpaper-753974.jpeg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://static.tumblr.com/ce35b04e242c6b8073f3ff7801147e9f/sz5wgey/obSmpcvso/tumblr_static_o-cats-kill-billions-facebook.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://jasonlefkowitz.net/wp-content/uploads/2013/07/Cute-Cats-cats-33440930-1280-800.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://images4.fanpop.com/image/photos/22000000/-_-cats-cats-22066039-1280-1024.jpg"]],
                    [[WXPhoto alloc] initWithUrl:[NSURL URLWithString:@"http://www.bubblews.com/assets/images/news/1771886411_1372179047.jpg"]],
                    ];
    }
    return _images;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self initalize];
}

- (id<WXPhotoProtocol>)photoAtIndex:(NSUInteger)pageIndex
{
    return [self.images objectOrNilAtIndex:pageIndex];
}

- (NSUInteger)numberOfPhoto
{
    return self.images.count;
}
@end
