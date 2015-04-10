//
//  KidViewController.m
//  EyeBB
//
//  Created by Evan on 15/4/10.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "KidViewController.h"
#import "IIILocalizedIndex.h"
#import "EGOImageView.h"
#import "AppDelegate.h"
@interface KidViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    //数据源数组
    NSMutableArray*_dataArray;
    //数据源数组
    NSMutableArray*_dataArray;
    //记录未搜索结果数组
    NSArray*_resultArray;
    UITableView*_tableView;
    UISearchBar*_searchBar;
    AppDelegate *myDelegate;
}

@end

@implementation KidViewController
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self iv];
    [self lc];
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
