//
//  AccreditViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/19.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AccreditViewController.h"

@interface AccreditViewController ()

@end

@implementation AccreditViewController
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self iv];
    [self lc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --
#pragma mark - 初始化页面元素

/**
 *初始化参数
 */
-(void)iv
{
    
}

/**
 *加载控件
 */
-(void)lc
{
}
@end
