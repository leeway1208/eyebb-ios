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
    _cellHeight=120;
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
            if ([cell viewWithTag:101]==nil) {
                UIView * bindView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, _cellHeight-10)];
                
                [bindView setBackgroundColor:[UIColor colorWithRed:0.467 green:0.843 blue:0.639 alpha:1]];
                //设置按钮是否圆角
                [bindView.layer setMasksToBounds:YES];
                //圆角像素化
                [bindView.layer setCornerRadius:4.0];
                bindView.tag=101;
                [cell addSubview:bindView];
                
                //绑定栏目title
                UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
                [bindLbl setText:LOCALIZATION(@"text_bind_child")];
                [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
                [bindLbl setTextColor:[UIColor colorWithRed:0.831 green:0.831 blue:0.827 alpha:1]];
                [bindLbl setTextAlignment:NSTextAlignmentCenter];
                [bindView addSubview:bindLbl];
                
                for (int i=0; i<10; i++) {
                    
                }
            }
            else
            {
                [cell removeFromSuperview];
                for (int i=0; i<10; i++) {
                    
                }
            }
            
            
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
