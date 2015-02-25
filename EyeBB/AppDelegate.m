//
//  AppDelegate.m
//  EyeBB
//
//  Created by Evan on 15/2/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import "WelcomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //获取当前系统版本号
    NSString * version = [[UIDevice currentDevice] systemVersion];
    
    NSArray *array = [version componentsSeparatedByString:@"."];
    float systemVersion=[[NSString stringWithFormat:@"%@.%@",[array objectAtIndex:0],[array objectAtIndex:1]]doubleValue];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *welcome = [[ViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:welcome] ; //初始化导航栏控制器
    
    if(systemVersion>=7)
    {
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.365 green:0.365 blue:0.365 alpha:1]];
        
        UIColor * cc = [UIColor whiteColor];
        NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
        
        
        navController.navigationBar.titleTextAttributes = dict;

        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
        
        
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.365 green:0.365 blue:0.365 alpha:1]];
        //        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
        
        
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Arial" size:0.0], UITextAttributeFont,
                                                          nil]];
    
    self.window.rootViewController = navController;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
