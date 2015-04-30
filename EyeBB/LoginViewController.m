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


@interface LoginViewController ()<UITextFieldDelegate>
{
    int textHeight;
    
}
/**user name*/
@property (nonatomic,strong) UITextField *loginUserAccount;
/**user password*/
@property (nonatomic,strong) UITextField *loginPassword;
@property (nonatomic,strong) UITextField * nameTxt;
@property (nonatomic,strong) UITextField * KidNameTxt;
@property (nonatomic,strong) UITextField * BirthTxt;
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



/**弹出框*/
@property (strong,nonatomic) UIScrollView * PopupSView;
/**列表显示模式容器*/
@property (strong,nonatomic) UIView * FindPDView;
//单击空白处关闭遮盖层
//@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

/**action sheet for kids birthady*/
@property(retain,nonatomic)UIDatePicker *datePicker;

/**date view container*/
@property (strong,nonatomic) UIView * dateViewContainer;
/**date view container confirm button*/
@property (nonatomic,strong) UIButton *dateViewContainerConfirmBtn;
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
    
    //[self setUserLanguge:1];
    
  

    
    [self loadParameter];
    [self loadWidget];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
 
    
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
   // _loginUserAccount.text=@"test";
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
   // _loginPassword.text=@"000000";
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
    [_forgetPasswordLabel addTarget:self action:@selector(showFindPDAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    //------------------------遮盖层------------------------
    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    //单击空白处关闭遮盖层
//    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    self.singleTap.delegate = self;
    
//    [_PopupSView addGestureRecognizer:self.singleTap];
    
    //找回密码
    _FindPDView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-138, Drive_Wdith-10, 236)];
    [_FindPDView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_FindPDView.layer setMasksToBounds:YES];
    //圆角像素化
    [_FindPDView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_FindPDView];
    
    //设定title
    UILabel *listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(_FindPDView.frame), 30)];
    [listtitleLal setText:LOCALIZATION(@"text_forgetPassword")];
    [listtitleLal setTextColor:[UIColor redColor]];
    [listtitleLal setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [listtitleLal setTextAlignment:NSTextAlignmentCenter];
    [listtitleLal setBackgroundColor:[UIColor clearColor]];
    [_FindPDView addSubview:listtitleLal];
    listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, CGRectGetWidth(_FindPDView.frame), 60)];
    listtitleLal.numberOfLines=0;
    [listtitleLal setText:LOCALIZATION(@"text_forgetPassword_details")];
    [listtitleLal setTextColor:[UIColor blackColor]];
    [listtitleLal setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [listtitleLal setTextAlignment:NSTextAlignmentCenter];
    [listtitleLal setBackgroundColor:[UIColor clearColor]];
    [_FindPDView addSubview:listtitleLal];
    
    _nameTxt=[[UITextField alloc]initWithFrame:CGRectMake(10, 85, CGRectGetWidth(_FindPDView.frame)-20, 30)];
    _nameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    _nameTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _nameTxt.leftViewMode=UITextFieldViewModeAlways;
    _nameTxt.placeholder=LOCALIZATION(@"text_forgetPassword_phone");//默认显示的字
    _nameTxt.secureTextEntry=NO;//设置成密码格式
    _nameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _nameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    _nameTxt.delegate=self;//设置委托
    CGRect frame = [_nameTxt frame];  //为你定义的UITextField
    frame.size.width = 5;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
  
    _nameTxt.leftView = leftview;
    [_nameTxt.layer setBorderWidth:2.0]; //边框宽度
    [_nameTxt.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    //设置按钮是否圆角
    [_nameTxt.layer setMasksToBounds:YES];
    //圆角像素化
    [_nameTxt.layer setCornerRadius:4.0];
    [_FindPDView addSubview:_nameTxt];
    
    _KidNameTxt=[[UITextField alloc]initWithFrame:CGRectMake(10, 120, CGRectGetWidth(_FindPDView.frame)-20, 30)];
    _KidNameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    CGRect KidNameTxtframe = [_KidNameTxt frame];  //为你定义的UITextField
    KidNameTxtframe.size.width = 5;
    UIView *KidNameTxtframeleftview = [[UIView alloc] initWithFrame:KidNameTxtframe];
    
    _KidNameTxt.leftView = KidNameTxtframeleftview;
    _KidNameTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _KidNameTxt.leftViewMode=UITextFieldViewModeAlways;
    _KidNameTxt.placeholder=LOCALIZATION(@"text_forgetPassword_child_name");//默认显示的字
    _KidNameTxt.secureTextEntry=NO;//设置成密码格式
    _KidNameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _KidNameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    _KidNameTxt.delegate=self;//设置委托
    [_KidNameTxt.layer setBorderWidth:2.0]; //边框宽度
    [_KidNameTxt.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    //设置按钮是否圆角
    [_KidNameTxt.layer setMasksToBounds:YES];
    //圆角像素化
    [_KidNameTxt.layer setCornerRadius:4.0];
    [_FindPDView addSubview:_KidNameTxt];
    
    _BirthTxt=[[UITextField alloc]initWithFrame:CGRectMake(10, 155, CGRectGetWidth(_FindPDView.frame)-20, 30)];
    _BirthTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    //_BirthTxt.leftView = leftview;
    _BirthTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _BirthTxt.leftViewMode=UITextFieldViewModeAlways;
    _BirthTxt.placeholder=LOCALIZATION(@"text_forgetPassword_child_birthday");//默认显示的字
    _BirthTxt.secureTextEntry=NO;//设置成密码格式
    _BirthTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _BirthTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    _BirthTxt.delegate=self;//设置委托
    [_BirthTxt.layer setBorderWidth:2.0]; //边框宽度
    [_BirthTxt.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    CGRect BirthTxtframe = [_BirthTxt frame];  //为你定义的UITextField
    BirthTxtframe.size.width = 5;
    UIView *BirthTxtleftview = [[UIView alloc] initWithFrame:BirthTxtframe];
    
    _BirthTxt.leftView = BirthTxtleftview;
    //设置按钮是否圆角
    [_BirthTxt.layer setMasksToBounds:YES];
    //圆角像素化
    [_BirthTxt.layer setCornerRadius:4.0];
    [_FindPDView addSubview:_BirthTxt];
    
    
    //取消按钮
    UIButton * cencelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 194,CGRectGetWidth(_FindPDView.frame)/2, 40)];
    //设置按显示文字
    [cencelBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
    [cencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cencelBtn setImage:[UIImage imageNamed:@"cross2"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [cencelBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [cencelBtn addTarget:self action:@selector(cencelAction) forControlEvents:UIControlEventTouchUpInside];
    [cencelBtn.layer setBorderWidth:0.5]; //边框宽度
    [cencelBtn.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    [_FindPDView addSubview:cencelBtn];
    
    //提交按钮
    UIButton * ChangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_FindPDView.frame)/2, 194,CGRectGetWidth(_FindPDView.frame)/2, 40)];
    //设置按显示文字
    [ChangeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [ChangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ChangeBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [ChangeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [ChangeBtn addTarget:self action:@selector(SaveAction) forControlEvents:UIControlEventTouchUpInside];
    [ChangeBtn.layer setBorderWidth:0.5]; //边框宽度
    [ChangeBtn.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    [_FindPDView addSubview:ChangeBtn];
    
    
    /* date view container  */
    _dateViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0, Drive_Height, Drive_Wdith-10, 220)];
    [_dateViewContainer setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_dateViewContainer.layer setMasksToBounds:YES];
    //圆角像素化
    [_dateViewContainer.layer setCornerRadius:4.0];
    //[_PopupSView addSubview:_popViewContainer];
    
    
    /** date view container confirm btn */
    _dateViewContainerConfirmBtn=[[UIButton alloc] initWithFrame:self.view.bounds];
    _dateViewContainerConfirmBtn.frame = CGRectMake(0, 175 ,self.view.frame.size.width , 40);
    _dateViewContainerConfirmBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    [_dateViewContainerConfirmBtn setTitle:LOCALIZATION(@"btn_confirm") forState:UIControlStateNormal];
    [_dateViewContainerConfirmBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    _dateViewContainerConfirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_dateViewContainerConfirmBtn addTarget:self action:@selector(kidsKindergartenContainerConfirmAciton:) forControlEvents:UIControlEventTouchUpInside];
    [_dateViewContainer addSubview:_dateViewContainerConfirmBtn];
    
    
    /**Dividing line for container*/
    UILabel * containerDivLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 170 ,self.view.frame.size.width, 1)];
    [containerDivLb.layer setBorderWidth:1.0]; //边框宽度
    [containerDivLb.layer setBorderColor:[UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:0.8].CGColor];
    
    [_dateViewContainer addSubview:containerDivLb];
    
    /** date picker */
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame =CGRectMake(0, 0, self.view.frame.size.width, 190);
    //this mode just have yyyy-mm-dd
    self.datePicker.datePickerMode = 1;
    
    //button action
    [self.datePicker addTarget:self action:@selector(chooseDateValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_BirthTxt addTarget:self action:@selector(chooseDateTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [_dateViewContainer addSubview:_datePicker];
    _BirthTxt.inputView =  self.dateViewContainer;

    
}
#pragma mark - method of UIDatePicker

- (void)chooseDateValueChanged:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"dd/MM/YYYY";
    
    NSString *dateString = [formatter stringFromDate:selectedDate];
    _BirthTxt.text = dateString;
}

- (void)chooseDateTouchDown:(UIDatePicker *)sender {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"dd/MM/YYYY";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    _BirthTxt.text = dateString;
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
        self.view.frame = CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
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
    if (theTextField == self.nameTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.KidNameTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.BirthTxt) {
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
    if (textField == self.nameTxt) {
        textHeight=(Drive_Height+20)/2-138+115;
    }
    if (textField == self.KidNameTxt) {
        textHeight=(Drive_Height+20)/2-138+150;
    }
    if (textField == self.BirthTxt) {
        textHeight=(Drive_Height+20)/2-138+185;
    }
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.loginUserAccount resignFirstResponder];
    [self.loginPassword resignFirstResponder];
    [_nameTxt resignFirstResponder];
    [_KidNameTxt resignFirstResponder];
    [_BirthTxt resignFirstResponder];
}

- (void)kidsKindergartenContainerConfirmAciton:(id)sender{
    
    [_BirthTxt resignFirstResponder];
    
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
        
        
        //Loding progress bar
        [HUD show:YES];
        
     
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:userAccount, LOGIN_TO_CHECK_KEY_j_username, [CommonUtils getSha256String:hashUserPassword].uppercaseString ,LOGIN_TO_CHECK_KEY_j_password,[self getAppVersion],LOGIN_TO_CHECK_KEY_appVersion,nil];
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
        NSString * resLOGIN_TO_CHECK = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"LOGIN_TO_CHECK %@",resLOGIN_TO_CHECK);
        
        
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
        
    }else if ([tag isEqualToString:RESET_PASSWORD]){
        
        NSData *responseData = [request responseData];
        NSString * resRESET_PASSWORD= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"resRESET_PASSWORD ---> %@",resRESET_PASSWORD);
        
        
        
        if ([resRESET_PASSWORD isEqualToString:SERVER_RETURN_T]) {
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_feed_back_successful")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
            
        }else if ([resRESET_PASSWORD isEqualToString:SERVER_RETURN_F]){
            
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_user_do_not_exist")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
            
        }else if ([resRESET_PASSWORD isEqualToString:SERVER_RETURN_NC]){
            
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_account_user_do_not_have_this_child")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];

            
        }
        
        
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    //关闭加载
    [HUD hide:YES afterDelay:0];
    
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@"text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
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


- (NSString *)verifyForgetPasswordRequest:(NSString *)userName childName:(NSString *)childName childBirthday:(NSString *)childBirthday
{
    NSString * mag=nil;//返回变量值
    
    if(userName.length <= 0)
    {
        mag=LOCALIZATION(@"text_fill_in_something");
        return mag;
    }
    if (childName.length <= 0) {
        
        mag=LOCALIZATION(@"text_fill_in_something");
        return mag;
    }
    if (childBirthday.length <= 0) {
        
        mag=LOCALIZATION(@"text_fill_in_something");
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

-(void)cencelAction
{
    [_PopupSView setHidden:YES];
}
-(void)showFindPDAction
{
    [_PopupSView setHidden:NO];
}

-(void)SaveAction
{
    
    NSString *userName = [_nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *childName= [_KidNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *childBirthday= [_BirthTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"userName (%@) childName (%@) childBirthday(%@) ",userName,childName,childBirthday);
    
    if([self verifyForgetPasswordRequest:userName childName:childName childBirthday:childBirthday] != nil)
    {
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:[self verifyForgetPasswordRequest:userName childName:childName childBirthday:childBirthday]
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    else
    {
        
        
        //Loding progress bar
        [HUD show:YES];
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:userName, LOGIN_TO_CHECK_KEY_accName, childBirthday ,LOGIN_TO_CHECK_KEY_childName,childBirthday,LOGIN_TO_CHECK_KEY_dob,nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
        [self postRequest:RESET_PASSWORD RequestDictionary:tempDoct delegate:self];
        
        
    }

    
}
@end
