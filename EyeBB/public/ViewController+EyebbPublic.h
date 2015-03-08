//
//  ViewController+eyebbPublic.h
//  EyeBB
//
//  Created by Evan on 15/3/8.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIViewController(EyebbPublic)

//将所下载的图片保存到本地
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath ;

//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

@end
