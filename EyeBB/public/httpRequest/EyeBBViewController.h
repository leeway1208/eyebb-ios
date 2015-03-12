//
//  EyeBBViewController.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


#import "EyeBBHttpDelegate.h"
#import "HttpRequest.h"
#import "HttpRequestUtils.h"
#import "JSONKit.h"
//加载状态
#import "MBProgressHUD.h"
//访问服务器
#import "UIViewController+EyeBBServie.h"
//访问本地数据库
#import "UIViewController+EyeBBDB.h"
//公用方法
#import "ViewController+EyebbPublic.h"

@interface EyeBBViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic, retain)HttpRequest *httpRequest;
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag;
- (void)requestFailed:(ASIHTTPRequest *)request;

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言
@end
