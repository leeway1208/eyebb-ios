//
//  LoginViewController.m
//  EyeBB
//
//  Created by liwei wang on 2/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "CommonUtils.h"

#import "JSONKit.h"
#import "UserDefaultsUtils.h"


@interface LoginViewController ()
{
    int textHeight;
    
}
/**user name*/
@property (nonatomic,strong) UITextField *loginUserAccount;
/**user password*/
@property (nonatomic,strong) UITextField *loginPassword;
/**forget password label*/
@property (nonatomic,strong) UIButton *forgetPasswordLabel;
/**use to keep json information*/
@property (nonatomic,strong) NSDictionary * guardian;
/**button*/
@property (nonatomic,strong) UIButton *loginBtn;
/**user name image*/
@property (nonatomic,strong) UIImageView* userAccountImg;
/**user password image*/
@property (nonatomic,strong) UIImageView* passWordImg;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loginSelectLeftAction:)];
  
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loginSelectLeftAction:)];
//
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered  target:self action:@selector(loginSelectLeftAction:)]];
    
    
    [EyeBBViewController setUserLanguge:1];
    
    [self loadParameter];
    [self loadWidget];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
 
    
    [super viewWillDisappear:animated];
}





// gesture to cancel swipe (use for ios 8)
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]){
        return  NO;
        
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init
-(void)viewDidDisappear:(BOOL)animated
{
    [_loginUserAccount removeFromSuperview];
    [_loginPassword removeFromSuperview];
    [_forgetPasswordLabel removeFromSuperview];
    [_loginBtn removeFromSuperview];
    [_userAccountImg removeFromSuperview];
    [_passWordImg removeFromSuperview];
    [self.view removeFromSuperview];
    [self setLoginPassword:nil];
    [self setLoginUserAccount:nil];
    [self setForgetPasswordLabel:nil];
    [self setLoginBtn:nil];
    [self setUserAccountImg:nil];
    [self setPassWordImg:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}


-(void)loadParameter{
    
    _guardian = [[NSDictionary alloc]init];
}

-(void)loadWidget{
    
    /**
     *  button
     */
    //登录按钮
    _loginBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), 80 +(Drive_Wdith/8), (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [_loginBtn setTitle:LOCALIZATION(@"btn_login") forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置按钮背景颜色
    [_loginBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_loginBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_loginBtn.layer setCornerRadius:4.0];
    [_loginBtn.layer setBorderWidth:1.0]; //边框宽度
    [_loginBtn.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];//边框颜色
    [self.view addSubview:_loginBtn];
    
    
    
    /**
     *  login
     */
    
    _loginUserAccount=[[UITextField alloc] initWithFrame:self.view.bounds];
    _loginUserAccount.frame = CGRectMake(10, 10,self.view.frame.size.width - 20 , 40);
    _loginUserAccount.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    _userAccountImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_name"]];
    _userAccountImg.frame = CGRectMake(0, 0, 20, 20);
    
    _loginUserAccount.leftView = _userAccountImg;//设置输入框内左边的图标
    _loginUserAccount.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _loginUserAccount.leftViewMode=UITextFieldViewModeAlways;
    _loginUserAccount.placeholder=LOCALIZATION(@"text_login_account");//默认显示的字
    //测试开发用
    _loginUserAccount.text=@"test";
    _loginUserAccount.secureTextEntry=NO;//设置成密码格式
    _loginUserAccount.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _loginUserAccount.returnKeyType=UIReturnKeyDefault;//返回键的类型
    //[_loginUserAccount becomeFirstResponder];
    [self.view addSubview:_loginUserAccount];
    
    UILabel * accountTelLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, self.view.frame.size.width-20, 1)];
    [accountTelLbl.layer setBorderWidth:1.0]; //边框宽度
    [accountTelLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
    
    [self.view  addSubview:accountTelLbl];
    
    
    /**
     *  password
     */
    _loginPassword=[[UITextField alloc] initWithFrame:self.view.bounds];
    _loginPassword.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    _loginPassword.frame = CGRectMake(10, 65,self.view.frame.size.width - 20, 40);
    _passWordImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pw"]];
    _passWordImg.frame = CGRectMake(0, 0, 20, 20);
    _loginPassword.leftView = _passWordImg;//设置输入框内左边的图标
    _loginPassword.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _loginPassword.leftViewMode=UITextFieldViewModeAlways;
    _loginPassword.placeholder=LOCALIZATION(@"text_password");//默认显示的字
    //测试开发用
    _loginPassword.text=@"000000";
    _loginPassword.secureTextEntry = YES;//设置成密码格式
    _loginPassword.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _loginPassword.returnKeyType=UIReturnKeyDefault;//返回键的类型
    [self.view addSubview:_loginPassword];
    
    UILabel * passWordTelLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 1)];
    [passWordTelLbl.layer setBorderWidth:1.0]; //边框宽度
    [passWordTelLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
    
    [self.view  addSubview:passWordTelLbl];
    
    
    // forget password label
    _forgetPasswordLabel=[[UIButton alloc] initWithFrame:self.view.bounds];
    
    _forgetPasswordLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [_forgetPasswordLabel setTitle:LOCALIZATION(@"text_forgot_password") forState:UIControlStateNormal];
    [_forgetPasswordLabel setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    _forgetPasswordLabel.frame = CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), 120+(Drive_Wdith/8), (Drive_Wdith/2), Drive_Wdith/8);
    
    [self.view  addSubview:_forgetPasswordLabel];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BasicRegkeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BasicRegkeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}

#pragma mark - keyboard
-(void)BasicRegkeyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    //自适应代码（输入法改变也可随之改变）
    
    if((Drive_Height-keyboardSize.height-48)<textHeight)
    {
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, -80.0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)BasicRegkeyboardWillHide:(NSNotification *)note
{
    
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if((Drive_Height-keyboardSize.height-48)<textHeight)
    {
        //还原
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}
/**
 *	@brief	设置隐藏键盘
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.loginUserAccount) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.loginPassword) {
        [theTextField resignFirstResponder];
    }
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.loginUserAccount) {
        textHeight=90;
    }
    if (textField == self.loginPassword) {
        textHeight=145;
    }
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.loginUserAccount resignFirstResponder];
    [self.loginPassword resignFirstResponder];
}


#pragma mark - button action
/**
 *  the left button of navigation bar
 *
 *  @param sender <#sender description#>
 */
-(void)loginSelectLeftAction:(id)sender
{
    
    [[self navigationController] pushViewController:nil animated:YES];
    
}


-(void)loginAction:(id)sender{
    
 
    
    NSString *userAccount = [self.loginUserAccount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *hashUserPassword= [self.loginPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self verifyRequest:userAccount withpwd:hashUserPassword]!=nil)
    {
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:[self verifyRequest:userAccount withpwd:[CommonUtils getSha256String:hashUserPassword]]
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    else
    {
        
        
        //开启加载
        [HUD show:YES];
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:userAccount, LOGIN_TO_CHECK_KEY_j_username, [CommonUtils getSha256String:hashUserPassword].uppercaseString ,LOGIN_TO_CHECK_KEY_j_password, nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
        [self postRequest:LOGIN_TO_CHECK RequestDictionary:tempDoct delegate:self];
        
        
    }
    
    
}


#pragma mark - server request
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    //关闭加载
    [HUD hide:YES afterDelay:0];
    if ([tag isEqualToString:LOGIN_TO_CHECK]) {
        NSData *responseData = [request responseData];
        
        
        
        _guardian = [[responseData mutableObjectFromJSONData] objectForKey:LoginViewController_json_key_guardian];
        NSString * registrationId = [[responseData mutableObjectFromJSONData] objectForKey:LoginViewController_json_key_registrationId];
        // NSLog(@"login ----> %@ ",guardian);
        
        if(_guardian != nil){
            //save to the UserDefaults
            if([self saveNSUserDefaults:_guardian RegistrationId:registrationId]){
                
                MainViewController *mvc = [[MainViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
                self.title = @"";
            }
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
#pragma mark - check the string
/**
 *  verify the password and username whether is null or not.
 *
 *  @param userAccount userAccount description
 *  @param passWord    <#passWord description#>
 *
 *  @return <#return value description#>
 */

- (NSString *)verifyRequest:(NSString *)userAccount withpwd:(NSString *)passWord
{
    NSString * mag=nil;//返回变量值
    
    if(userAccount.length <= 0)
    {
        mag=LOCALIZATION(@"toast_invalid_username_or_password");
        return mag;
    }
    if (passWord.length <= 0) {
        
        mag=LOCALIZATION(@"toast_invalid_username_or_password");
        return mag;
    }
    
    return mag;
}

#pragma mark- save the login status (userDefault)
/**
 * save the login status
 */
-(BOOL)saveNSUserDefaults:(NSDictionary *)guardian RegistrationId
                         :(NSString *)registrationId
{
    NSUserDefaults *loginStatus = [NSUserDefaults standardUserDefaults];
    // NSLog(@"login sss----> %@ ",guardian);
    
    NSLog(@"login ----> %@ ",[guardian objectForKey:@"name"]);
    [loginStatus setObject:[guardian objectForKey:LoginViewController_accName] forKey:LoginViewController_accName];
    [loginStatus setInteger:[[guardian objectForKey:LoginViewController_guardianId] intValue] forKey:LoginViewController_guardianId];
    [loginStatus setObject:[guardian objectForKey:LoginViewController_name] forKey:LoginViewController_name];
    [loginStatus setInteger:[[guardian objectForKey:LoginViewController_phoneNumber] intValue] forKey:LoginViewController_phoneNumber];
    [loginStatus setObject:[guardian objectForKey:LoginViewController_type] forKey:LoginViewController_type];
    
    [loginStatus setObject:registrationId forKey:LoginViewController_registrationId];
    //password
    NSString *hashUserPassword= [self.loginPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [loginStatus setObject:[CommonUtils getSha256String:hashUserPassword].uppercaseString  forKey:LoginViewController_hashPassword];
    
    return [loginStatus synchronize];
    
    
}


@end
