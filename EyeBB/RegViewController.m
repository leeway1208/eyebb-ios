//
//  RegViewController.m
//  EyeBB
//
//  Created by Evan on 15/2/23.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//注册列表
@property (nonatomic,strong) UITableView * regTView;

//用户名输入框
@property (nonatomic,strong) UITextField *telTxt;
//昵称输入框
@property (nonatomic,strong) UITextField *nicknameTxt;
//密码输入框
@property (nonatomic,strong) UITextField *PDTxt;
@end

@implementation RegViewController


#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)viewDidDisappear:(BOOL)animated
{
    [_regTView removeFromSuperview];
    [_telTxt removeFromSuperview];
    [_nicknameTxt removeFromSuperview];
    [_PDTxt removeFromSuperview];
    [self.view removeFromSuperview];
    [self setRegTView:nil];
    [self setTelTxt:nil];
    [self setNicknameTxt:nil];
    [self setPDTxt:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
//    _regTView=nil;
//     _telTxt=nil;
//     _nicknameTxt=nil;
//     _PDTxt=nil;
//    self.view=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    NSLog(@"*** %f,---%F",self.view.bounds.size.height,Drive_Height);
    _regTView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _regTView.dataSource = self;
    _regTView.delegate = self;
    _regTView.scrollEnabled = NO;
    //隐藏table自带的cell下划线
    _regTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_regTView];
//    //版权信息
//    UILabel * CopyrightLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, Drive_Height-50, self.view.frame.size.width, 20)];
//    [CopyrightLbl setText:@"By Continuing, you agree to cur Terms and Privacy Policy."];
//    [CopyrightLbl setFont:[UIFont systemFontOfSize: 10.0]];
//    [CopyrightLbl setTextColor:[UIColor colorWithRed:0.831 green:0.831 blue:0.827 alpha:1]];
//    [CopyrightLbl setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:CopyrightLbl];
//    
//    
//    
  
}

#pragma mark --
#pragma mark - 表单设置
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

////点击右侧索引表项时调用
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    
//    NSString *key = [sectionTitleArray objectAtIndex:index];
//    NSLog(@"sectionForSectionIndexTitle key=%@",key);
//    if (key == UITableViewIndexSearch) {
//        [listTableView setContentOffset:CGPointZero animated:NO];
//        return NSNotFound;
//    }
//    
//    return index;
//}
//section （标签）标题显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 40.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    if (section == 0) {
        
        labelTitle.text = @"用户信息";
        
    }
    else
    {
        labelTitle.text = @"联系信息";
    }
    [v addSubview:labelTitle];
    return v;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==1) {
        return 65;
    }
    else
    {
    return 40;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=3;
    if (section==0) {
        num=3;
    }
    else
    {
        num=2;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
//        cell.tag = indexPath.row;
        
        
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if ([cell viewWithTag:101]==nil) {
                _telTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _telTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _telTxt.leftView=imgV;//设置输入框内左边的图标
                _telTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _telTxt.leftViewMode=UITextFieldViewModeAlways;
                _telTxt.placeholder=@"电话(用户名)";//默认显示的字
                _telTxt.secureTextEntry=YES;//设置成密码格式
                _telTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _telTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _telTxt.delegate=self;//设置委托
                _telTxt.tag=101;
                [cell addSubview:_telTxt];
                
                UILabel * telLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width-30, 1)];
                 [telLbl.layer setBorderWidth:1.0]; //边框宽度
                 [telLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
                
                [cell addSubview:telLbl];
            }
            

        }
        else if(indexPath.row==1)
        {
            if ([cell viewWithTag:102]==nil) {
                _nicknameTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _nicknameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _nicknameTxt.leftView=imgV;//设置输入框内左边的图标
                _nicknameTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _nicknameTxt.leftViewMode=UITextFieldViewModeAlways;
                _nicknameTxt.placeholder=@"昵称";//默认显示的字
                _nicknameTxt.secureTextEntry=YES;//设置成密码格式
                _nicknameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _nicknameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _nicknameTxt.delegate=self;//设置委托
                _nicknameTxt.tag=102;
                [cell addSubview:_nicknameTxt];
                
                UILabel * nicknameLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width-30, 1)];
                [nicknameLbl.layer setBorderWidth:1.0]; //边框宽度
                [nicknameLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
                
                [cell addSubview:nicknameLbl];

            }
        }
        else if(indexPath.row==2)
        {
            if ([cell viewWithTag:103]==nil) {
                _PDTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _PDTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _PDTxt.leftView=imgV;//设置输入框内左边的图标
                _PDTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _PDTxt.leftViewMode=UITextFieldViewModeAlways;
                _PDTxt.placeholder=@"密码";//默认显示的字
                _PDTxt.secureTextEntry=YES;//设置成密码格式
                _PDTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _PDTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _PDTxt.delegate=self;//设置委托
                _PDTxt.tag=103;
                [cell addSubview:_PDTxt];
                
                UILabel * PDLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 39, self.view.frame.size.width-30, 1)];
                [PDLbl.layer setBorderWidth:1.0]; //边框宽度
                [PDLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
                
                [cell addSubview:PDLbl];
            }
        }
    }
    else
    {
        if (indexPath.row==0) {
            if ([cell viewWithTag:104]==nil) {
                _telTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _telTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _telTxt.leftView=imgV;//设置输入框内左边的图标
                _telTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _telTxt.leftViewMode=UITextFieldViewModeAlways;
                _telTxt.placeholder=@"电邮(可选)";//默认显示的字
                _telTxt.secureTextEntry=YES;//设置成密码格式
                _telTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _telTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _telTxt.delegate=self;//设置委托
                _telTxt.tag=104;
                [cell addSubview:_telTxt];
                
                UILabel * PDLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width-30, 1)];
                [PDLbl.layer setBorderWidth:1.0]; //边框宽度
                [PDLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
                
                [cell addSubview:PDLbl];
            }
            
            
        }
        else if(indexPath.row==1)
        {
            
            if ([cell viewWithTag:105]==nil) {
                //注册按钮
                UIButton * RegBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), 25, (Drive_Wdith/2), 35)];
                //设置按显示文字
                [RegBtn setTitle:@"注册" forState:UIControlStateNormal];
                //设置按钮背景颜色
                [RegBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                //设置按钮响应事件
                [RegBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
                //设置按钮是否圆角
                [RegBtn.layer setMasksToBounds:YES];
                //圆角像素化
                [RegBtn.layer setCornerRadius:4.0];
                RegBtn.tag=105;
                [cell addSubview:RegBtn];
                
//                [tableView setSectionIndexColor:[UIColor clearColor]];
//                [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                [tableView setSeparatorColor:[UIColor clearColor]];
//                [tableView setBackgroundView:nil];
//     [cell.textLabel setHighlighted:NO];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            }
        }

    }
    
    
    return cell;
}

#pragma mark --
#pragma mark - 点击事件

/**提交注册信息*/
-(void)regAction:(id)sender
{
    
}

/**返回*/
-(void)selectLeftAction:(id)sender
{
    [[self navigationController] pushViewController:nil animated:YES];
}

@end
