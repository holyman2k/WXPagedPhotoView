//
//  WXPhotoProtocol.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXPhotoProtocol <NSObject>

- (UIImage *)photo;
- (NSURL *)photoUrl;

@end
