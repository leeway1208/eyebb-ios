//
//  KindlistViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "KindlistViewController.h"

@interface KindlistViewController ()<UITableViewDataSource,UITableViewDelegate>
/**兒童列表*/
@property (strong,nonatomic) UITableView * KindlistTView;
@property NSInteger cellHeight;
@end

@implementation KindlistViewController

#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
    [self iv];
    [self lc];
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

    _KindlistTView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _KindlistTView.dataSource = self;
    _KindlistTView.delegate = self;
    //设置table是否可以滑动
    _KindlistTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    _KindlistTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_KindlistTView];
    
}
#pragma mark --
#pragma mark - 表单设置
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//section （标签）标题显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return _cellHeight;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int num=3;
//    if (section==0) {
//        num=4;
//    }
//    else
//    {
//        num=2;
//    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        
        
    }
        if (indexPath.row==0) {
       
            
            
        }
        else if(indexPath.row==1)
        {
                    }
        else if(indexPath.row==2)
        {
                    }
    
    
    return cell;
}


@end
