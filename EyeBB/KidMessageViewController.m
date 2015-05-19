//
//  KidMessageViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-3-19.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "KidMessageViewController.h"
#import "RMDownloadIndicator.h"//蓝牙设备电量显示

#import "MSCellAccessory.h"//自定义cell右边提示箭头
#import "QRCodeGenerator.h"
#import "RootViewController.h"

@interface KidMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    
    NSString *major;
    NSString *minor;
    
    int batteryLife;
    Boolean reReadBatteryLife;
    
    NSString *macAddress;
}
//蓝牙设备电量显示
@property (weak, nonatomic) RMDownloadIndicator *closedIndicator;

/** child image */
@property (nonatomic,strong) UIImageView *childImgView;
/** child name */
@property (nonatomic,strong) UILabel *childNameLbl;

/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;


/**选项列表*/
@property (strong,nonatomic) UITableView * SelectedTView;

/**             UNBIND                   */
/**弹出框*/
@property (strong,nonatomic) UIScrollView * PopupSView;
/**列表显示模式容器*/
@property (strong,nonatomic) UIView * unbindView;
/* content label */
@property (strong,nonatomic) UILabel * popContentLabel;

/**             QR CODE                   */
@property (strong,nonatomic) UIScrollView * PopupQRSView;
/**列表显示模式容器*/
@property (strong,nonatomic) UIView * QRView;
/* view to show qr code */
@property (strong,nonatomic) UIImageView * QRImgView;
/* battery life label */
@property (nonatomic,strong) UILabel* batteryLifeLbl;
//头像背景容器
@property (nonatomic,strong) UIView *kidBgView;


/**  next view */
@property (nonatomic,strong) RootViewController *scanDeviceView;
@end

@implementation KidMessageViewController
@synthesize childrenDictionary;

#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(KindergartenListViewControllerLeftAction:)];
    
    
   
    
    NSLog(@"childrenDictionary(%@)",self.childrenDictionary);
    NSLog(@"name (%@)",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"name"]);
    major = [NSString stringWithFormat:@"%@",[self.childrenDictionary objectForKey:@"major" ]];
    minor = [NSString stringWithFormat:@"%@",[self.childrenDictionary objectForKey:@"minor" ]];
    NSLog(@"major (%@)",[self getMajor:major]);
    NSLog(@"minor (%@)",[self getMinor:minor]);
    NSLog(@"icon (%@)",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"icon"]);
    NSLog(@"childId (%@)",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"childId"]);
    // macAddress = @"null";
    macAddress = [NSString stringWithFormat:@"%@",[self.childrenDictionary objectForKey:@"macAddress" ]];
    NSLog(@"macAddress (%@)",[self.childrenDictionary objectForKey:@"macAddress" ]);
    //read battery
    
    
    //reg broad cast
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beepTimeout:) name:nil object:nil ];
    
    
    [self iv];
    [self lc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_BEEP_TIME_OUT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_READ_BATTERY_TIME_OUT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME object:nil];
    
    
    [_childImgView removeFromSuperview];
    [_childNameLbl removeFromSuperview];
    [_SelectedTView removeFromSuperview];
    [_PopupSView removeFromSuperview];
    [_unbindView removeFromSuperview];
    [_popContentLabel removeFromSuperview];
    [_PopupQRSView removeFromSuperview];
    [_QRView removeFromSuperview];
    [_QRImgView removeFromSuperview];
    [_batteryLifeLbl removeFromSuperview];
    
    [self.view removeFromSuperview];
    
    [self setChildImgView:nil];
    [self setChildNameLbl:nil];
    [self setSelectedTView:nil];
    [self setPopupSView:nil];
    [self setUnbindView:nil];
    [self setPopContentLabel:nil];
    [self setPopupQRSView:nil];
    [self setQRView:nil];
    [self setQRImgView:nil];
    [self setBatteryLifeLbl:nil];
    
    [self setView:nil];
    [super viewDidDisappear:animated];
    
    if (_scanDeviceView != nil) {
        _scanDeviceView = nil;
    }
    
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
    
    batteryLife = 0;
    reReadBatteryLife = FALSE;
    
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *加载控件
 */
-(void)lc
{
    
    //头像背景容器
    _kidBgView=[[UIView alloc]initWithFrame:CGRectZero];
    _kidBgView.frame=CGRectMake(0, 0, Drive_Wdith, Drive_Height/6*2);

    [self.view addSubview:_kidBgView];
    
    
    //child image
    _childImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Drive_Wdith /3 + 7, 10 + 7, Drive_Wdith /3 - 14, Drive_Wdith /3 - 14)];
    [_childImgView.layer setCornerRadius:CGRectGetHeight([_childImgView bounds]) / 2];
    [_childImgView.layer setMasksToBounds:YES];
    [_childImgView.layer setBorderWidth:2];
    [_childImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"icon"]];
    
    NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
    NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."] copy];
    
    
    
    if ([self loadImage:[array2 objectAtIndex:0] ofType:[[array2 objectAtIndex:1] copy ]inDirectory:_documentsDirectoryPath]!=nil) {
        
        [_childImgView setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath]];
    }
    else
    {
        NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
        NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
        [_childImgView setImage:[UIImage imageWithData:data]];
        //Get Image From URL
        UIImage * imageFromURL  = nil;
        imageFromURL=[UIImage imageWithData:data];
        //Save Image to Directory
        [self saveImage:imageFromURL withFileName:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath];
        
        
    }
    pathOne=nil;
    array=nil;
    array2=nil;
    
    
    [self.view addSubview:_childImgView];
    
    
    
    //child name
    _childNameLbl =[[UILabel alloc]initWithFrame:(CGRectMake(Drive_Wdith / 2 - Drive_Wdith/2, 10 + Drive_Wdith/3  / 2 + 20, Drive_Wdith, Drive_Wdith /3))];
    [_childNameLbl setText:[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"name"]];
    
    [_childNameLbl setFont:[UIFont systemFontOfSize: 22.0]];
    [_childNameLbl setTextColor:[UIColor whiteColor]];
    [_childNameLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_childNameLbl];
    
    
    //蓝牙设备电量显示进度条
    [_closedIndicator removeFromSuperview];
    _closedIndicator = nil;
    
    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake(Drive_Wdith /3, 10, Drive_Wdith /3, Drive_Wdith /3) type:kRMClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    closedIndicator.radiusPercent = 0.45;
    
    [_kidBgView addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    
    _closedIndicator = closedIndicator;
    //设置downloadedBytes就可以了，这个为电量的百分比
    //[_closedIndicator updateWithTotalBytes:100 downloadedBytes:batteryLife];
    
    //选项列表
    _SelectedTView=[[UITableView alloc] initWithFrame:CGRectMake(0, Drive_Height/6*2, Drive_Wdith, Drive_Height/6*4)];
    _SelectedTView.dataSource = self;
    _SelectedTView.delegate = self;
    self.SelectedTView.tableFooterView = [[UIView alloc] init];
    //设置table是否可以滑动
    _SelectedTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    //    _SelectedTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_SelectedTView];
    
    
    
    //------------------unbind------遮盖层------------------------
    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    
    //unbind view
    _unbindView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-138, Drive_Wdith-10, 100)];
    [_unbindView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_unbindView.layer setMasksToBounds:YES];
    //圆角像素化
    [_unbindView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_unbindView];
    
    
    _popContentLabel = [[UILabel alloc]init];
    _popContentLabel.text = LOCALIZATION(@"text_unbind_device");
    
    _popContentLabel.frame = CGRectMake(CGRectGetWidth(_PopupSView.frame)/2 - getLableTextWidth(_popContentLabel,20.0f)/2 + 10,CGRectGetHeight(_PopupSView.frame)/2 - 115,CGRectGetWidth(_PopupSView.frame) - 10 ,30);
    
    _popContentLabel.font = [UIFont systemFontOfSize:18];
    [_PopupSView addSubview:_popContentLabel];
    
    //取消按钮
    UIButton * cencelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,60,CGRectGetWidth(_unbindView.frame)/2, 40)];
    //设置按显示文字
    [cencelBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
    [cencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cencelBtn setImage:[UIImage imageNamed:@"cross2"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [cencelBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [cencelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cencelBtn.layer setBorderWidth:0.5]; //边框宽度
    [cencelBtn.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    [_unbindView addSubview:cencelBtn];
    
    //提交按钮
    UIButton * ChangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_unbindView.frame)/2, 60,CGRectGetWidth(_unbindView.frame)/2, 40)];
    //设置按显示文字
    [ChangeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [ChangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ChangeBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [ChangeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [ChangeBtn addTarget:self action:@selector(unBindAction) forControlEvents:UIControlEventTouchUpInside];
    [ChangeBtn.layer setBorderWidth:0.5]; //边框宽度
    [ChangeBtn.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    [_unbindView addSubview:ChangeBtn];
    
    
    
    //------------------QRQRQRQRQRS------遮盖层------------------------
    
    //弹出遮盖层
    _PopupQRSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupQRSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupQRSView];
    [_PopupQRSView setHidden:YES];
    
    
    //unbind view
    _QRView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-238, Drive_Wdith-10, 300)];
    [_QRView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_QRView.layer setMasksToBounds:YES];
    //圆角像素化
    [_QRView.layer setCornerRadius:4.0];
    [_PopupQRSView addSubview:_QRView];
    
    
    _QRImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_QRView.frame)/2 - (CGRectGetWidth(_QRView.frame) - 100) / 2, 20 ,CGRectGetWidth(_QRView.frame) - 100,CGRectGetWidth(_QRView.frame) - 100)];
    [_QRView addSubview:_QRImgView];
    
    
    
    //提交按钮
    UIButton * confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 260,CGRectGetWidth(_QRView.frame), 40)];
    //设置按显示文字
    [confirmBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [confirmBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [confirmBtn addTarget:self action:@selector(qrConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn.layer setBorderWidth:0.5]; //边框宽度
    [confirmBtn.layer setBorderColor:[UIColor colorWithRed:0.945 green:0.941 blue:0.945 alpha:1].CGColor];//边框颜色
    [_QRView addSubview:confirmBtn];
    
    
    
    
    if (macAddress.length > 0) {
        [self readBattery:nil major:[self getMajor:major] minor:[self getMinor:minor]];
        _kidBgView.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    }else{
        _kidBgView.backgroundColor= [UIColor colorWithRed:0.910 green:0.910 blue:0.910 alpha:1];
        
    }
    
}

#pragma mark --
#pragma mark - 表单设置





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        
        _batteryLifeLbl =[[UILabel alloc]initWithFrame:CGRectMake(Drive_Wdith , 20 , 80, 20)];
        //_batteryLifeLbl.text = @"ss";
        [_batteryLifeLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [_batteryLifeLbl setTextColor:[UIColor blackColor]];
        [_batteryLifeLbl setTextAlignment:NSTextAlignmentCenter];
        _batteryLifeLbl.tag = 100;
         cell.accessoryView = _batteryLifeLbl;
        
    }
    
    if (indexPath.row==0) {
        
        cell.textLabel.text=LOCALIZATION(@"text_battery_life");
        
      UILabel *batteryLifeLbl = (UILabel*)[cell viewWithTag:100];;
        //_batteryLifeLbl.text = @"ss";
        NSLog(@"batteryLife --> %d",batteryLife);
      [batteryLifeLbl setText:[NSString stringWithFormat:@"%d%@",batteryLife,@"/100"]];
        
       
        
    }else
    {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
    }
    switch (indexPath.row) {
        case 0:
            //read battery
            //[self readBattery:nil major:major minor:minor];
            
            break;
        case 1:
            cell.textLabel.text=LOCALIZATION(@"text_beep");
            break;
        case 2:
            cell.textLabel.text=LOCALIZATION(@"text_get_the_eyebb_device_qr_code");
            break;
        case 3:
            
            if(macAddress.length > 0){
                cell.textLabel.text=LOCALIZATION(@"btn_binding");
            }else{
                cell.textLabel.text=LOCALIZATION(@"btn_unbind");
            }
            
            
            break;
            //        case 4:
            //            //cell.textLabel.text=LOCALIZATION(@"btn_unbind");
            //            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            if (reReadBatteryLife) {
                //read battery
                [self readBattery:nil major:[self getMajor:major] minor:[self getMinor:minor]];
                _kidBgView.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
                reReadBatteryLife = FALSE;
            }
            
            
        }else if (indexPath.row == 1) {
            
            [self writeBeepMajor:[self getMajor:major] minor:[self getMinor:minor] writeValue:@"01"];
            [HUD show:YES];
            
            
            
            
        }else if (indexPath.row == 2){
            
            
            
            
            NSString *childID = [NSString stringWithFormat:@"%@",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"childId"]];
            
            
            //NSLog(@"userName (%@) childName (%@) childBirthday(%@) ",userName,childName,childBirthday);
            
            if([self verifyQRcodeRequest:childID] != nil)
            {
                
                [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                            message:[self verifyQRcodeRequest:childID]
                                           delegate:self
                                  cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                                  otherButtonTitles:nil] show];
            }
            else
            {
                
                
                //Loding progress bar
                [HUD show:YES];
                
                NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:childID, KidMessageViewController_KEY_childId ,nil];
                // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
                
                [self postRequest:REQUIRE_OR_GET_QR_CODE RequestDictionary:tempDoct delegate:self];
                
                
            }
            
            
            
        }else if(indexPath.row == 3)
        {
            
            if(macAddress.length > 0){
                if (_scanDeviceView == nil) {
                    _scanDeviceView =  [[RootViewController alloc]init];
                }
                
                _scanDeviceView.childID = [[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"childId"];
                _scanDeviceView.guardianId = @"1L";
                
                [[self navigationController] pushViewController:_scanDeviceView animated:YES];
                
            }else{
                [_PopupSView setHidden:NO];
            }
            
            
        }
    }
    
    
}

#pragma mark - broadcast
- (void) beepTimeout:(NSNotification *)notification{
    if ([[notification name] isEqualToString:BLUETOOTH_GET_BEEP_TIME_OUT]){
        NSLog(@"BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME");
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES afterDelay:0];
        });
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_connect_error")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
        
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_READ_BATTERY_TIME_OUT]){
        
        
        batteryLife = 0;
        _batteryLifeLbl.text = [NSString stringWithFormat:@"%d",batteryLife];
        _kidBgView.backgroundColor=[UIColor colorWithRed:0.910 green:0.910 blue:0.910 alpha:1];
        reReadBatteryLife = TRUE;
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME]){
        
        
        batteryLife = [(NSString *)[notification object] intValue];
//        _batteryLifeLbl.text = [NSString stringWithFormat:@"%d",batteryLife];
        
        NSLog(@"BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME --> %d",batteryLife);
        
       
        
        reReadBatteryLife = TRUE;
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [_closedIndicator updateWithTotalBytes:100 downloadedBytes:batteryLife];
            [self.SelectedTView reloadData];
        });
        
    }else if([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME]){
        
        NSLog(@"BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME");
       
        dispatch_async(dispatch_get_main_queue(), ^{
          [HUD hide:YES afterDelay:0];
        });
        
    }
    
    
    
    
    
}




#pragma mark - button action

-(void)cancelAction{
    [_PopupSView setHidden:YES];
    
}

-(void)unBindAction{
    NSString *childID = [NSString stringWithFormat:@"%@",[[[self.childrenDictionary objectForKey:@"childRel" ]objectForKey:@"child" ]objectForKey:@"childId"]];
    
    
    //NSLog(@"userName (%@) childName (%@) childBirthday(%@) ",userName,childName,childBirthday);
    
    if([self verifyUnbindRequest:childID] != nil)
    {
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:[self verifyUnbindRequest:childID]
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    else
    {
        
        
        //Loding progress bar
        [HUD show:YES];
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:childID, KidMessageViewController_KEY_childId ,nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
        [self postRequest:UNBIND_CHILD_BEACON RequestDictionary:tempDoct delegate:self];
        
        
    }
    
    
}



-(void)qrConfirmAction{
    
    [_PopupQRSView setHidden:YES];
    
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

- (NSString *)verifyUnbindRequest:(NSString *)childId
{
    NSString * mag=nil;//返回变量值
    
    if(childId.length <= 0)
    {
        mag=LOCALIZATION(@"text_unbind_fail");
        return mag;
    }
    
    return mag;
}


- (NSString *)verifyQRcodeRequest:(NSString *)childId
{
    NSString * mag=nil;//返回变量值
    
    if(childId.length <= 0)
    {
        mag=LOCALIZATION(@"text_Apply_qr_code_fail");
        return mag;
    }
    
    return mag;
}

#pragma mark - server request
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    //关闭加载
    [HUD hide:YES afterDelay:0];
    if ([tag isEqualToString:UNBIND_CHILD_BEACON]) {
        NSData *responseData = [request responseData];
        
        NSString * resUNBIND_CHILD_BEACON= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"UNBIND_CHILD_BEACON --> %@ ",resUNBIND_CHILD_BEACON);
        
        
        if([resUNBIND_CHILD_BEACON isEqualToString:@"NC"]){
            //if the user name or password is invaild. alerting the user.
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_unbind_fail")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }else if([resUNBIND_CHILD_BEACON isEqualToString:@"Y"]){
            
            //if the user name or password is invaild. alerting the user.
            
            
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_unbind_success")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
            
            [_PopupSView setHidden:YES];
        }
        
    }else if([tag isEqualToString:REQUIRE_OR_GET_QR_CODE]){
        
        NSData *responseData = [request responseData];
        
        NSString * resREQUIRE_OR_GET_QR_CODE = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if(resREQUIRE_OR_GET_QR_CODE.length > 4 && resREQUIRE_OR_GET_QR_CODE.length < 25){
            [_PopupQRSView setHidden:NO];
            
            NSLog(@"REQUIRE_OR_GET_QR_CODE --> %@ ",resREQUIRE_OR_GET_QR_CODE);
            UIImage *image = [QRCodeGenerator qrImageForString:resREQUIRE_OR_GET_QR_CODE imageSize:200];
            
            
            [_QRImgView setImage:image ];
        }else{
            
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_Apply_qr_code_fail")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
            
            
        }
        
        
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    //关闭加载
    [HUD hide:YES afterDelay:0];
    
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@"text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
}

@end
