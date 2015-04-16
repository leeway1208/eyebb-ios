//
//  DBImageView.h
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBImageView : UIView
@property (nonatomic, copy) NSString *imageWithPath;
@property (nonatomic, strong) UIImage *placeHolder, *image;

+ (void) triggerImageRequests:(BOOL)start;
+ (void) clearCache;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
