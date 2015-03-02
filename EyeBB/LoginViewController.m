//
//  LoginViewController.m
//  EyeBB
//
//  Created by liwei wang on 2/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loginSelectLeftAction:)];
    
    
    
    [self loadWidget];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadWidget{
    
    
    //登录按钮
    UIButton * LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), Drive_Height/14*10.4, (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [LoginBtn setTitle:LOCALIZATION(@"btn_login") forState:UIControlStateNormal];
    [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置按钮背景颜色
    [LoginBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [LoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [LoginBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [LoginBtn.layer setCornerRadius:4.0];
    [LoginBtn.layer setBorderWidth:1.0]; //边框宽度
    [LoginBtn.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];//边框颜色
    [self.view addSubview:LoginBtn];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)loginSelectLeftAction:(id)sender
{
    [[self navigationController] pushViewController:nil animated:YES];
}

-(void)loginAction:(id)sender{
    MainViewController *mvc = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
    self.title = @"";
    
}
@end
