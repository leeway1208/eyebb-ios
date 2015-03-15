//
//  AppDelegate.h
//  EyeBB
//
//  Created by Evan on 15/2/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//判断APP是否第一次启动
@property bool appIsFirstStart;

/**存储孩子信息*/
@property (strong, nonatomic) NSDictionary * childDictionary;
@end

