//
//  SettingsViewController.m
//  EyeBB
//
//  Created by liwei wang on 26/2/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "SettingsViewController.h"

#import "ASIDownloadCache.h"
#import "AccreditViewController.h"//授权列表
#import "KidslistViewController.h"//儿童列表
@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/** all items */
@property (nonatomic,strong) UITableView * optionsTable;
/**右按钮*/
@property(nonatomic, strong) UIBarButtonItem *rightBtnItem;
/**弹出层*/
@property (nonatomic,strong) UIView * pushView;
/**刷新时间设置显示*/
@property (nonatomic,strong) UILabel * timeLbl;
/**刷新时间设置*/
@property (nonatomic,strong) UISlider *timeSlider;
/**刷新时间设置确定*/
@property (nonatomic,strong) UIButton *timeBtn;

/**授权列表*/
@property(nonatomic, strong) AccreditViewController * accred;
//儿童列表
@property(nonatomic, strong) KidslistViewController * kidslist;
@end

@implementation SettingsViewController
@synthesize  rightBtnItem;

#pragma mark - load views

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(settingsSelectLeftAction:)];
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    [self loadWidget];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (_accred!=nil) {
        _accred=nil;
    }
    if (_kidslist!=nil) {
        _kidslist=nil;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated{
    [_optionsTable removeFromSuperview];
    
    
    [self.view removeFromSuperview];
    [self setOptionsTable:nil];
    
    [self setView:nil];
    [super viewDidDisappear:animated];
}

-(void)loadWidget{
    NSLog(@"*** %f,---%F",self.view.bounds.size.height,Drive_Height);
    _optionsTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    _optionsTable.dataSource = self;
    _optionsTable.delegate = self;
    //设置table是否可以滑动
    _optionsTable.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    //_optionsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_optionsTable];
    
    _pushView =[[UIView alloc]initWithFrame:self.view.bounds];
    _pushView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.3];

    [self.view addSubview:_pushView];
    
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.view.bounds)/2-47.5, CGRectGetWidth(self.view.bounds)-20, 95)];
    //设置按钮是否圆角
    [bgView.layer setMasksToBounds:YES];
    //圆角像素化
    [bgView.layer setCornerRadius:4.0];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [_pushView addSubview:bgView];
    
    _timeLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(bgView.bounds)-10, 20)];
    _timeLbl.backgroundColor=[UIColor clearColor];
    _timeLbl.font=[UIFont systemFontOfSize:16];
    _timeLbl.text=@"5秒";
    _timeLbl.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:_timeLbl];
    
    _timeSlider= [[UISlider alloc]initWithFrame:CGRectMake(5, 20,CGRectGetWidth(bgView.bounds)-10 , 20)];
    _timeSlider.minimumValue = 5;//下限
    _timeSlider.maximumValue = 900;//上限
    _timeSlider.value = 5;//默认值
    
    [_timeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _timeSlider.continuous = YES ;//滑动中也触发获取值
    [bgView addSubview:_timeSlider];
    
    
    _timeBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 55, CGRectGetWidth(bgView.bounds)-10, 32)];
    [_timeBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    [_timeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timeBtn.layer setBorderWidth:1.0];
    //设置按钮是否圆角
    [_timeBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_timeBtn.layer setCornerRadius:4.0];
    [_timeBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_timeBtn addTarget:self action:@selector(OKAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_timeBtn];
    _pushView.hidden=YES;
    
}
/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-100, 6, 80, 32)];
        [button setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
        [button setTitle:LOCALIZATION(@"btn_logout") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1.0];
        //设置按钮是否圆角
        [button.layer setMasksToBounds:YES];
        //圆角像素化
        [button.layer setCornerRadius:4.0];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
        
    }
    return rightBtnItem;
}
/**获取刷新时间间隔值显示*/
- (void) sliderValueChanged:(id)sender{
    UISlider* control = (UISlider*)sender;
    if(control == _timeSlider){
        int value = control.value;
        if (value>60) {
            _timeLbl.text=[NSString stringWithFormat:@"%d分%d秒",value/60,value%60];
        }
        else
        {
            _timeLbl.text=[NSString stringWithFormat:@"%d秒",value];
        }
        
    }
}

#pragma mark - table view
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionTopView = nil;
    sectionTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    [sectionTopView setBackgroundColor:[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0]];
    
    //head label in each items
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 30.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    if (section == 0) {
        labelTitle.text = LOCALIZATION(@"text_settings_app_function");
        
    }
    else if(section == 1){
        labelTitle.text = LOCALIZATION(@"text_device");
        
    }else if(section == 2){
        labelTitle.text = LOCALIZATION(@"text_language");
        
    }else if(section == 3){
        labelTitle.text = LOCALIZATION(@"text_setting_user_account");
        
    }else if(section == 4){
        labelTitle.text = LOCALIZATION(@"text_others");
        
    }
    
    
    
    
    [sectionTopView addSubview:labelTitle];
    return sectionTopView;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else if(section == 3){
        return 2;
    }else if(section == 4){
        return 4;
    }
    
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
//        if (indexPath.section==0) {
//            if(indexPath.row == 0){
//                
//            }
//        }
    }
    
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text=LOCALIZATION(@"text_auto_refresh");
            //            [cell addSubview:[self settingLable:@"text_auto_refresh"]];
        }else if(indexPath.row == 1){
            cell.textLabel.text=LOCALIZATION(@"text_enableSound");
            //            [cell addSubview:[self settingLable:@"text_enableSound"]];
        }else if(indexPath.row == 2){
            cell.textLabel.text=LOCALIZATION(@"text_enableVibration");
            //            [cell addSubview:[self settingLable:@"text_enableVibration"]];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text=LOCALIZATION(@"btn_children_list");
            //            [cell addSubview:[self settingLable:@"btn_children_list"]];
            
        }else if(indexPath.row == 1){
            cell.textLabel.text=LOCALIZATION(@"btn_auth_list");
            //            [cell addSubview:[self settingLable:@"btn_auth_list"]];
            
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text=LOCALIZATION(@"text_english");
            //            [cell addSubview:[self settingLable:@"text_english"]];
            
        }else if(indexPath.row == 1){
            cell.textLabel.text=LOCALIZATION(@"text_chinese");
            //            [cell addSubview:[self settingLable:@"text_chinese"]];
            
            
        }else if(indexPath.row == 2){
            cell.textLabel.text=LOCALIZATION(@"text_simplified_chinese");
            //            [cell addSubview:[self settingLable:@"text_simplified_chinese"]];
            
        }
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text=LOCALIZATION(@"text_update_password");
            //            [cell addSubview:[self settingLable:@"text_update_password"]];
            
        }else if(indexPath.row == 1){
            cell.textLabel.text=LOCALIZATION(@"text_update_nickname");
            //            [cell addSubview:[self settingLable:@"text_update_nickname"]];
            
        }
    }else if(indexPath.section == 4){
        if(indexPath.row == 0){
            cell.textLabel.text=LOCALIZATION(@"text_about");
            //            [cell addSubview:[self settingLable:@"text_about"]];
            
        }else if(indexPath.row == 1){
            cell.textLabel.text=LOCALIZATION(@"text_TermsOfService");
            //            [cell addSubview:[self settingLable:@"text_TermsOfService"]];
            
        }else if(indexPath.row == 2){
            cell.textLabel.text=LOCALIZATION(@"text_privacyPolicy");
            //            [cell addSubview:[self settingLable:@"text_privacyPolicy"]];
            
        }
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        if(indexPath.row==0)
        {
            _pushView.hidden=NO;
        }
    }
    if (indexPath.section == 1){
        if(indexPath.row==0)
        {
            if (_kidslist==nil) {
                _kidslist= [[KidslistViewController alloc] init];
            }
            [self.navigationController pushViewController:_kidslist animated:YES];
        }
        if(indexPath.row==1)
        {
            if (_accred==nil) {
                _accred= [[AccreditViewController alloc] init];
            }
            [self.navigationController pushViewController:_accred animated:YES];
        }
        
    }
    
}


#pragma mark - button action
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)settingsSelectLeftAction:(id)sender
{
    [[self navigationController] pushViewController:nil animated:YES];
}

-(void)exitAction:(id)sender
{
    
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [ASIHTTPRequest clearSession];
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)OKAction:(id)sender
{
    int value = _timeSlider.value;
    NSUserDefaults *refresh = [NSUserDefaults standardUserDefaults];
    [refresh setInteger:value forKey:@"refreshTime"];
    _pushView.hidden=YES;
}

@end
