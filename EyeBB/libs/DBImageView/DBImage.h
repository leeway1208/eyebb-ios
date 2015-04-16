//
//  DBImage.h
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBImageRequest;
@interface DBImage : NSObject
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) DBImageRequest *imageRequest;

+ (instancetype) imageWithPath:(NSString *)path;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
