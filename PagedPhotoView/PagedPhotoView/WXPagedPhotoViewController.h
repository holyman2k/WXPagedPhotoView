//
//  PagedPhotoViewController.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPhotoProtocol.h"

@protocol WXPagedPhotoViewControllerProtocol <NSObject>

- (id<WXPhotoProtocol>)photoAtIndex:(NSUInteger)pageIndex;
- (NSUInteger)numberOfPhoto;

@end

@interface WXPagedPhotoViewController : UIViewController
@property (weak, nonatomic) id<WXPagedPhotoViewControllerProtocol> delegate;
@property (nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSCache *photoCache;
@property (strong, nonatomic) UIImage *photoPlaceholder;

- (void)initalize;
- (void)nextPhoto:(id)sender;
- (void)previousPhoto:(id)sender;
- (NSString *)viewTitle;
- (void)setChromeVisibility:(BOOL)isVisible animated:(BOOL)animated;
@end
