//
//  ChildrenListViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/11.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "ChildrenListViewController.h"

@interface ChildrenListViewController ()

@end

@implementation ChildrenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化背景图
    [self initBackGroundView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark -functions
-(void)initBackGroundView
{
    Aarray = [[NSMutableArray alloc] initWithObjects:@"+",@"我",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    
    //tableView
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height-44) style:UITableViewStylePlain];
    tableview.tag = 101;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    //searchView
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    tableview.tableHeaderView = searchBar;
    searchBar.showsScopeBar = YES;
    searchBar.placeholder = @"在全部关注中搜索...";
    
    //搜索的时候会有左侧滑动的效果
    searchControl = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchControl.delegate = self;
    searchControl.searchResultsDataSource = self;
    searchControl.searchResultsDelegate = self;
    
}
#pragma -mark -searchbar
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
#pragma -mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strID = @"ID";
    UITableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strID];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"找朋友";
    }else if(indexPath.section ==1 && indexPath.row == 0){
        cell.textLabel.text=@"row";
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"我的资料";
    }
    return nil;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithObjects:UITableViewIndexSearch,@"+",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}

@end
