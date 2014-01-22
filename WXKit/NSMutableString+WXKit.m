//
//  NSMutableString+WXKit.m
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import "NSMutableString+WXKit.h"
#import "NSString+WXKit.h"

@implementation NSMutableString (WXKit)

- (void)trimSelf
{
    NSCharacterSet *trimCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *string = [self stringByTrimmingCharactersInSet:trimCharSet];
    [self setString:string];
}
@end
