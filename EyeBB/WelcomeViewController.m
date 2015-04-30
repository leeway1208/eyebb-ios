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

#import "ChildInformationMatchingViewController.h"
#import "QRCodeViewController.h"
#import "RootViewController.h"
#import "ScanDeviceToBindingViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()<UIGestureRecognizerDelegate>
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
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString* strLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];


    
    
    NSLog(@"当前语言:%@", strLanguage);
    
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    logoImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
    logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
//    [logoImgView setImage:[UIImage imageNamed:@"logo_en"]];
    switch (myDelegate.applanguage) {
        case 0:
           [logoImgView setImage:[UIImage imageNamed:@"logo_cht"]];
            break;
        case 1:
            [logoImgView setImage:[UIImage imageNamed:@"logo_cht"]];
            break;
        case 2:
            [logoImgView setImage:[UIImage imageNamed:@"logo_en"]];
            break;
            
        default:
            break;
    }

    
    
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
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
    
    
    if ([NSDate date]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleModifyListNotification) name:@"modifyListNotification" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeleteListNotification) name:@"deleteListNotification" object:nil];
        //添加本地推送
        //[self scheduleLocalNotification];
    }
    NSLog(@"commit ok");
}

//页面显示后执行事件
-(void)viewDidAppear:(BOOL)animated
{
    if(_myDelegate.appIsFirstStart != YES || _autoLogin)
    {
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        
        NSString * accNameStr=[userDefaultes objectForKey:LoginViewController_accName];
        NSString * accPdeStr=[userDefaultes objectForKey:LoginViewController_hashPassword];
    

        if (accNameStr!=nil&&![accNameStr isEqualToString:@""]&&accPdeStr!=nil&&![accPdeStr isEqualToString:@""]) {
            NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:accNameStr, LOGIN_TO_CHECK_KEY_j_username, accPdeStr ,LOGIN_TO_CHECK_KEY_j_password,[self getAppVersion],LOGIN_TO_CHECK_KEY_appVersion, nil];
            // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
            
            [self postRequest:LOGIN_TO_CHECK RequestDictionary:tempDoct delegate:self];
            //开启加载
            [HUD show:YES];
            
        }
        else
        {
            logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
            RegBtn.hidden=NO;
            LoginBtn.hidden=NO;
            CopyrightLbl.hidden=NO;
        }
        
    }
    else
    {
        logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
        RegBtn.hidden=NO;
        LoginBtn.hidden=NO;
        CopyrightLbl.hidden=NO;
    }

}

// gesture to cancel swipe (use for ios 8)
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]){
        return  NO;
        
    }else{
        return YES;
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

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
//}

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
    _myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    //[CopyrightLbl setText:LOCALIZATION(@"text_policy")];
  
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:LOCALIZATION(@"text_policy")];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    CopyrightLbl.attributedText = content;
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

    RegViewController *reg = [[RegViewController alloc] init];
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
    NSString *responseString = [request responseString];
    if ([tag isEqualToString:LOGIN_TO_CHECK]) {
        NSData *responseData = [request responseData];
        
        
        
        NSDictionary *  guardian = [[responseData mutableObjectFromJSONData] objectForKey:LoginViewController_json_key_guardian];

        
        if(guardian != nil){

            
            //post token
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString * token =  [NSString stringWithFormat:@"%@",[defaults objectForKey:LoginViewController_device_token]];
            NSLog(@"==== %@", [[token stringByReplacingOccurrencesOfString:@" " withString:@""] substringWithRange:NSMakeRange(1, 64)]);
            
            
            
            NSDictionary *tempDoctToken = [NSDictionary dictionaryWithObjectsAndKeys:[[token stringByReplacingOccurrencesOfString:@" " withString:@""] substringWithRange:NSMakeRange(1, 64)], LOGIN_TO_CHECK_KEY_deviceId, @"O" ,LOGIN_TO_CHECK_KEY_type,nil];
            // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
            //sleep(10);
            [self postRequest:POST_TOKEN RequestDictionary:tempDoctToken delegate:self];
      

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
        
       
        
    }else if ([tag isEqualToString:POST_TOKEN]){
        NSData *responseData = [request responseData];
        NSString * resPOST_TOKEN= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"resPOST_TOKEN ---> %@",resPOST_TOKEN);
        
        
        MainViewController *mvc = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mvc animated:YES];
        self.title = @"";
    }

    //关闭加载
    [HUD hide:YES afterDelay:0];
}


- (void)requestFailed:(ASIHTTPRequest *)request  tag:(NSString *)tag
{
    logoImgView.frame=CGRectMake(Drive_Wdith/4, Drive_Wdith/10*3, Drive_Wdith/2, Drive_Wdith/2);
    RegBtn.hidden=NO;
    LoginBtn.hidden=NO;
    CopyrightLbl.hidden=NO;

    //关闭加载
    [HUD hide:YES afterDelay:0];
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@" text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
    
}

#pragma mark - Notification methods

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self lc];
    }
}


- (void)setupNotificationSetting{
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    
    UIMutableUserNotificationAction *justInformAction = [[UIMutableUserNotificationAction alloc] init];
    justInformAction.identifier = @"justInform";
    justInformAction.title = @"YES,I got it.";
    justInformAction.activationMode = UIUserNotificationActivationModeBackground;
    justInformAction.destructive = NO;
    justInformAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *modifyListAction = [[UIMutableUserNotificationAction alloc] init];
    modifyListAction.identifier = @"editList";
    modifyListAction.title = @"Edit list";
    modifyListAction.activationMode = UIUserNotificationActivationModeForeground;
    modifyListAction.destructive = NO;
    modifyListAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *trashAction = [[UIMutableUserNotificationAction alloc] init];
    trashAction.identifier = @"trashAction";
    trashAction.title = @"Delete list";
    trashAction.activationMode = UIUserNotificationActivationModeBackground;
    trashAction.destructive = YES;
    trashAction.authenticationRequired = YES;
    
    NSArray *actionArray = [NSArray arrayWithObjects:justInformAction,modifyListAction,trashAction, nil];
    NSArray *actionArrayMinimal = [NSArray arrayWithObjects:modifyListAction,trashAction, nil];
    
    UIMutableUserNotificationCategory *shoppingListReminderCategory = [[UIMutableUserNotificationCategory alloc] init];
    shoppingListReminderCategory.identifier = @"shoppingListReminderCategory";
    [shoppingListReminderCategory setActions:actionArray forContext:UIUserNotificationActionContextDefault];
    [shoppingListReminderCategory setActions:actionArrayMinimal forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categoriesForSettings = [[NSSet alloc] initWithObjects:shoppingListReminderCategory, nil];
    UIUserNotificationSettings *newNotificationSettings = [UIUserNotificationSettings settingsForTypes:type categories:categoriesForSettings];
    
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:newNotificationSettings];
    }
    
}

- (void)scheduleLocalNotification{
    [self setupNotificationSetting];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:30];;
    localNotification.alertBody = @"Hey, you must go shopping, remember?";
    localNotification.alertAction = @"View List";
    localNotification.category = @"shoppingListReminderCategory";
    localNotification.applicationIconBadgeNumber++;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
