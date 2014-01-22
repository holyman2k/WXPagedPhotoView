//
//  UIImage+WXKit.h
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WXKit)

- (UIImage *)imageScaleToSize:(CGSize)size;

- (UIImage *)imageWithBorderWithColor:(UIColor *)color andThickness:(CGFloat)thickness;
@end
