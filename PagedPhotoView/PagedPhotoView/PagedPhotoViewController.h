//
//  PagedPhotoViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagedPhotoViewControllerProtocol <NSObject>

- (UIImage *)photoAtIndex:(NSUInteger)pageIndex;
- (NSUInteger)numberOfPhoto;

@end

@interface PagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<PagedPhotoViewControllerProtocol> delegate;
@property (nonatomic) NSInteger pageIndex;

- (void)initalize;
@end
