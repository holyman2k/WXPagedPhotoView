//
//  PagedPhotoViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPhotoProtocol.h"

@protocol PagedPhotoViewControllerProtocol <NSObject>

- (id<WXPhotoProtocol>)photoAtIndex:(NSUInteger)pageIndex;
- (NSUInteger)numberOfPhoto;

@end

@interface PagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<PagedPhotoViewControllerProtocol> delegate;
@property (nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSCache *photoCache;
@property (strong, nonatomic) UIImage *photoPlaceholder;

- (void)initalize;
@end
