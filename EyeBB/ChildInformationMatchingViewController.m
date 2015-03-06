//
//  ChildInformationMatchingViewController.m
//  EyeBB
//
//  Created by liwei wang on 4/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "ChildInformationMatchingViewController.h"


@interface ChildInformationMatchingViewController ()
/**kids name*/
@property (nonatomic,strong) UITextField *kidsNameTf;
@property (nonatomic,strong) UILabel *kidsNameLb;
@property (nonatomic,strong) UIImageView *kidsNameImg;

/**kids birthday*/
@property (nonatomic,strong) UIButton *kidsBirthdayBtn;
@property (nonatomic,strong) UILabel *kidsBirthadyLb;
@property (nonatomic,strong) UIImageView *kidsBirthdayImg;

/**kids kindergarten*/
@property (nonatomic,strong) UILabel *kidsKindergartenLb;
@property (nonatomic,strong) UIButton *kidsKindergartenBtn;
@property (nonatomic,strong) UIImageView *kidsKindergartenImg;

/**search button*/
@property (nonatomic,strong) UIButton * searchBtn;

/**action sheet for kids birthady*/
@property(retain,nonatomic)UIActionSheet *actionSheet;

/**action sheet for kids birthady*/
@property(retain,nonatomic)UIDatePicker *datePicker;

@end

@implementation ChildInformationMatchingViewController
#pragma - view control

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loginSelectLeftAction:)];
    self.title = LOCALIZATION(@"text_child_information_matching");
    
    [self loadParameter];
    [self loadWidget];
    
    
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
    
     /**button view*/
    _kidsBirthdayBtn=[[UIButton alloc] initWithFrame:self.view.bounds];
    _kidsBirthdayBtn.frame = CGRectMake(-75, (Drive_Height/4) - 20,self.view.frame.size.width , 40);
    _kidsBirthdayBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    [_kidsBirthdayBtn setTitle:LOCALIZATION(@"text_kid_birthday") forState:UIControlStateNormal];
    [_kidsBirthdayBtn setTitleColor:[UIColor colorWithRed:0.725 green:0.725 blue:0.745 alpha:1]forState:UIControlStateNormal];
    _kidsBirthdayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_kidsBirthdayBtn addTarget:self action:@selector(kidsBirthdayAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kidsBirthdayBtn];
    _kidsBirthdayBtn.tag = 102;
    
      /**image view*/
    _kidsNameImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bday"]];
    _kidsNameImg.frame = CGRectMake(10, (Drive_Height/4) - 10, 20, 20);
    [self.view addSubview:_kidsNameImg];
    
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
    [_kidsKindergartenBtn setTitle:LOCALIZATION(@"text_select_kid_kindergarten") forState:UIControlStateNormal];
    [_kidsKindergartenBtn setTitleColor:[UIColor colorWithRed:0.725 green:0.725 blue:0.745 alpha:1]forState:UIControlStateNormal];
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
    
    
}

-(void)loadParameter{
    
}


#pragma - button action
- (void)loginSelectLeftAction:(id)sender{
    [[self navigationController] pushViewController:nil animated:YES];
}

- (void)searchChildAction:(id)sender{
    
}

- (void)kidsKindergartenAciton:(id)sender{
    
}

- (void)kidsBirthdayAciton:(id)sender{
    
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n";
    _actionSheet =  [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:LOCALIZATION(@"btn_confirm"),nil];
   [_actionSheet showInView:self.view];
    
    
    _datePicker= [[UIDatePicker alloc] init];
    _datePicker.tag = 101;
    _datePicker.datePickerMode = [(UISegmentedControl *)self.navigationItem.titleView selectedSegmentIndex];
    
    
    [_actionSheet addSubview:_datePicker];
   
}




#pragma mark - method of UIActionSheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    
    switch ([(UISegmentedControl *) self.navigationItem.titleView selectedSegmentIndex]) {
        case 0:
            formattor.dateFormat = @"h:mm a";
            break;
        case 1:
            formattor.dateFormat = @"dd MMMM yy";
            break;
        case 2:
            formattor.dateFormat = @"MM/dd/YY h:mm a";
            break;
        case 3:
            formattor.dateFormat = @"HH:mm";
            break;
        default:
            break;
    }
    NSString *timestamp = [formattor stringFromDate:datePicker.date];
    [(UIButton *)[self.view viewWithTag:102] setTitle:timestamp forState:UIControlStateNormal];
    
}

@end




