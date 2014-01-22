//
//  NSMutableArray+Extension.h
//  Defects
//
//  Created by Charlie Wu on 20/01/2014.
//  Copyright (c) 2014 WebFM Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WXKit)

- (id)pop;

- (void)push:(id)object;

- (id)peek;

- (void)empty;

@end
