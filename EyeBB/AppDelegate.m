//
//  AppDelegate.m
//  EyeBB
//
//  Created by Evan on 15/2/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define BACKGROUND_ACTIVE_BRODACAST @"back_ground_active"
//#import "WelcomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize childDictionary;
@synthesize applanguage;
@synthesize childrenBeanArray;
@synthesize userName;
@synthesize allKidsBeanArray;
@synthesize allKidsWithMacAddressBeanArray;
@synthesize antiLostSelectedKidsAy;
@synthesize isBackgroud;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        NSLog(@"第一次启动");
        self.appIsFirstStart = YES;
        NSUserDefaults *refresh = [NSUserDefaults standardUserDefaults];
        [refresh setInteger:5 forKey:@"refreshTime"];
    }
    else{
        self.appIsFirstStart = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
    }
    //获取当前系统版本号
    NSString * version = [[UIDevice currentDevice] systemVersion];
    
    NSArray *array = [version componentsSeparatedByString:@"."];
    float systemVersion=[[NSString stringWithFormat:@"%@.%@",[array objectAtIndex:0],[array objectAtIndex:1]]doubleValue];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //set init view
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    //添加NavBar
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:welcome] ; //初始化导航栏控制器
    //设置navBar属性
    if(systemVersion>=7)
    {
        //navBar背景颜色
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1.0f]];
        
        UIColor * cc = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
        //设置NavBar是否有透明
        navController.navigationBar.translucent = NO;
        welcome.edgesForExtendedLayout = UIRectEdgeNone;
        navController.navigationBar.titleTextAttributes = dict;
        //navBar字体颜色
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
        
        
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1.0f]];
        //        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
        
        
    }
    //设置NavBar的title属性（颜色和字体，字号）
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Arial" size:0.0], UITextAttributeFont,
                                                          nil]];
    
    self.window.rootViewController = navController;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    
    
    
    //set language from user (user may set in the options view)
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *appLanguage = [def valueForKey:EyeBBViewController_userDefaults_userLanguage];
    NSArray * availableLanguagesArray = @[@"en", @"zh-Hans-CN", @"zh-Hant-HK"];
    NSLog(@"arrayOfLanguages (%@)",availableLanguagesArray);
    if([appLanguage isEqualToString:@"zh-Hans-CN"]){
        //zh-Hans-CN   zh-Hant-HK
        [[Localisator sharedInstance] setLanguage:availableLanguagesArray[1]];
        applanguage=1;
    }else if([appLanguage isEqualToString:@"zh-Hant-HK"]){
        [[Localisator sharedInstance] setLanguage:availableLanguagesArray[2]];
        applanguage=2;
    }else{
        [[Localisator sharedInstance] setLanguage:availableLanguagesArray[0]];
        applanguage=0;
    }
    
    
    
    NSLog(@"Registering for push notifications...");
    //if is for ios 8 else if for ios 7 or blow
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert)
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
        
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                         |UIRemoteNotificationTypeSound
                                                         |UIRemoteNotificationTypeAlert)];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
     isBackgroud = true;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       [[NSNotificationCenter defaultCenter] postNotificationName:BACKGROUND_ACTIVE_BRODACAST object:nil];
    isBackgroud = false;
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
}



- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler{
    if ([identifier isEqualToString:@"editList"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyListNotification" object:nil];
    } else if ([identifier isEqualToString:@"trashAction"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteListNotification" object:nil];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"affair.schedule"]) {
        //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
        if (application.applicationState == UIApplicationStateActive) {
   
            
        }
    }
    
    AudioServicesPlaySystemSound(1057);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:LoginViewController_device_token];
    [defaults synchronize];
    
    
    NSLog(@"%@", str);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}





@end
