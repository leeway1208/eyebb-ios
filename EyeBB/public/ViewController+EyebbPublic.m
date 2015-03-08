//
//  ViewController+eyebbPublic.m
//  EyeBB
//
//  Created by Evan on 15/3/8.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "ViewController+EyebbPublic.h"


@implementation UIViewController(EyebbPublic)

//将所下载的图片保存到本地
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    //    NSString * Imgpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@/%@", directoryPath, fileName] ofType:extension];
    //    UIImage * result = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", directoryPath, fileName]];
    //    [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"test"];
    UIImage *result=[[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(), fileName,extension]];
    
    return result;
}



@end
