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

#pragma mark - set user language
/**
 *  set user languages
 *
 *  @param language language (1 is Chinese, 2 is Cantonese, default is English)
 */
+(void)setUserLanguge:(int)language {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    switch (language) {
        case 1:
            
            [def setObject:@"zh-Hans-CN" forKey:EyeBBViewController_userDefaults_userLanguage];
            [def synchronize];
            
            break;
        case 2:
            
            [def setObject:@"zh-Hant-HK" forKey:EyeBBViewController_userDefaults_userLanguage];
            [def synchronize];
            break;
        default:
            [def setObject:@"en" forKey:EyeBBViewController_userDefaults_userLanguage];
            [def synchronize];
            break;
    }
}

/**
 *  get current language
 *
 *  @return current language
 */
+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

@end
