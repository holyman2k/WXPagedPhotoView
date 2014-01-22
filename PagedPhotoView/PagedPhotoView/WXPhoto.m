//
//  WXPhoto.m
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import "WXPhoto.h"

@implementation WXPhoto
- (id)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.photoUrl = url;
    }
    return self;
}
@end
