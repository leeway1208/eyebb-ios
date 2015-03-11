//
//  WelcomeViewController.m
//  EyeBB
//
//  Created by Evan on 15/2/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
//--test--
#import "KindlistViewController.h"
#import "ChildInformationMatchingViewController.h"

#import "RootViewController.h"


@interface WelcomeViewController ()
{
     AppDelegate *myDelegate;
}
//注册按钮
@property (nonatomic,strong) UIButton * RegBtn;
//登录按钮
@property (nonatomic,strong) UIButton * LoginBtn;
//版权信息
@property (nonatomic,strong) UILabel * CopyrightLbl;

@property (nonatomic,strong) UIImageView *logoImgView;

@property (nonatomic,strong) RegViewController *reg;

//@property NSArray * arrayOfLanguages;
@end

@implementation WelcomeViewController
@synthesize RegBtn,LoginBtn,CopyrightLbl,logoImgView;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    logoImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
    logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
//    [logoImgView setImage:[UIImage imageNamed:@"logo_en"]];
    [logoImgView setImage:[UIImage imageNamed:@"test"]];
    
    [self.view addSubview:logoImgView];
//    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"Image"]];
    
    //    self.navigationController.hidesBottomBarWhenPushed=YES;
    
//    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
    //语言转换本地通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [[Localisator sharedInstance] saveInUserDefaults];
    
    [self iv];
    [self lc];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_reg!=nil) {
        _reg=nil;
    }
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Height/2-(Drive_Wdith/4), Drive_Wdith/2, Drive_Wdith/2);
    RegBtn.hidden=YES;
    LoginBtn.hidden=YES;
    CopyrightLbl.hidden=YES;
}
//页面显示后执行事件
-(void)viewDidAppear:(BOOL)animated
{
//    if(myDelegate.appIsFirstStart != YES)
//    {
//        
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        
//        NSString * accNameStr=[userDefaultes objectForKey:LoginViewController_accName];
//        NSString * accPdeStr=[userDefaultes objectForKey:LoginViewController_hashPassword];
//    
//
//        if (accNameStr!=nil&&![accNameStr isEqualToString:@""]&&accPdeStr!=nil&&![accPdeStr isEqualToString:@""]) {
//            NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:accNameStr, LOGIN_TO_CHECK_KEY_j_username, accPdeStr ,LOGIN_TO_CHECK_KEY_j_password, nil];
//            // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
//            
//            [self postRequest:LOGIN_TO_CHECK RequestDictionary:tempDoct delegate:self];
//            
//        }
//        else
//        {
            logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
            RegBtn.hidden=NO;
            LoginBtn.hidden=NO;
            CopyrightLbl.hidden=NO;
//        }
        
//    }
//    else
//    {
//        logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
//        RegBtn.hidden=NO;
//        LoginBtn.hidden=NO;
//        CopyrightLbl.hidden=NO;
//    }

}
-(void)viewDidDisappear:(BOOL)animated
{

    [self.view removeFromSuperview];

    [self setView:nil];
    [super viewDidDisappear:animated];
    //    _regTView=nil;
    //     _telTxt=nil;
    //     _nicknameTxt=nil;
    //     _PDTxt=nil;
    //    self.view=nil;
    

    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
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
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

/**
 *加载控件
 */
-(void)lc
{

    //注册按钮
    RegBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), Drive_Height/14*9, (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [RegBtn setTitle:LOCALIZATION(@"btn_sign_up") forState:UIControlStateNormal];
    [RegBtn.titleLabel setFont:[UIFont fontWithName:@"sans-serif-light" size:15.0]];
    //设置按钮背景颜色
    [RegBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [RegBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [RegBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [RegBtn.layer setCornerRadius:4.0];
    [self.view addSubview:RegBtn];

    
    //登录按钮
    LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), Drive_Height/14*10.4, (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [LoginBtn setTitle:LOCALIZATION(@"btn_login") forState:UIControlStateNormal];
    [LoginBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    
    //设置按钮背景颜色
    [LoginBtn setBackgroundColor:[UIColor whiteColor]];
    //设置按钮响应事件
    [LoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [LoginBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [LoginBtn.layer setCornerRadius:4.0];
    [LoginBtn.layer setBorderWidth:1.0]; //边框宽度
    [LoginBtn.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];//边框颜色
    [self.view addSubview:LoginBtn];

    //版权信息
    CopyrightLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, Drive_Height-50, self.view.frame.size.width, 20)];
    [CopyrightLbl setText:LOCALIZATION(@"text_policy")];
    [CopyrightLbl setFont:[UIFont systemFontOfSize: 10.0]];
    [CopyrightLbl setTextColor:[UIColor colorWithRed:0.831 green:0.831 blue:0.827 alpha:1]];
    [CopyrightLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:CopyrightLbl];

    
}
#pragma mark --
#pragma mark - 点击事件
-(void)regAction:(id)sender
{
//    if ([[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[2]])
//    {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:LOCALIZATION(@"languageChangedWarningMessage") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
    
//        _reg = [[RegViewController alloc] init];
//    
//    
//    [self.navigationController pushViewController:_reg animated:YES];
//    _reg.title = @"";
//    

    ChildInformationMatchingViewController *reg = [[ChildInformationMatchingViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    reg.title = @"";
    
//
    
//    KindlistViewController * dd= [[KindlistViewController alloc] init];
//    
//    
//    [self.navigationController pushViewController:dd animated:YES];
}

-(void)loginAction:(id)sender
{
//    MainViewController*reg = [[MainViewController alloc] init];
//    [self.navigationController pushViewController:reg animated:YES];
//    reg.title = @"";
    
    RootViewController *reg = [[RootViewController alloc] init];
    reg.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:reg animated:YES];
//    reg.title = @"";
    
    
//    LoginViewController *reg = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:reg animated:YES];
//    reg.title = @"";
//    if ([[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[3]])
//    {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:LOCALIZATION(@"languageChangedWarningMessage") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
}

#pragma mark - server request
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    
    if ([tag isEqualToString:LOGIN_TO_CHECK]) {
        NSData *responseData = [request responseData];
        
        
        
        NSDictionary *  guardian = [[responseData mutableObjectFromJSONData] objectForKey:LoginViewController_json_key_guardian];

        
        if(guardian != nil){

                MainViewController *mvc = [[MainViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
                self.title = @"";

        }else{
            logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
            RegBtn.hidden=NO;
            LoginBtn.hidden=NO;
            CopyrightLbl.hidden=NO;
            //if the user name or password is invaild. alerting the user.
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"toast_invalid_username_or_password")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
        
    }
    
}




#pragma mark - Notification methods

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self lc];
    }
}

@end
