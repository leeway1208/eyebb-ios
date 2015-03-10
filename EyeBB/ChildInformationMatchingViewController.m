//
//  ChildInformationMatchingViewController.m
//  EyeBB
//
//  Created by liwei wang on 4/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "ChildInformationMatchingViewController.h"
#import "KindergartenListViewController.h"
#import "UserDefaultsUtils.h"

@interface ChildInformationMatchingViewController ()
/**kids name*/
@property (nonatomic,strong) UITextField *kidsNameTf;
@property (nonatomic,strong) UILabel *kidsNameLb;
@property (nonatomic,strong) UIImageView *kidsNameImg;

/**kids birthday*/
//@property (nonatomic,strong) UIButton *kidsBirthdayBtn;
@property (nonatomic,strong) UITextField *kidsBirthdayBtn;
@property (nonatomic,strong) UILabel *kidsBirthadyLb;
@property (nonatomic,strong) UIImageView *kidsBirthdayImg;

/**kids kindergarten*/
@property (nonatomic,strong) UILabel *kidsKindergartenLb;
@property (nonatomic,strong) UIButton *kidsKindergartenBtn;
@property (nonatomic,strong) UIImageView *kidsKindergartenImg;

/**search button*/
@property (nonatomic,strong) UIButton * searchBtn;

/**action sheet for kids birthady*/
@property(retain,nonatomic)UIDatePicker *datePicker;

/**date view container*/
@property (strong,nonatomic) UIView * dateViewContainer;
/**date view container confirm button*/
@property (nonatomic,strong) UIButton *dateViewContainerConfirmBtn;
@end

@implementation ChildInformationMatchingViewController
#pragma mark - view control

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loginSelectLeftAction:)];
    self.title = LOCALIZATION(@"text_child_information_matching");
    
    
    
    
    [self loadWidget];
    
    [self loadParameter];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_kidsNameTf removeFromSuperview];
    [_kidsNameLb removeFromSuperview];
    [_kidsNameImg removeFromSuperview];
    
    [_kidsBirthdayBtn removeFromSuperview];
    [_kidsBirthadyLb removeFromSuperview];
    [_kidsBirthdayImg removeFromSuperview];
    
    [_kidsKindergartenLb removeFromSuperview];
    [_kidsKindergartenBtn removeFromSuperview];
    [_kidsKindergartenImg removeFromSuperview];
    
    [_searchBtn removeFromSuperview];
    [_dateViewContainer removeFromSuperview];
    [_dateViewContainerConfirmBtn removeFromSuperview];
    [self.view removeFromSuperview];
    [self setKidsNameTf:nil];
    [self setKidsNameLb:nil];
    [self setKidsNameImg:nil];
    
    [self setKidsBirthdayBtn:nil];
    [self setKidsBirthadyLb:nil];
    [self setKidsBirthdayImg:nil];
    
    [self setKidsKindergartenLb:nil];
    [self setKidsKindergartenBtn:nil];
    [self setKidsKindergartenImg:nil];
    [self setSearchBtn:nil];
    [self setDateViewContainer:nil];
    [self setDateViewContainerConfirmBtn:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}

-(void)loadWidget{
    
    
    /**
     * kids name view
     */
    
    /**title label*/
    _kidsNameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) - 120, self.view.frame.size.width-20, 20)];
    _kidsNameLb.text = LOCALIZATION(@"text_fill_kid_name");
    [_kidsNameLb setTextColor : [UIColor redColor]];
    [_kidsNameLb setFont: [UIFont systemFontOfSize:14]];
    [self.view  addSubview:_kidsNameLb];
    
    _kidsNameTf=[[UITextField alloc] initWithFrame:self.view.bounds];
    _kidsNameTf.frame = CGRectMake(10, (Drive_Height/4) - 100,self.view.frame.size.width - 20 , 40);
    _kidsNameTf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    _kidsNameImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_name"]];
    _kidsNameImg.frame = CGRectMake(0, 0, 20, 20);
    
    _kidsNameTf.leftView = _kidsNameImg;//设置输入框内左边的图标
    _kidsNameTf.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _kidsNameTf.leftViewMode=UITextFieldViewModeAlways;
    _kidsNameTf.placeholder=LOCALIZATION(@"text_kid_name");//默认显示的字
    _kidsNameTf.secureTextEntry=NO;//设置成密码格式
    _kidsNameTf.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _kidsNameTf.returnKeyType=UIReturnKeyDefault;//返回键的类型
    //[_loginUserAccount becomeFirstResponder];
    [self.view addSubview:_kidsNameTf];
    
    /**Dividing line*/
    UILabel * kidsNameDivLb=[[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) - 59, self.view.frame.size.width-20, 1)];
    [kidsNameDivLb.layer setBorderWidth:1.0]; //边框宽度
    [kidsNameDivLb.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
    
    [self.view  addSubview:kidsNameDivLb];
    
    
    
    
    /*
     *  kids birthday
     */
    /**title label*/
    _kidsBirthadyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) - 40, self.view.frame.size.width-20, 20)];
    _kidsBirthadyLb.text = LOCALIZATION(@"text_select_kid_birthday");
    [_kidsBirthadyLb setTextColor : [UIColor redColor]];
    [_kidsBirthadyLb setFont: [UIFont systemFontOfSize:14]];
    [self.view  addSubview:_kidsBirthadyLb];
    
    /** kids birthday button view */
    _kidsBirthdayBtn=[[UITextField alloc] initWithFrame:self.view.bounds];
    _kidsBirthdayBtn.frame = CGRectMake(10 , (Drive_Height/4) - 20,self.view.frame.size.width , 40);
    _kidsBirthdayBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    NSUserDefaults *childInformation = [NSUserDefaults standardUserDefaults];
    if([childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_dateOfBirth] != nil){
        _kidsBirthdayBtn.text = [childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_dateOfBirth];}
    
    _kidsBirthdayImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bday"]];
    _kidsBirthdayImg.frame = CGRectMake(0, 0, 20, 20);
    
    _kidsBirthdayBtn.leftView = _kidsBirthdayImg;//设置输入框内左边的图标
    _kidsBirthdayBtn.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    _kidsBirthdayBtn.leftViewMode=UITextFieldViewModeAlways;
    _kidsBirthdayBtn.tag = 1001;
    _kidsBirthdayBtn.placeholder=LOCALIZATION(@"text_kid_birthday");//默认显示的字
    _kidsBirthdayBtn.secureTextEntry=NO;//设置成密码格式
    [self.view  addSubview:_kidsBirthdayBtn];
    
    
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
    [self.kidsBirthdayBtn addTarget:self action:@selector(chooseDateTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [_dateViewContainer addSubview:_datePicker];
    _kidsBirthdayBtn.inputView =  self.dateViewContainer;
    
    
    
    
    /**Dividing line*/
    UILabel * kidsBirthdayDivLb=[[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) + 20, self.view.frame.size.width-20, 1)];
    [kidsBirthdayDivLb.layer setBorderWidth:1.0]; //边框宽度
    [kidsBirthdayDivLb.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
    
    [self.view  addSubview:kidsBirthdayDivLb];
    
    
    
    /*
     *  kids kindergarten
     */
    
    /**title label*/
    _kidsKindergartenLb = [[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) + 40, self.view.frame.size.width-20, 20)];
    _kidsKindergartenLb.text = LOCALIZATION(@"text_select_kid_kindergarten");
    [_kidsKindergartenLb setTextColor : [UIColor redColor]];
    [_kidsKindergartenLb setFont: [UIFont systemFontOfSize:14]];
    [self.view  addSubview:_kidsKindergartenLb];
    
    /**kindergarten btn*/
    _kidsKindergartenBtn=[[UIButton alloc] initWithFrame:self.view.bounds];
    _kidsKindergartenBtn.frame = CGRectMake(-15, (Drive_Height/4) + 60,self.view.frame.size.width , 40);
    _kidsKindergartenBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    //NSLog(@"NAMENAME ----> %@",_kindergartenName );
    
    //get the value from the KindergartenListViewController
    if(_kindergartenName != nil){
        [_kidsKindergartenBtn setTitle:_kindergartenName forState:UIControlStateNormal];
        
        [_kidsKindergartenBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    }else{
        [_kidsKindergartenBtn setTitle:LOCALIZATION(@"text_select_kid_kindergarten") forState:UIControlStateNormal];
        [_kidsKindergartenBtn setTitleColor:[UIColor colorWithRed:0.725 green:0.725 blue:0.745 alpha:1]forState:UIControlStateNormal];
    }
    
    
    _kidsKindergartenBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_kidsKindergartenBtn addTarget:self action:@selector(kidsKindergartenAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kidsKindergartenBtn];
    
    /**kindergarten image view*/
    _kidsKindergartenImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_go"]];
    _kidsKindergartenImg.frame = CGRectMake(self.view.frame.size.width - 40, (Drive_Height/4) + 70, 20, 20);
    [self.view addSubview:_kidsKindergartenImg];
    
    
    /**Dividing line*/
    UILabel * kidsKindergartenDivLb=[[UILabel alloc]initWithFrame:CGRectMake(10, (Drive_Height/4) + 101, self.view.frame.size.width-20, 1)];
    [kidsKindergartenDivLb.layer setBorderWidth:1.0]; //边框宽度
    [kidsKindergartenDivLb.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];
    
    [self.view  addSubview:kidsKindergartenDivLb];
    
    
    
    /*
     *  search button
     */
    
    //登录按钮
    _searchBtn =[[UIButton alloc]initWithFrame:CGRectMake((Drive_Wdith/2)-(Drive_Wdith/4), (Drive_Height/4) + 150, (Drive_Wdith/2), Drive_Wdith/8)];
    //设置按显示文字
    [_searchBtn setTitle:LOCALIZATION(@"btn_search_child") forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置按钮背景颜色
    [_searchBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [_searchBtn addTarget:self action:@selector(searchChildAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_searchBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_searchBtn.layer setCornerRadius:4.0];
    [_searchBtn.layer setBorderWidth:1.0]; //边框宽度
    [_searchBtn.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];//边框颜色
    [self.view addSubview:_searchBtn];
    
    
    
    
    //隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}




#pragma mark - loadParameter
-(void)loadParameter{
    NSUserDefaults *childInformation = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"ASDASDAS-_---> %@", [childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_dateOfBirth]);
    if(   [childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_childName] != nil){
        _kidsNameTf.text = [childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_childName];
    }else if([childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_kId] != nil){
        [_kidsKindergartenBtn setTitle:[childInformation objectForKey:ChildInformationMatchingViewController_userDefaults_kId] forState:UIControlStateNormal];
    }
}

#pragma mark - keyboard action
/**
 *	@brief	设置隐藏键盘
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.kidsBirthdayBtn) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.kidsNameTf) {
        [theTextField resignFirstResponder];
    }
    return YES;
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.kidsBirthdayBtn resignFirstResponder];
    [self.kidsNameTf resignFirstResponder];
}

#pragma mark- check the string

- (NSString *)verifyRequest:(NSString *)childName dateOfBirth:(NSString *)dateOfBirth kId:(NSString *)kId

{
    NSString * mag=nil;//返回变量值
    
    if(childName.length <= 0)
    {
        mag=LOCALIZATION(@"text_something_has_gone_wrong");
        return mag;
    }
    if (dateOfBirth.length <= 0) {
        
        mag=LOCALIZATION(@"text_something_has_gone_wrong");
        return mag;
    }
    if (kId != nil) {
        
        mag=LOCALIZATION(@"text_something_has_gone_wrong");
        return mag;
    }
    
    return mag;
}

#pragma - button action
- (void)loginSelectLeftAction:(id)sender{
    [[self navigationController] pushViewController:nil animated:YES];
}

- (void)searchChildAction:(id)sender{
    //Remove spaces at both ends
    //03-10 11:42:54.054: I/System.out(16330): username=>k 10/3/2015 2
    NSString *childName = [self.kidsNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *dateOfBirth= [self.kidsBirthdayBtn.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *kId= _kindergartenId;
    
    NSLog(@"time --- > %@", kId);
    
    if([self verifyRequest:childName dateOfBirth:dateOfBirth kId:kId] != nil){
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_something_has_gone_wrong")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }else{
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:childName, ChildInformationMatchingViewController_KEY_childName, dateOfBirth,ChildInformationMatchingViewController_KEY_dateOfBirth,kId,ChildInformationMatchingViewController_KEY_kId,nil];
        
        
        [self postRequest:CHILD_CHECKING RequestDictionary:tempDoct delegate:self];
        
        
    }
}




- (void)kidsKindergartenAciton:(id)sender{
    
    if([self saveNSUserDefaults:[self.kidsNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] dateOfBirth:[self.kidsBirthdayBtn.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] kId:_kindergartenId]){
        KindergartenListViewController *reg = [[KindergartenListViewController alloc] init];
        [self.navigationController pushViewController:reg animated:YES];
        reg.title = @"";
    }
    
    
    
}

- (void)kidsKindergartenContainerConfirmAciton:(id)sender{
    
    [_kidsBirthdayBtn resignFirstResponder];
    
}

#pragma mark - server return

-(void) requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    if ([tag isEqualToString:CHILD_CHECKING]){
        
        NSData *responseData = [request responseData];
        
        NSString *aString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"CHILD_CHECKING ----> %@ ",aString);
    }
    
    
}



#pragma mark - method of UIDatePicker

- (void)chooseDateValueChanged:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"dd/MM/YYYY";
    
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.kidsBirthdayBtn.text = dateString;
}

- (void)chooseDateTouchDown:(UIDatePicker *)sender {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"YYYY-MM-dd";
    formatter.dateFormat = @"dd/MM/YYYY";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.kidsBirthdayBtn.text = dateString;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //如果当前要显示的键盘，那么把UIDatePicker（如果在视图中）隐藏
    if (textField.tag != 1001) {
        if (self.datePicker.superview) {
            [self.datePicker removeFromSuperview];
        }
        return YES;
    }
    
    //UIDatePicker以及在当前视图上就不用再显示了
    if (self.datePicker.superview == nil) {
        //close all keyboard or data picker visible currently
        [self.kidsBirthdayBtn resignFirstResponder];
        
        //此处将Y坐标设在最底下，为了一会动画的展示
        self.datePicker.frame = CGRectMake(0, Drive_Height, Drive_Wdith, 216);
        [self.view addSubview:self.datePicker];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        // self.datePicker.frame -= self.datePicker.frame.size.height;
        [UIView commitAnimations];
    }
    
    return NO;
}


#pragma mark- save the child information (userDefault)
/**
 * save the child information
 */
-(BOOL)saveNSUserDefaults:(NSString *)childName dateOfBirth
                         :(NSString *)dateOfBirth kId
                         :(NSString *)kId
{
    NSUserDefaults *childInformation = [NSUserDefaults standardUserDefaults];
    // NSLog(@"login sss----> %@ ",guardian);
    
    
    [childInformation setObject:childName forKey:ChildInformationMatchingViewController_userDefaults_childName];
    [childInformation setObject:dateOfBirth forKey:ChildInformationMatchingViewController_userDefaults_dateOfBirth];
    [childInformation setObject:kId forKey:ChildInformationMatchingViewController_userDefaults_kId];
    
    
    return [childInformation synchronize];
    
    
}

@end




