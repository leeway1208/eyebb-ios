//
//  EyeBBViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "EyeBBViewController.h"
#import "UserDefaultsUtils.h"
@interface EyeBBViewController ()

@end

@implementation EyeBBViewController
@synthesize httpRequest;
static NSBundle *bundle = nil;
-(HttpRequest *)httpRequest{
    if(httpRequest==nil){
        httpRequest = [HttpRequest instance];
        NSLog(@"instance remotecontroller...");
    }
    NSLog(@"remotecontroller:%@", httpRequest);
    
    return httpRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    //定制加载信息
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = LOCALIZATION(@"text_loading");
}


#pragma mark ---
#pragma mark --- 网络数据处理
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{}
- (void)requestFailed:(ASIHTTPRequest *)request{}


#pragma mark - set app language and save the current app language
+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *string = [def valueForKey:EyeBBViewController_userDefaults_userLanguage];
    
    if(string.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        
        NSArray* languages = [def objectForKey:EyeBBViewController_userDefaults_AppleLanguages];
        
        NSString *current = [languages objectAtIndex:0];
        
        string = current;
        
        [def setValue:current forKey:EyeBBViewController_userDefaults_userLanguage];
        
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    NSLog( @"get path-- %@" , path);
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ ( NSBundle * )bundle{
    
    return bundle;
    
}

#pragma mark - get current language
+(NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:EyeBBViewController_userDefaults_userLanguage];
    
    return language;
}

#pragma mark - set the app language
+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
       NSLog( @"path-- %@" , path);
     NSLog( @"language-- %@" , language);
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:EyeBBViewController_userDefaults_userLanguage];
    
    [def synchronize];
}


@end
