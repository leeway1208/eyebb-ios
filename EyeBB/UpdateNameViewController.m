//
//  UpdateNameViewController.m
//  EyeBB
//
//  Created by Evan on 15/4/12.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "UpdateNameViewController.h"
#import "CommonUtils.h"
@interface UpdateNameViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    int textHeight;
}
//更新昵称列表
@property (nonatomic,strong) UITableView * updateNameTView;

//昵称输入框
@property (nonatomic,strong) UITextField *NameTxt;
//新密码输入框
@property (nonatomic,strong) UITextField *pDTxt;


@end

@implementation UpdateNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    [self iv];
    [self lc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
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
    
    _updateNameTView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _updateNameTView.dataSource = self;
    _updateNameTView.delegate = self;
    //设置table是否可以滑动
    _updateNameTView.scrollEnabled = NO;
    //隐藏table自带的cell下划线
    _updateNameTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_updateNameTView];
    
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
    
    
}
/*-----------------------信息处理函数---------------------------------*/

#pragma mark-
#pragma mark--页面信息处理


/**
 *	@brief	验证信息
 *
 */
- (NSString *)verifyRequest:(NSString *)Name withpwd:(NSString *)pwd {
    NSString * mag=nil;//返回变量值
    
    if(Name.length <= 0)
    {
        mag=LOCALIZATION(@"text_fill_in_nickname");
        return mag;
    }
    
    if (pwd.length <= 0) {
        
        mag=LOCALIZATION(@"text_fill_in_password");
        return mag;
    }

    
    return mag;
}


/**
 *  获取输入框的Y坐标
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.NameTxt) {
        textHeight=134;
    }
    if (textField == self.pDTxt) {
        textHeight=214;
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
    if (theTextField == self.NameTxt) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.pDTxt) {
        [theTextField resignFirstResponder];
    }

    
    return YES;
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.NameTxt resignFirstResponder];
    [self.pDTxt resignFirstResponder];  
}



#pragma mark --
#pragma mark - 表单设置
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//section （标签）标题显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 40.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:24];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor redColor];
    
    
    labelTitle.text = LOCALIZATION(@"text_update_nickname");
    
    [v addSubview:labelTitle];
    return v;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 100;
    }
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
            _NameTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
            _NameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
            
            UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_test"]];
            _NameTxt.leftView=imgV;//设置输入框内左边的图标
            _NameTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
            _NameTxt.leftViewMode=UITextFieldViewModeAlways;
            _NameTxt.placeholder=LOCALIZATION(@"text_new_nickname");//默认显示的字
            
            _NameTxt.text=@"";
            
            
            _NameTxt.secureTextEntry=NO;//设置成密码格式
            _NameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
            _NameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
            _NameTxt.delegate=self;//设置委托
            _NameTxt.tag=101;
            [cell addSubview:_NameTxt];
            
            UILabel * telLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width-30, 1)];
            [telLbl.layer setBorderWidth:1.0]; //边框宽度
            [telLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
            
            [cell addSubview:telLbl];
        }
        
        
    }
    else if(indexPath.row==1)
    {
        if ([cell viewWithTag:102]==nil) {
            _pDTxt=[[UITextField alloc]initWithFrame:CGRectMake(17, 5, self.view.frame.size.width-34, 30)];
            _pDTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
            
            UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pw"]];
            _pDTxt.leftView=imgV;//设置输入框内左边的图标
            _pDTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
            _pDTxt.leftViewMode=UITextFieldViewModeAlways;
            _pDTxt.placeholder=LOCALIZATION(@"text_password");//默认显示的字
            
            _pDTxt.secureTextEntry=YES;//设置成密码格式
            _pDTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
            _pDTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
            _pDTxt.delegate=self;//设置委托
            _pDTxt.tag=102;
            [cell addSubview:_pDTxt];
            
            UILabel * PDLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 39, self.view.frame.size.width-30, 1)];
            [PDLbl.layer setBorderWidth:1.0]; //边框宽度
            [PDLbl.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
            
            [cell addSubview:PDLbl];
        }
    }
    else if(indexPath.row==2)
    {
        if ([cell viewWithTag:104]==nil) {
            //更新按钮
            UIButton * updateBtn=[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith-(Drive_Wdith/3))/2, 25, Drive_Wdith/3, 35)];
            //设置按显示文字
            [updateBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
            //设置按钮背景颜色
            [updateBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            //设置按钮响应事件
            [updateBtn addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
            //设置按钮是否圆角
            [updateBtn.layer setMasksToBounds:YES];
            //圆角像素化
            [updateBtn.layer setCornerRadius:4.0];
            updateBtn.tag=104;
            [cell addSubview:updateBtn];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
        
    }
    
    
    return cell;
}

#pragma mark - server return

-(void) requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    if ([tag isEqualToString:CHANGE_NICKNAME]){
        NSData *responseData = [request responseData];
        NSString * resUpdate =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"resUpdate---> %@",resUpdate);
        if ([resUpdate isEqualToString:@"T"]) {
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_update_nickname_successful")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_update_server_data_fail")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
    }
}
#pragma mark - 点击事件

/**提交*/
-(void)updateAction:(id)sender
{
    NSString *NameStr= [self.NameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwdStr = [self.pDTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self verifyRequest:NameStr withpwd:pwdStr]!=nil)
    {
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:[self verifyRequest:NameStr withpwd:pwdStr]
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    else
    {
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:NameStr, @"newNickname", [CommonUtils getSha256String:pwdStr].uppercaseString,@"password",nil];
        
        
        
        [self postRequest:CHANGE_NICKNAME RequestDictionary:tempDoct delegate:self];
        
    }
    
}
@end