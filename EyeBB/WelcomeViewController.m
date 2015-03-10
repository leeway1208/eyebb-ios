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
//--test--
#import "KindlistViewController.h"
#import "ChildInformationMatchingViewController.h"
@interface WelcomeViewController ()

@property (nonatomic,strong) RegViewController *reg;
//@property NSArray * arrayOfLanguages;
@end

@implementation WelcomeViewController

#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2)];
    [logoImgView setImage:[UIImage imageNamed:@"logo_en"]];
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
}
//页面显示后执行事件
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString * accNameStr=[userDefaultes objectForKey:LoginViewController_accName];
    NSString * accPdeStr=[userDefaultes objectForKey:LoginViewController_hashPassword];
    
    if (![accNameStr isEqualToString:@""]&&![accPdeStr isEqualToString:@""]) {
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:accNameStr, LOGIN_TO_CHECK_KEY_j_username, accPdeStr ,LOGIN_TO_CHECK_KEY_j_password, nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
        [self postRequest:LOGIN_TO_CHECK RequestDictionary:tempDoct delegate:self];

    }
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
    
}

/**
 *加载控件
 */
-(void)lc
{

    //注册按钮
    UIButton * RegBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), Drive_Height/14*9, (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [RegBtn setTitle:LOCALIZATION(@"btn_sign_up") forState:UIControlStateNormal];
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
    UIButton * LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), Drive_Height/14*10.4, (Drive_Wdith/2), Drive_Wdith/8)];
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
    UILabel * CopyrightLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, Drive_Height-50, self.view.frame.size.width, 20)];
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
    

    LoginViewController *reg = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    reg.title = @"";
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
