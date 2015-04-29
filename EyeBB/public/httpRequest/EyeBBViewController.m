//
//  EyeBBViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "EyeBBViewController.h"

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
- (void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag{}

#pragma mark - set user language
/**
 *  set user languages
 *
 *  @param language language (1 is Chinese, 2 is Cantonese, default is English)
 */
-(void)setUserLanguge:(int)language {
    
    NSArray * availableLanguagesArray = @[@"en", @"zh-Hans-CN", @"zh-Hant-HK"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    switch (language) {
        case 1:
            
            [def setObject:@"zh-Hans-CN" forKey:EyeBBViewController_userDefaults_userLanguage];
            [def synchronize];
            [[Localisator sharedInstance] setLanguage:availableLanguagesArray[1]];
            break;
        case 2:
            
            [def setObject:@"zh-Hant-HK" forKey:EyeBBViewController_userDefaults_userLanguage];
            [[Localisator sharedInstance] setLanguage:availableLanguagesArray[2]];
            [def synchronize];
            break;
        default:
            [def setObject:@"en" forKey:EyeBBViewController_userDefaults_userLanguage];
            [[Localisator sharedInstance] setLanguage:availableLanguagesArray[0]];
            [def synchronize];
            break;
    }
}

/**
 *  get current System language
 *
 *  @return current System language
 */
- (NSString *)getCurrentSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

/**
 *  get current App language
 *
 *  @return current App language
 */
- (NSString *)getCurrentAppLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *appLanguage = [def valueForKey:EyeBBViewController_userDefaults_userLanguage];
    
    return appLanguage;
}

#pragma mark - get the label text width
/**
 *  get text width
 *
 *  @param label <#label description#>
 *
 *  @return <#return value description#>
 */
CGFloat getLableTextWidth(UILabel * label,CGFloat textSize) {
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:textSize];
    label.font = fnt;
    CGSize size = [ label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    CGFloat nameW = size.width;
    return nameW;
}

#pragma mark - bluetooth
//-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue{}
//-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor{}
//-(void) writeMajorAndMinorThenMajor:(NSString *)UUID writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor{}

#pragma mark - initial major and minor

-(NSString *)getMajor:(NSString *)major{
    
    
    switch (major.length) {
        case 1:
            major = [NSString stringWithFormat:@"%@%@",  @"000",major ];
            break;
            
        case 2:
            major = [NSString stringWithFormat:@"%@%@",  @"00" ,major];
            break;
            
        case 3:
            major = [NSString stringWithFormat:@"%@%@",  @"0", major ];
            break;
        default:
            break;
    }
    
    
    
    return major;
}

-(NSString *)getMinor:(NSString *)minor{
    
    switch (minor.length) {
        case 1:
            minor = [NSString stringWithFormat:@"%@%@",  @"000",minor ];
            break;
            
        case 2:
            minor = [NSString stringWithFormat:@"%@%@", @"00",minor ];
            break;
            
        case 3:
            minor = [NSString stringWithFormat:@"%@%@",  @"0",minor ];
            break;
        default:
            break;
    }
    return minor;
}



@end
