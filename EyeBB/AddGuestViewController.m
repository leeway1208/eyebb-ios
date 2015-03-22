//
//  AddGuestViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AddGuestViewController.h"

@interface AddGuestViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    //记录搜索结果数组
    NSArray*_resultArray;
    UITableView*_tableView;
}
/**授权人搜索输入框*/
@property (nonatomic,strong) UITextField *gusetTxt;


/**搜索按钮*/
@property (strong,nonatomic) UIButton * searchBtn;
@end

@implementation AddGuestViewController
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
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
    //实例化数组
    _resultArray=[[NSArray alloc]init];
}

/**
 *加载控件
 */
-(void)lc
{
    self.gusetTxt=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, Drive_Wdith-10, 40)];
    self.gusetTxt.placeholder=LOCALIZATION(@"text_user_name");
    UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_name"]];
    self.gusetTxt.leftView=imgV;//设置输入框内左边的图标
    self.gusetTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    self.gusetTxt.leftViewMode=UITextFieldViewModeAlways;
    self.gusetTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    self.gusetTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    self.gusetTxt.delegate=self;//设置委托
    //    self.gusetTxt.tag=101;
    [self.view addSubview:self.gusetTxt];
    
    UILabel *lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(4, 45, Drive_Wdith-8, 1)];
    lineLbl.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    [self.view addSubview:lineLbl];
    
    self.searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4 , 60 ,Drive_Wdith / 2, 40)];
    //设置按显示文字
    [self.searchBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [self.searchBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮是否圆角
    [self.searchBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [self.searchBtn.layer setCornerRadius:4.0];
    //设置按钮响应事件
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,105,Drive_Wdith,Drive_Height-141) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
    _tableView.sectionIndexColor = [UIColor blueColor];
    //    _tableView.sectionHeaderHeight=108.0f;
    [self.view addSubview:_tableView];
    
    
    
}

#pragma mark --
#pragma mark - table view



// set cells height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


//set the number of cells in one section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}


// set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    //临时装置信息
    
    NSArray *tempArray=[[NSArray alloc]init];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        
        
        UIView * gusetView=[[UIView alloc]initWithFrame:CGRectMake(5, 2, CGRectGetWidth(cell.frame)-10, 58)];
        
        [gusetView setBackgroundColor:[UIColor whiteColor]];
        //设置按钮是否圆角bu
        [gusetView.layer setMasksToBounds:YES];
        //圆角像素化
        [gusetView.layer setCornerRadius:4.0];
        gusetView.tag=101;
        [cell addSubview:gusetView];
        
        //授权人名字
        UILabel * nameLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
        [nameLbl setText:LOCALIZATION(@"text_authorized_to_others")];
        [nameLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [nameLbl setTextColor:[UIColor whiteColor]];
        [nameLbl setTextAlignment:NSTextAlignmentLeft];
        nameLbl.tag=102;
        [gusetView addSubview:nameLbl];
        
        //注册按钮
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.bounds)-125, 10, 120, 36)];
        //设置按显示文字
        [phoneBtn setTitle:LOCALIZATION(@"btn_sign_up") forState:UIControlStateNormal];
        [phoneBtn.titleLabel setFont:[UIFont fontWithName:@"sans-serif-light" size:15.0]];
        //设置按钮背景颜色
        [phoneBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
        //设置按钮响应事件
        [phoneBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
        //设置按钮是否圆角
        [phoneBtn.layer setMasksToBounds:YES];
        //圆角像素化
        [phoneBtn.layer setCornerRadius:4.0];
        phoneBtn.tag=103;
        [gusetView addSubview:phoneBtn];
    }
    UIView * gusetView=(UIView *)[cell viewWithTag:101];
   
    UILabel * nameLbl =(UILabel *)[gusetView viewWithTag:102];
     UIButton * phoneBtn =(UIButton *)[gusetView viewWithTag:103];
    
    [nameLbl setText:LOCALIZATION(@"text_authorized_to_others")];
    [phoneBtn.titleLabel setFont:[UIFont fontWithName:@"sans-serif-light" size:15.0]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}

#pragma mark --
#pragma mark --点击事件
//查询
-(void)searchAction:(id)sender
{
}
@end
