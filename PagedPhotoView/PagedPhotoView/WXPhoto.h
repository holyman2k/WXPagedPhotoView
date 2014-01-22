//
//  WXPhoto.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 22/01/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXPhotoProtocol.h"

@interface WXPhoto : NSObject <WXPhotoProtocol>

@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSURL *photoUrl;

- (id)initWithUrl:(NSURL *)url;

@end
