//
//  NSString+WXKit.h
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WXKit)

+ (BOOL)isEmptyOrNil:(NSString *)string;

+ (BOOL)isEmptyOrNilOrOnlyWhiteSpace:(NSString *)string;

- (NSString *)trim;

- (CGFloat)heightForFont:(UIFont *)font andWidth:(CGFloat)width;

- (CGFloat)widthForFont:(UIFont *)font;

- (NSData *)encryptWithKey:(NSString *)key;

+ (NSString *)stringWithEncryptedNSData:(NSData *)data withKey:(NSString *)key;

@end
