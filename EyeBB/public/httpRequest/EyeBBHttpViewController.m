//
//  EyeBBHttpViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "EyeBBHttpViewController.h"
#import "ASIHTTPRequest.h"
@interface EyeBBHttpViewController ()

@end

@implementation EyeBBHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark ---
#pragma mark --- 网络数据处理
- (void)requestFinished:(ASIHTTPRequest *)request{}
- (void)requestFailed:(ASIHTTPRequest *)request{}
@end
