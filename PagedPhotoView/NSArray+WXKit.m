//
//  NSArray+WXKit.m
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import "NSArray+WXKit.h"

@implementation NSArray (WXKit)

- (id)objectOrNilAtIndex:(NSUInteger)index
{
    if (self.count > index) {
        return self[index];
    }
    return nil;
}

- (NSArray *)reverse
{
    return self.reverseObjectEnumerator.allObjects;
}
@end
