//
//  WXPhoto.h
//  PagedPhotoView
//
//  Created by Charlie Wu on 11/02/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPhoto : NSObject
@property (strong, nonatomic) NSURL *photoUrl;

- (id)initWithUrl:(NSURL *)url;
@end
