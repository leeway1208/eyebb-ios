//
//  DBImage.m
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import "DBImage.h"
#import "DBImageRequest.h"

@implementation DBImage

+ (instancetype) imageWithPath:(NSString *)path
{
    return [[DBImage alloc] initWithPath:path];
}

- (id) initWithPath:(NSString *)path
{
    self = [super init];
    
    if ( self ) {
        _imageURL = [NSURL URLWithString:path];
    }
    
    return self;
}

- (DBImageRequest *) imageRequest
{
    return [[DBImageRequest alloc] initWithURLRequest:[NSURLRequest requestWithURL:self.imageURL]];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
