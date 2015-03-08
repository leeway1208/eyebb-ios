//
//  EyeBBViewController.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


#import "EyeBBHttpDelegate.h"
#import "HttpRequest.h"
//访问服务器
#import "UIViewController+EyeBBServie.h"
//访问本地数据库
#import "UIViewController+EyeBBDB.h"
//公用方法
#import "ViewController+EyebbPublic.h"
@interface EyeBBViewController : UIViewController
@property(nonatomic, retain)HttpRequest *httpRequest;
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end
