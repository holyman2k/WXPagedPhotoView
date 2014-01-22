//
//  UILabel+WXKit.m
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import "UILabel+WXKit.h"

@implementation UILabel (WXKit)
- (float)textWidth
{
    NSDictionary *attributesDictionary = @{NSFontAttributeName: self.font};
    
    if ([UIDevice currentDevice].systemVersion.floatValue  < 7) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(FLT_MAX, CGRectGetHeight(self.frame))].width;
        #pragma clang diagnostic pop
    } else {
        return [self.text boundingRectWithSize:CGSizeMake(FLT_MAX, CGRectGetHeight(self.frame))
                                       options: NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributesDictionary
                                       context:nil].size.width;
    }
}

- (float)textHeight
{
    NSDictionary *attributesDictionary = @{NSFontAttributeName: self.font};
    
    if ([UIDevice currentDevice].systemVersion.floatValue  < 7) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX)].width;
        #pragma clang diagnostic pop
        
    } else {
        return [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX)
                                       options: NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributesDictionary
                                       context:nil].size.width;
    }
}

@end
