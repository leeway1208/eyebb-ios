//
//  RegViewController.m
//  EyeBB
//
//  Created by Evan on 15/2/23.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "RegViewController.h"
#import "CommonUtils.h"
#import "WelcomeViewController.h"
#import "JSONKit.h"
#import "ChildInformationMatchingViewController.h"

@interface RegViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    int textHeight;
}
//注册列表
@property (nonatomic,strong) UITableView * regTView;

//用户名输入框
@property (nonatomic,strong) UITextField *telTxt;
//昵称输入框
@property (nonatomic,strong) UITextField *nicknameTxt;
//密码输入框
@property (nonatomic,strong) UITextField *pDTxt;
//验证密码输入框
@property (nonatomic,strong) UITextField *verifyTxt;

//邮箱输入框
@property (nonatomic,strong) UITextField *emailTxt;

/**pop view*/
@property (strong,nonatomic) UIScrollView * PopupSView;
/**image view of pop view*/
@property (strong,nonatomic) UIImageView * popUpImage;
/**pop view container*/
@property (strong,nonatomic) UIView * popViewContainer;
/**pop view confirm button*/
@property (strong,nonatomic) UIButton * confirmBtn;

/**pop view cancel button*/
@property (strong,nonatomic) UIButton * cancelBtn;
/**pop view title*/
@property (strong,nonatomic) UILabel * popTitleLabel;
/**pop view content*/
@property (strong,nonatomic) UILabel * popContentLabel;
@end

@implementation RegViewController


#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
//    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"arrow_gobigleft.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(regViewLeftAction:)];
    
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.title = LOCALIZATION(@"btn_sign_up");
    
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self iv];
    [self lc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
    [_regTView removeFromSuperview];
    [_telTxt removeFromSuperview];
    [_nicknameTxt removeFromSuperview];
    [_pDTxt removeFromSuperview];
    [_verifyTxt removeFromSuperview];
    [_emailTxt removeFromSuperview];
    [_PopupSView removeFromSuperview];
    [_popUpImage removeFromSuperview];
    [_popViewContainer removeFromSuperview];
    [_confirmBtn removeFromSuperview];
    [_cancelBtn removeFromSuperview];
    [_popTitleLabel removeFromSuperview];
    [_popContentLabel removeFromSuperview];
    [self.view removeFromSuperview];
    [self setRegTView:nil];
    [self setTelTxt:nil];
    [self setNicknameTxt:nil];
    [self setPDTxt:nil];
    [self setVerifyTxt:nil];
    [self setEmailTxt:nil];
    [self setPopupSView:nil];
    [self setPopUpImage:nil];
    [self setPopViewContainer:nil];
    [self setConfirmBtn:nil];
    [self setCancelBtn:nil];
    [self setPopTitleLabel:nil];
    [self setPopContentLabel:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];

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
    //设置table是否可以滑动
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
    //注册键盘弹起与收起通知
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
    
    
    
    //------------------------遮盖层------------------------
    
    //Popping view when you sign up successfully
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    
    _popViewContainer=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-140, Drive_Wdith-10, 176)];
    [_popViewContainer setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_popViewContainer.layer setMasksToBounds:YES];
    //圆角像素化
    [_popViewContainer.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_popViewContainer];
    
    
    //pop image view
    _popUpImage=[[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetHeight(_popViewContainer.frame)/2 - 20, 45, 45)];
    [_popUpImage setImage:[UIImage imageNamed:@"Image"]];
    [_popUpImage setTag:105];
    [_popViewContainer addSubview:_popUpImage];
    
    //confirm button
    _confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_popViewContainer.frame) / 2 , 134 ,CGRectGetWidth(_popViewContainer.frame) / 2, 40)];
    //设置按显示文字
    [_confirmBtn setTitle:LOCALIZATION(@"btn_confirm") forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_confirmBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_confirmBtn addTarget:self action:@selector(goToChildInformationMatchingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_popViewContainer addSubview:_confirmBtn];
    
    //cancel button
    _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0 , 134 ,CGRectGetWidth(_popViewContainer.frame) / 2, 40)];
    //设置按显示文字
    [_cancelBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_cancelBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_cancelBtn addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_popViewContainer addSubview:_cancelBtn];
    
    //pop title label
    _popTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_popViewContainer.frame)/2 -10 ,12,CGRectGetWidth(_popViewContainer.frame),20)];
    _popTitleLabel.text = LOCALIZATION(@"text_tips");
    [_popTitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_popViewContainer addSubview:_popTitleLabel];
    
    
    //pop centent label
    _popContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_popViewContainer.frame)/2 - 55 ,CGRectGetHeight(_popViewContainer.frame)/2 - 10 ,CGRectGetWidth(_popViewContainer.frame),20)];
    _popContentLabel.text = LOCALIZATION(@"text_binding_device");
    [_popViewContainer addSubview:_popContentLabel];
    
    //pop view dividing top line
    UILabel * popTopLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_popViewContainer.frame)/2 + 45, CGRectGetWidth(_popViewContainer.frame) - 20, 1)];
    [popTopLabel.layer setBorderWidth:1.0]; //边框宽度
    [popTopLabel.layer setBorderColor:[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3].CGColor];
    [_popViewContainer addSubview:popTopLabel];
    
    //pop view dividing bottom line
    UILabel * popBottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_popViewContainer.frame)/2 - 45, CGRectGetWidth(_popViewContainer.frame) - 20, 1)];
    [popBottomLabel.layer setBorderWidth:1.0]; //边框宽度
    [popBottomLabel.layer setBorderColor:[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3].CGColor];
    [_popViewContainer addSubview:popBottomLabel];
    
    //pop view dividing button line
    UILabel * buttonLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_popViewContainer.frame)/2, CGRectGetHeight(_popViewContainer.frame)/2 + 45, 1, CGRectGetHeight(_popViewContainer.frame)/2 - 20)];
    [buttonLabel.layer setBorderWidth:1.0]; //边框宽度
    [buttonLabel.layer setBorderColor:[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3].CGColor];
    [_popViewContainer addSubview:buttonLabel];
}
/*-----------------------信息处理函数---------------------------------*/

#pragma mark-
#pragma mark--页面信息处理
/**
 *	@brief	验证信息
 *
 */
- (NSString *)verifyRequest:(NSString *)phone withpwd:(NSString *)pwd withver:(NSString *)ver withNickName:(NSString *)nickName withemail:(NSString *)email
{
    NSString * mag=nil;//返回变量值
    
    if(phone.length <= 0)
    {
        mag=LOCALIZATION(@"text_error_username");
        return mag;
    }
    //    if([pub isMobileNumber:phone]==NO)
    //    {
    //        mag=@"用户名格式不正确";
    //        return mag;
    //    }
    if (nickName.length <= 0) {
        
        mag=LOCALIZATION(@"text_error_nickname");
        return mag;
    }
    if (pwd.length <= 0) {
        
        mag=LOCALIZATION(@"text_error_password");
        return mag;
    }
    if(ver.length <= 0||![pwd isEqualToString:ver])
    {
        mag=LOCALIZATION(@"text_pssword_not_the_same");
        return mag;
    }
    if(email.length>0&&[self validateEmail:email]==NO)
    {
        mag=LOCALIZATION(@"text_error_email");
        return mag;
    }
    return mag;
}

//正则验证邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/**
 *  获取输入框的Y坐标
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.telTxt) {
        textHeight=134;
    }
    if (textField == self.nicknameTxt) {
        textHeight=174;
    }
    if (textField == self.pDTxt) {
        textHeight=214;
    }
    if (textField == self.verifyTxt) {
        textHeight=254;
    }
    if (textField == self.emailTxt) {
        textHeight=334;
    }
}
-(void)BasicRegkeyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    //自适应代码（输入法改变也可随之改变）
    if((Drive_Height-keyboardSize.height-48)<textHeight)
    {
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, -(textHeight-(Drive_Height-keyboardSize.height-48)), self.view.frame.size.width, self.view.frame.size.height);
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
    if (theTextField == self.telTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.nicknameTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.pDTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.emailTxt) {
        [theTextField resignFirstResponder];
    }
    
    if (theTextField == self.verifyTxt) {
        [theTextField resignFirstResponder];
    }
    
    return YES;
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.telTxt resignFirstResponder];
    [self.nicknameTxt resignFirstResponder];
    [self.pDTxt resignFirstResponder];
    [self.verifyTxt resignFirstResponder];
    [self.emailTxt resignFirstResponder];
    
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
        num=4;
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
                _telTxt.placeholder=LOCALIZATION(@"text_phone_number");//默认显示的字
                
                _telTxt.text=@"testUser3";
                
                
                _telTxt.secureTextEntry=NO;//设置成密码格式
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
                
                _nicknameTxt.text=@"testUser3";
                
                _nicknameTxt.placeholder=LOCALIZATION(@"text_nick_name");//默认显示的字
                _nicknameTxt.secureTextEntry=NO;//设置成密码格式
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
                _pDTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _pDTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _pDTxt.leftView=imgV;//设置输入框内左边的图标
                _pDTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _pDTxt.leftViewMode=UITextFieldViewModeAlways;
                _pDTxt.placeholder=LOCALIZATION(@"text_password");//默认显示的字
                
                _pDTxt.text=@"111111";
                
                _pDTxt.secureTextEntry=YES;//设置成密码格式
                _pDTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _pDTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _pDTxt.delegate=self;//设置委托
                _pDTxt.tag=103;
                [cell addSubview:_pDTxt];
                
                UILabel * PDLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 39, self.view.frame.size.width-30, 1)];
                [PDLbl.layer setBorderWidth:1.0]; //边框宽度
                [PDLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
                
                [cell addSubview:PDLbl];
            }
        }
        else if(indexPath.row==3)
        {
            if ([cell viewWithTag:106]==nil) {
                _verifyTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _verifyTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _verifyTxt.leftView=imgV;//设置输入框内左边的图标
                _verifyTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _verifyTxt.leftViewMode=UITextFieldViewModeAlways;
                _verifyTxt.placeholder=LOCALIZATION(@"text_verify");//默认显示的字
                
                _verifyTxt.text=@"111111";
                
                _verifyTxt.secureTextEntry=YES;//设置成密码格式
                _verifyTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _verifyTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _verifyTxt.delegate=self;//设置委托
                _verifyTxt.tag=106;
                [cell addSubview:_verifyTxt];
                
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
                _emailTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
                _emailTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"20150207105906"]];
                _emailTxt.leftView=imgV;//设置输入框内左边的图标
                _emailTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _emailTxt.leftViewMode=UITextFieldViewModeAlways;
                _emailTxt.placeholder=LOCALIZATION(@"text_email");//默认显示的字
                _emailTxt.secureTextEntry=NO;//设置成密码格式
                _emailTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _emailTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _emailTxt.delegate=self;//设置委托
                _emailTxt.tag=104;
                [cell addSubview:_emailTxt];
                
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
                [RegBtn setTitle:LOCALIZATION(@"btn_sign_up") forState:UIControlStateNormal];
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

#pragma mark - server return

-(void) requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    if ([tag isEqualToString:REG_PARENTS]){
        NSData *responseData = [request responseData];
        //                NSString *aString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString * resSignUp = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"sign up ----> %@ ",resSignUp);
        
        //user name is already used
        if([resSignUp isEqualToString:SERVER_RETURN_F]){
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_username_is_used")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
        // network is error
        else if ([resSignUp length] > 20){
            
            if([resSignUp isEqualToString:SERVER_RETURN_F]){
                [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                            message:LOCALIZATION(@"text_network_error")
                                           delegate:self
                                  cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                                  otherButtonTitles:nil] show];
            }
            //register is successful
            
        } else{
            
            [_PopupSView setHidden:NO];
            
        }
        
        
    }
}


#pragma mark - 点击事件

/**提交注册信息*/
-(void)regAction:(id)sender
{
    NSString *phoneStr = [self.telTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *NickNameStr= [self.nicknameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwdStr = [self.pDTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *varStr = [self.verifyTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *emailStr = [self.emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self verifyRequest:phoneStr withpwd:[CommonUtils getSha256String:pwdStr] withver:[CommonUtils getSha256String:pwdStr] withNickName:NickNameStr withemail:emailStr]!=nil)
    {
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:[self verifyRequest:phoneStr withpwd:[CommonUtils getSha256String:pwdStr] withver:varStr withNickName:NickNameStr withemail:emailStr]
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    else
    {
        if(emailStr==nil)emailStr=@"";
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:phoneStr, REG_PARENTS_KEY_ACCNAME, NickNameStr,REG_PARENTS_KEY_NAME,[CommonUtils getSha256String:pwdStr].uppercaseString,REG_PARENTS_KEY_PASSWORD,emailStr,REG_PARENTS_KEY_EMAIL,phoneStr,REG_PARENTS_KEY_PHONENUM ,nil];
        
        
        [self postRequest:REG_PARENTS RequestDictionary:tempDoct delegate:self];
        
    }
    
}

/**返回*/
-(void)regViewLeftAction:(id)sender
{
    
    WelcomeViewController *wvc = [[WelcomeViewController alloc]init];
    [[self navigationController] pushViewController:wvc animated:YES];
}

-(void)goToChildInformationMatchingAction:(id)sender{
    ChildInformationMatchingViewController *cimm = [[ChildInformationMatchingViewController alloc]init];
    [self.navigationController pushViewController:cimm animated:YES];
    cimm.title = @"";
}

// cancel the button
-(void)btnCancelAction:(id)sender{
    [_PopupSView setHidden:YES];
}

@end
