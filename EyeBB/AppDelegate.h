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

/**存储当前app的语言环境(0为中文简体,1为中文繁体,2为英语)*/
@property int applanguage;

/* enable sound */
@property int appSound;
/* enable vibrate*/
@property int appVibrate;

/**儿童列表*/
@property (strong, nonatomic) NSDictionary * childrenBeanArray;
/**all kids*/
@property (strong, nonatomic) NSMutableArray * allKidsBeanArray;
/**all kids with device*/
@property (strong, nonatomic) NSMutableArray * allKidsWithMacAddressBeanArray;


/* anti lost selected kids */
@property (strong, nonatomic) NSMutableArray * antiLostSelectedKidsAy;

@end

