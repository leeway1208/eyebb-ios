//
//  MainViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-24.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
//#import "KidslistViewController.h"//儿童列表
#import "JSONKit.h"
#import "MSCellAccessory.h"
//#import "LDProgressView.h"
#import "EAColourfulProgressView.h"
#import "UserDefaultsUtils.h"
//#import "DBImageView.h"
#import "AppDelegate.h"
#import "ChildrenListViewController.h"//查询简报儿童列表
#import "DBImageView.h"//图片加载
//彩色进度条
#import "GradientProgressView.h"

#import "WebViewController.h"

#import "KidViewController.h"//查询儿童列表
#import "AntiLostKidsSelectedListViewController.h"
#import "ChildLocationController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    /**滑动HMSegmentedControl*/
    int huaHMSegmentedControl;
    
    AppDelegate * myDelegate;
    int textHeight;
    int selected;
    
    //radar status number
    int connectNum;
    int disconnectNum;
    
    //radar dot
    Boolean isSelectedMissed;
    
    //turn on the radar model
    BOOL isButtonOn;
    
    NSMutableArray * antiResultAy;
    NSMutableArray * antiResultNoMore3Ay;
    //radar is more than 3
    Boolean isMoreThanThree;
    NSString* antiLostNoMore3;
    NSString* reconnectNoMore3;
    //location
    float kidsLatitude;
    float kidsLongitude;
    double locationTimerInterval;
    NSString *childId;
    NSString *locChildName;
    
}
//-------------------视图控件--------------------
/**选项卡内容容器*/
@property (strong, nonatomic) UIScrollView *MainInfoScrollView;
/* inddor  locator */
@property (strong, nonatomic) UIView *organizationShowBtnShowView;
/**房间信息*/
@property (strong, nonatomic) UITableView *RoomTableView;
/**雷达*/
@property (strong, nonatomic) UITableView *RadarConnectTableView;
/**雷达*/
@property (strong, nonatomic) UITableView *RadarDisconnectTableView;
/**雷达*/
@property (strong, nonatomic) UIScrollView *RadarScrollView;
/**表现*/
@property (strong, nonatomic) UITableView *PerformanceTableView;
/**活动*/
@property (strong, nonatomic) UITableView *ActivitiesTableView;

/**个人*/
@property (strong, nonatomic) UITableView *PersonageTableView;
/**弹出框*/
@property (strong,nonatomic) UIScrollView * PopupSView;
@property (strong,nonatomic) UIScrollView * RadarPopupSView;
/**列表显示模式容器*/
@property (strong,nonatomic) UIView * listTypeView;
/**儿童相关信息容器*/
@property (strong,nonatomic) UIView * kidsMassageView;
/**列表显示模式列表*/
@property (strong,nonatomic) UITableView * listTypeTableView;
/**列表显示模式改变按钮*/
@property (strong,nonatomic) UIButton * listTypeChangeBtn;
/**是否自动刷新对应显示图标*/
@property (strong,nonatomic) UIImageView * refreshImgView;
/**是否显示所有房间图标*/
@property (strong,nonatomic) UIImageView * ShowALLRoomImgView;
/**时间段选择向下图标*/
@property (strong,nonatomic) UIImageView * conditionImgView;
/**选择机构按钮*/
@property (strong,nonatomic) UIButton * organizationShowBtn;
/**小孩列表*/
@property (strong,nonatomic) UIButton * childrenListBtn;
/**机构列表*/
@property (strong,nonatomic) UITableView * organizationTableView;
/**查询日期范围列表*/
@property (strong,nonatomic) UITableView * dateTableView;
/**用户名称*/
@property (strong,nonatomic) UILabel * UserNameLbl;
/**活动告示*/
@property(nonatomic,strong) UILabel * bulletinLbl;
//单击空白处关闭遮盖层
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/**查看表现条件提示*/
@property (strong,nonatomic) UILabel * conditionLbl;
/**表现按钮*/
@property (strong,nonatomic) UIButton * performanceBtn;
/**活动按钮*/
@property (strong,nonatomic) UIButton * activitiesBtn;
/**选择显示范围*/
@property (strong,nonatomic) UIButton * PerformanceTimeBtn;


/**房间按钮*/
@property (strong,nonatomic) UIButton * HomeBtn;
/**雷达按钮*/
@property (strong,nonatomic) UIButton * RadarBtn;
/**简报按钮*/
@property (strong,nonatomic) UIButton * NewsBtn;
/**个人信息按钮*/
@property (strong,nonatomic) UIButton * PersonageBtn;


//间隔线2
@property (strong,nonatomic) UILabel *divisionTwoLbl;
//间隔线4
@property (strong,nonatomic) UILabel *divisionFourLbl;

//简报儿童头像
@property (strong,nonatomic) DBImageView * kidImgView;

//彩色进度条
@property (strong,nonatomic) GradientProgressView *progressView;
//-------------------视图变量--------------------
/**房间背景颜色数组*/
@property (strong,nonatomic) NSArray *colorArray;
/**机构数组*/
@property (strong,nonatomic) NSMutableArray * organizationArray;

/**房间数组*/
@property (strong,nonatomic) NSMutableArray * roomArray;
/**所有房间数组*/
@property (strong,nonatomic) NSMutableArray * allRoomArray;
/**当前有儿童的房间数组*/
@property (strong,nonatomic) NSMutableArray * kidsRoomArray;
//儿童所在机构对应数据数组
@property (strong,nonatomic) NSMutableArray * childrenByAreaArray;

/**活动数组*/
@property (strong,nonatomic) NSMutableArray * activityInfosArray;
//表现数组
@property (strong,nonatomic) NSMutableArray * dailyAvgFigureArray;

//个人信息列表
@property (strong,nonatomic) NSMutableArray * personalDetailsArray;

/**儿童相关信息*/
@property (strong,nonatomic) NSMutableDictionary * childrenDictionary;
/**儿童相关信息根据房间显示*/
@property (strong,nonatomic) NSMutableDictionary * childrenByRoomDictionary;

@property (nonatomic,strong) SettingsViewController *settingVc;
/**查看所有房间功能打开*/
@property (nonatomic,assign) BOOL isallRoomOn;
/**自动刷新功能打开*/
@property (nonatomic,assign) BOOL isautoOn;
/**是否刷新房间列表*/
@property (nonatomic,assign) BOOL isreloadRoomList;
/**是否刷新系统通知*/
@property (nonatomic,assign) BOOL isreloadpersonal;
/**是否加载简报信息*/
@property (nonatomic,assign) BOOL isloadNews;
/**是否加载意见反馈*/
@property (nonatomic,assign) BOOL isloadFeekBack;

/**机构下标*/
@property (nonatomic,assign) int organizationIndex;

/**时间格式*/
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
/***/
@property (nonatomic,strong) NSString *avgDaysStr;
/**刷新定时器*/
@property (nonatomic,strong)NSTimer * refreshTimer;
/**意见反馈*/
@property (nonatomic,strong)UIView *FeekBackView;
/**意见输入框*/
@property (nonatomic,strong)UITextField *FeekBackTxt;

// RADAR VIEW
@property (nonatomic,strong) UISwitch *switchButton;
// RADAR UISegmented Control
@property (nonatomic,strong) UISegmentedControl *radarViewSegmentedControl;
/**表现按钮*/
@property (strong,nonatomic) UIButton * connectBtn;
/**活动按钮*/
@property (strong,nonatomic) UIButton * disconnectBtn;

@property (strong,nonatomic) UIButton * NewsKidBtn;
@property (strong,nonatomic) UIButton * closeBtn;
//间隔线2
@property (strong,nonatomic) UILabel * RadarDivisionTwoLbl;
//间隔线4
@property (strong,nonatomic) UILabel * radarDivisionFourLbl;

@property (strong,nonatomic) UILabel * labelTitle;

@property (strong,nonatomic) UILabel * radarLbl;
@property (strong,nonatomic) UILabel * NewsLbl;
@property (strong,nonatomic) UILabel * revampLbl;
@property (strong,nonatomic) UILabel * todayLbl;
@property (strong,nonatomic) UILabel * customizedLbl;
@property (strong,nonatomic) UILabel * PersonageLbl;
@property (strong,nonatomic) UILabel * listtitleLal;
/**connect kids*/
@property (strong,nonatomic) NSMutableArray * connectKidsAy;
@property (strong,nonatomic) NSMutableArray * connectKidsByScanedAy;
@property (strong,nonatomic) NSMutableArray * connectKidsByScanedToAntiLostAy;
@property (strong,nonatomic) NSMutableArray * connectKidsRssiAy;
@property (strong,nonatomic) NSMutableArray *tempDisconnectKidsAy;
//disconnect kids
@property (strong,nonatomic) NSMutableArray * disconectKidsAy;
//bg  Rada  Circle
@property (strong,nonatomic) UIImageView *bgRadaCircle;
//bg Radar Rotate
@property (strong,nonatomic) UIImageView *bgRadarRotate;
//anti lost table view
@property (strong,nonatomic) UITableView *antiLostTb;
//ui tick image
@property (strong,nonatomic) UIImageView *tickImageView;
//ui cross image
@property (strong,nonatomic) UIImageView *crossImageView;
//anti lost scan data
@property (strong,nonatomic) NSMutableArray *antiLostMore3scanDataAy;


@property (strong,nonatomic) NSMutableArray *antiLostMore3scanSelectedDataAy;

//room sos
@property (strong,nonatomic) NSMutableArray *roomSosNumber;
@property (strong,nonatomic) UIScrollView * PopRoomSosSView;
@property (strong,nonatomic) UIView * popRoomViewContainer;

//-------------------跳转页面--------------------
@property (nonatomic,strong) WebViewController * web;
@property (nonatomic,strong) AntiLostKidsSelectedListViewController * antiLostView;


//location
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (strong,nonatomic) NSTimer *locationTimer;
@property (strong,nonatomic) NSMutableArray *locationAy;

//自定义色块 todayLbl.bounds
@property (strong,nonatomic) UILabel *customizedColorLbl;
/* get local child informaton */
@property (nonatomic,strong) NSMutableArray *localChildInfo;
@end

@implementation MainViewController
static SystemSoundID shake_sound_male_id = 0;
@synthesize kidImgView;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = LOCALIZATION(@"app_name");
    // Do any additional setup after loading the view.
    

    [self iv];
    
    
    //    [self getRequest:@"kindergartenList" delegate:self];
    [self getRequest:GET_CHILDREN_LOC_LIST delegate:self RequestDictionary:nil];
    
    
    /**
     *  check the app version
     */
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString * appLowestVer =  [NSString stringWithFormat:@"%@",[defaults objectForKey:LoginViewController_app_version]];
    
    NSLog(@"appLowestVer -> %@",appLowestVer);
    if ([appLowestVer floatValue] > [[self getAppVersion] floatValue ]) {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_new_version_to_update")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    

  
    [self lc];
    
    [self location];
}

-(void)location{
    locationTimerInterval = 300.0f;
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 10 meters / per
    _locationManager.distanceFilter = 10;
    [_locationManager requestAlwaysAuthorization];
    
}

- (void)simulateProgress {
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        CGFloat progress  = [_progressView progress] + increment;
        [_progressView setProgress:progress];
        if (progress < 1.0) {
            
            [self simulateProgress];
        }
    });
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_progressView startAnimating];
    
    [self simulateProgress];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if(self.settingVc!=nil)
    {
        self.settingVc=nil;
    }
    if(self.settingVc!=nil)
    {
        self.settingVc=nil;
    }
    if (self.web!=nil) {
        self.web =nil;
    }
    if(_antiLostView != nil ){
        _antiLostView = nil;
    }
    if (myDelegate.childDictionary!=nil&&huaHMSegmentedControl==2&&self.isloadNews==YES) {
        
        [self insertChildMessage];
        
    }
    if(_isautoOn==YES&&huaHMSegmentedControl==0)
    {
        //开启定时器
        [self.refreshTimer setFireDate:[NSDate distantPast]];
    }
    
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [_locationManager stopUpdatingLocation];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANTILOST_VIEW_ANTI_LOST_CONFIRM_BROADCAST object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:SETTING_CHANGE_LANGUAGE_BROADCAST object:nil];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLanuage)
                                                 name:SETTING_CHANGE_LANGUAGE_BROADCAST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIcon) name:CHANGE_ICON_BROADCAST object:nil ];
    _localChildInfo = [self allChildren];
    
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    myDelegate.userName  =  [[NSString stringWithFormat:@"%@",[userDefaultes objectForKey:LoginViewController_accName]] copy];
    
   // NSLog(@"%@--- ",myDelegate.userName );
    connectNum = 0;
    disconnectNum = 0;
    isSelectedMissed = false;

    
    _colorArray=@[[UIColor colorWithRed:0.282 green:0.800 blue:0.922 alpha:1],[UIColor colorWithRed:0.392 green:0.549 blue:0.745 alpha:1],[UIColor colorWithRed:0.396 green:0.741 blue:0.561 alpha:1],[UIColor colorWithRed:0.149 green:0.686 blue:0.663 alpha:1],[UIColor colorWithRed:0.925 green:0.278 blue:0.510 alpha:1],[UIColor colorWithRed:0.690 green:0.380 blue:0.208 alpha:1],[UIColor colorWithRed:0.898 green:0.545 blue:0.682 alpha:1],[UIColor colorWithRed:0.643 green:0.537 blue:0.882 alpha:1],[UIColor colorWithRed:0.847 green:0.749 blue:0.216 alpha:1],[UIColor colorWithRed:0.835 green:0.584 blue:0.329 alpha:1]];
    
    _organizationArray=[[NSMutableArray alloc]init];
    _childrenDictionary=[[NSMutableDictionary alloc]init];
    _personalDetailsArray=[[NSMutableArray alloc]init];
    _kidsRoomArray=[[NSMutableArray alloc]init];
    _childrenByRoomDictionary=[[NSMutableDictionary alloc]init];
    _dailyAvgFigureArray=[[NSMutableArray alloc]init];
    _activityInfosArray=[[NSMutableArray alloc]init];
    _connectKidsAy =[[NSMutableArray alloc]init];
    _connectKidsByScanedToAntiLostAy =[[NSMutableArray alloc]init];
    _disconectKidsAy =[[NSMutableArray alloc]init];
    antiResultAy =[[NSMutableArray alloc]init];
    antiResultNoMore3Ay = [[NSMutableArray alloc]init];
    _antiLostMore3scanDataAy = [[NSMutableArray alloc]init];
    _antiLostMore3scanSelectedDataAy = [[NSMutableArray alloc]init];
    _locationAy = [[NSMutableArray alloc]init];
    _roomSosNumber = [[NSMutableArray alloc]init];


    _connectKidsRssiAy = [[NSMutableArray alloc]init];
    _isallRoomOn=NO;
    _isautoOn=NO;
    _isreloadRoomList=YES;
    _isreloadpersonal=YES;
    _isloadNews=YES;
    self.avgDaysStr=@"5";
    self.organizationIndex=0;
    _isloadFeekBack=YES;
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
    //    [fileManager createDirectoryAtPath:@"localImg" withIntermediateDirectories:YES attributes:nil error:nil];
    //     _documentsDirectoryPath=[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"localImg"];
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"_documentsDirectoryPath is%@",_documentsDirectoryPath);
   
    
    //    [fileManager removeItemAtPath:_documentsDirectoryPath error:nil];
    
    NSUserDefaults *refresh = [NSUserDefaults standardUserDefaults];
    self.refreshTimer=[NSTimer scheduledTimerWithTimeInterval:[[refresh objectForKey:@"refreshTime"]doubleValue] target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    //关闭定时器
    [self.refreshTimer setFireDate:[NSDate distantFuture]];
}

/**
 *加载控件
 */
-(void)lc
{
    
    
    //室内定位选择按钮
    _HomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, Drive_Wdith/4, 44)];
    //设置按显示图片
    [_HomeBtn setImage:[UIImage imageNamed:@"actbar_home"] forState:UIControlStateNormal];
    [_HomeBtn setImage:[UIImage imageNamed:@"actbar_homeOn"] forState:UIControlStateSelected];
    //设置按钮背景颜色
    [_HomeBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [_HomeBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_HomeBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    _HomeBtn.tag=214;
    [self.view addSubview:_HomeBtn];
    
    
    
    
    //雷达选择按钮
    _RadarBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4, 20, Drive_Wdith/4, 44)];
    //设置按显示图片
    [_RadarBtn setImage:[UIImage imageNamed:@"actbar_tracking"] forState:UIControlStateNormal];
    [_RadarBtn setImage:[UIImage imageNamed:@"actbar_trackingOn"] forState:UIControlStateSelected];
    //设置按钮背景颜色
    [_RadarBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_RadarBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_RadarBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    _RadarBtn.tag=215;
    [self.view addSubview:_RadarBtn];
    
    //简报选择按钮
    _NewsBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4 * 2, 20, Drive_Wdith/4, 44)];
    //设置按显示图片
    [_NewsBtn setImage:[UIImage imageNamed:@"actbar_report"] forState:UIControlStateNormal];
    [_NewsBtn setImage:[UIImage imageNamed:@"actbar_reportOn"] forState:UIControlStateSelected];
    //设置按钮背景颜色
    [_NewsBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_NewsBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_NewsBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    _NewsBtn.tag=216;
    [self.view addSubview:_NewsBtn];
    
    //个人信息选择按钮
    _PersonageBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4*3, 20, Drive_Wdith/4, 44)];
    //设置按显示图片
    [_PersonageBtn setImage:[UIImage imageNamed:@"actbar_profile"] forState:UIControlStateNormal];
    [_PersonageBtn setImage:[UIImage imageNamed:@"actbar_profileOn"] forState:UIControlStateSelected];
    //设置按钮背景颜色
    [_PersonageBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_PersonageBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_PersonageBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    _PersonageBtn.tag=217;
    [self.view addSubview:_PersonageBtn];
    
    NSLog(@"CGRectGetm(_RadarBtn.bounds) is %f",CGRectGetMinX(_RadarBtn.bounds));
    //间隔线
    UILabel *divisionHomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(Drive_Wdith/4-1, 24.0f, 2, 34)];
    [divisionHomeLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [self.view addSubview:divisionHomeLbl];
    
    //间隔线
    UILabel *divisionRadarLbl = [[UILabel alloc] initWithFrame:CGRectMake(Drive_Wdith/4*2-1, 24.0f, 2, 34)];
    [divisionRadarLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [self.view addSubview:divisionRadarLbl];
    
    //间隔线
    UILabel *divisionNewsLbl = [[UILabel alloc] initWithFrame:CGRectMake(Drive_Wdith/4*3-1, 24.0f, 2, 34)];
    [divisionNewsLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [self.view addSubview:divisionNewsLbl];
    
    
    //设置scrollView
    _MainInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Drive_Wdith, Drive_Height-44)];
    [_MainInfoScrollView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1]];
    [_MainInfoScrollView setDelegate:self];
    _MainInfoScrollView.contentSize = CGSizeMake(Drive_Wdith*4, CGRectGetHeight(_MainInfoScrollView.frame));
    [_MainInfoScrollView setTag:101];
    // 滚动时,是否显示水平滚动条
    _MainInfoScrollView.showsHorizontalScrollIndicator = NO;
    // 滚动时,是否显示垂直滚动条
    _MainInfoScrollView.showsVerticalScrollIndicator = NO;
    //设置滑动不出界反弹
    //    _MainInfoScrollView.bounces = NO;
    _MainInfoScrollView.pagingEnabled = YES;
    [self.view addSubview:_MainInfoScrollView];
    //------------------------室内定位-------------------------------
    
    //房间加载时的彩色进度条
    CGRect frame = CGRectMake(0, 0.0f, Drive_Wdith, 3.0f);
    self.progressView = [[GradientProgressView alloc] initWithFrame:frame];
    [_MainInfoScrollView addSubview:self.progressView];
    _progressView.hidden=NO;
    //室内定位titleView
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 1, Drive_Wdith, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-64, 44.0f)];
    [_labelTitle setBackgroundColor:[UIColor clearColor]];
    _labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    _labelTitle.textColor=[UIColor blackColor];
    
    _labelTitle.text = LOCALIZATION(@"text_indoor_locator");
    
    [titleView addSubview:_labelTitle];
    
    //室内定位条件刷选
    UIButton * listSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-54, 0, 44, 44)];
    //设置按显示图片
    [listSetBtn setImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [listSetBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [listSetBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [listSetBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    listSetBtn.tag=102;
    [titleView addSubview:listSetBtn];
    
    [_MainInfoScrollView addSubview:titleView];
    
    //房间显示选择View
    _organizationShowBtnShowView =[[UIView alloc]initWithFrame:CGRectMake(0, 45, Drive_Wdith, 44)];
    _organizationShowBtnShowView.backgroundColor=[UIColor whiteColor];

    //室内定位显示选择
    NSString *organizationStr=@"****";
    _organizationShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, Drive_Wdith-30, 44)];
    //设置按显示title
    [_organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
    [_organizationShowBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]  forState:UIControlStateNormal];
    //设置按钮title的对齐
    [_organizationShowBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_organizationShowBtn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 20)];
    
    UIImageView * osBtnImgView=[[UIImageView alloc]initWithFrame:CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),15.5,20,13)];
    [osBtnImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    osBtnImgView.tag=218;
    [_organizationShowBtn addSubview:osBtnImgView];
    
    
    //设置按钮背景颜色
    [_organizationShowBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_organizationShowBtn addTarget:self action:@selector(changeRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [_organizationShowBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    _organizationShowBtn.tag=103;
    [_organizationShowBtnShowView addSubview:_organizationShowBtn];
    _organizationShowBtn.hidden=YES;
    [_MainInfoScrollView addSubview:_organizationShowBtnShowView];
    
    //小孩列表
    _childrenListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_MainInfoScrollView.frame)-40, CGRectGetWidth(_MainInfoScrollView.frame), 40)];
    
    //设置按显示title
    [_childrenListBtn setTitle:LOCALIZATION(@"text_kids_list") forState:UIControlStateNormal];
    [_childrenListBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_childrenListBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [_childrenListBtn addTarget:self action:@selector(childrenListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_MainInfoScrollView addSubview:_childrenListBtn];
    
    
    
    //初始化房间信息
    _RoomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 89, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame)-129)];
    
    _RoomTableView.dataSource = self;
    _RoomTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    //隐藏table自带的cell下划线
    _RoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _RoomTableView.backgroundColor=[UIColor whiteColor];
    [_MainInfoScrollView addSubview:_RoomTableView];
    
    //------------------------雷达-------------------------------
    //初始化雷达
//    _RadarPopupSView =[[UIScrollView alloc]initWithFrame:CGRectMake(Drive_Wdith, 109, Drive_Wdith*2 , Drive_Height)];
//    _RadarPopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.4];
//    
//    [_MainInfoScrollView addSubview:_RadarPopupSView];
//    [_RadarPopupSView setHidden:NO];
    
    UIView *radarTitleView=[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith , 0, Drive_Wdith, 90)];
    radarTitleView.backgroundColor=[UIColor clearColor];
    
    // title left label
    _radarLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-150, 54.0f)];
    [_radarLbl setBackgroundColor:[UIColor clearColor]];
    _radarLbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    _radarLbl.textAlignment = NSTextAlignmentLeft;
    _radarLbl.textColor=[UIColor blackColor];
    
    _radarLbl.text = LOCALIZATION(@"text_radar_tracking");
    
    [radarTitleView addSubview:_radarLbl];
    
    
    // title right button
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(Drive_Wdith  - 60, 10, 85, 30)];
    _switchButton.onTintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    [_switchButton setOn:NO];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [radarTitleView addSubview:_switchButton];
    
    // title segmented control
    NSArray *radarSegmentedArray = [[NSArray alloc]initWithObjects:LOCALIZATION(@"text_radar_tracking"),LOCALIZATION(@"text_anti_lost_mode"),nil];
    
    _radarViewSegmentedControl = [[UISegmentedControl alloc]initWithItems:radarSegmentedArray];
    
    _radarViewSegmentedControl.frame = CGRectMake(Drive_Wdith / 2 -125, 45.0, 250.0, 25.0);
    _radarViewSegmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _radarViewSegmentedControl.tintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    
    //style
    _radarViewSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    
    [_radarViewSegmentedControl addTarget:self action:@selector(radarViewSegmentAction:) forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [radarTitleView addSubview:_radarViewSegmentedControl];
    
    [_MainInfoScrollView addSubview:radarTitleView];
    
    //-----------------------------Radar dish-----------------------------
    
    // 1.创建UIScrollView
    _RadarScrollView = [[UIScrollView alloc] init];
    _RadarScrollView.frame = CGRectMake(Drive_Wdith + 5 , 80, Drive_Wdith - 10, Drive_Height - 35 );
    // frame中的size指UIScrollView的可视范围
    _RadarScrollView.showsHorizontalScrollIndicator = NO;
    _RadarScrollView.showsVerticalScrollIndicator = NO;
    _RadarScrollView.backgroundColor = [UIColor clearColor];
    _RadarScrollView.delegate = self;
    [_RadarScrollView setAlpha:0.3];
    CGSize newSize = CGSizeMake(0, self.view.frame.size.height + 1);
    [_RadarScrollView setContentSize:newSize];
    [_MainInfoScrollView addSubview:_RadarScrollView];
    
    //bg_radar_circle
    UIView *radarDishView=[[UIView alloc]initWithFrame:CGRectMake(0 , 0, Drive_Wdith - 10, 200)];
    radarDishView.backgroundColor=[UIColor whiteColor];
    
    _bgRadaCircle = [[UIImageView alloc] initWithFrame:CGRectMake(Drive_Wdith/2 - 90, 10, 180, 180)];
    _bgRadaCircle.image = [UIImage imageNamed:@"bg_radar_circle"];
    
    
    [radarDishView addSubview:_bgRadaCircle];
    
    //bg_radar_rotate
    
    _bgRadarRotate = [[UIImageView alloc] initWithFrame:CGRectMake(Drive_Wdith/2 - 90, 10, 180, 180)];
    _bgRadarRotate.image = [UIImage imageNamed:@"bg_radar_rotate"];
    
    
    //[self rotate360DegreeWithImageView:bgRadarRotate];
    
    [radarDishView addSubview:_bgRadarRotate];
    
    
    
    [_RadarScrollView addSubview:radarDishView];
    
    //------------------------------Radar table---------------------------
    
    //radar foot view
    UIView *radarConnectView =[[UIView alloc]initWithFrame:CGRectMake(0, 205, Drive_Wdith-10, 44)];
    radarConnectView.backgroundColor=[UIColor clearColor];
    [_RadarScrollView addSubview:radarConnectView];
    
    //connect table
    _connectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(radarConnectView.bounds)/2, 48)];
    //设置按显示图片
    [_connectBtn setTitle:[NSString stringWithFormat:@"%d %@",connectNum,LOCALIZATION(@"btn_supervised")]   forState:UIControlStateNormal];
    [_connectBtn setTitleColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1] forState:UIControlStateNormal];
    [_connectBtn setTitleColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1] forState:UIControlStateSelected];
    [_connectBtn setSelected:YES];
    
    _tickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27,14,20,20)];
    _tickImageView.image = [UIImage imageNamed:@"tick"];
    [_connectBtn addSubview:_tickImageView];
    //image view
    //NSLog(@"[self getCurrentAppLanguage]- -->%@",[self getCurrentAppLanguage]);
    if ([[self getCurrentAppLanguage]isEqualToString:@"en"] || [[self getCurrentSystemLanguage]isEqualToString:@"en"] || [[self getCurrentAppLanguage]isKindOfClass:[NSNull class]]) {
        _tickImageView.hidden = YES;
    }else{
      
         _tickImageView.hidden = NO;
    }
    
    
    //font size
    //_connectBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    
    //设置按钮背景颜色
    [_connectBtn setBackgroundColor:[UIColor whiteColor]];
    //设置按钮是否圆角
    [_connectBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_connectBtn.layer setCornerRadius:4.0];
    //设置按钮响应事件
    [_connectBtn addTarget:self action:@selector(radarConnectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [radarConnectView addSubview:_connectBtn];
    
    //间隔线2
    _RadarDivisionTwoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(_connectBtn.bounds)-7, CGRectGetWidth(_connectBtn.bounds), 3)];
    [_RadarDivisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    [_connectBtn addSubview:_RadarDivisionTwoLbl];
    
    
    //disconnect table
    _disconnectBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(radarConnectView.bounds)/2, 0, CGRectGetWidth(radarConnectView.bounds)/2, 48)];
    //设置按显示图片
    [_disconnectBtn setTitle:[NSString stringWithFormat:@"%d %@",disconnectNum,LOCALIZATION(@"btn_missed")] forState:UIControlStateNormal];
    [_disconnectBtn setTitleColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1] forState:UIControlStateNormal];
    [_disconnectBtn setTitleColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1] forState:UIControlStateSelected];
    
    //image view
    _crossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17,14,20,20)];
    _crossImageView.image = [UIImage imageNamed:@"cross2"];
    [_disconnectBtn addSubview:_crossImageView];
    if ([[self getCurrentAppLanguage]isEqualToString:@"en"] || [[self getCurrentSystemLanguage]isEqualToString:@"en"]) {
        _crossImageView.hidden = YES;
    }else{
        _crossImageView.hidden = NO;
    }
    
    
    
    //_disconnectBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    
    //设置按钮背景颜色
    [_disconnectBtn setBackgroundColor:[UIColor whiteColor]];
    //设置按钮是否圆角
    [_disconnectBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_disconnectBtn.layer setCornerRadius:4.0];
    
    //设置按钮响应事件
    [_disconnectBtn addTarget:self action:@selector(radarDisconnectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [radarConnectView addSubview:_disconnectBtn];
    
    //间隔线
    UILabel *radarDivisionLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(radarConnectView.bounds)/2, 0.0f, 1, 48)];
    [radarDivisionLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [radarConnectView addSubview:radarDivisionLbl];
    
    
    //间隔线4
    _radarDivisionFourLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_disconnectBtn.bounds)-5, CGRectGetWidth(_disconnectBtn.bounds), 1)];
    [_radarDivisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_disconnectBtn addSubview:_radarDivisionFourLbl];
    

    _RadarConnectTableView = [[UITableView alloc]init];
    _RadarDisconnectTableView = [[UITableView alloc]init];
    
    
    //anti lost table view
    _antiLostTb = [[UITableView alloc]init];
  

    
    //------------------------简报-------------------------------
    
    //简报名称
    UIView *NewsView=[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith * 2, 0, Drive_Wdith, 54)];
    NewsView.backgroundColor=[UIColor clearColor];
    
    _NewsLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 54.0f)];
    [_NewsLbl setBackgroundColor:[UIColor clearColor]];
    _NewsLbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    _NewsLbl.textAlignment = NSTextAlignmentLeft;
    _NewsLbl.textColor=[UIColor blackColor];
    
    _NewsLbl.text = LOCALIZATION(@"text_report");
    
    [NewsView addSubview:_NewsLbl];
    
    //选择要查看的儿童
    _NewsKidBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith - 92, 5, 72, 44)];
    
    //设置按钮背景颜色
    [_NewsKidBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    
    //    [NewsBtn addTarget:self action:@selector(reportViewChangeChildBtmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_NewsKidBtn addTarget:self action:@selector(showChildrenList) forControlEvents:UIControlEventTouchUpInside];
    
    
    [NewsView addSubview:_NewsKidBtn];
    
    [_MainInfoScrollView addSubview:NewsView];
    //kids头像
    kidImgView=[[DBImageView alloc] initWithFrame:CGRectMake(0, 7, 30, 30)];
    [kidImgView.layer setCornerRadius:CGRectGetHeight([kidImgView bounds]) / 2];
    [kidImgView.layer setMasksToBounds:YES];
    [kidImgView.layer setBorderWidth:2];
    
    [kidImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    //    [kidImgView setImage:[UIImage imageNamed:@"20150207105906"]];
    //    kindImgView.tag=206;
    [_NewsKidBtn addSubview:kidImgView];
    kidImgView.hidden=YES;
    
    
    
    
    _revampLbl = [[UILabel alloc] initWithFrame:CGRectMake(32.0f, 0.0f, CGRectGetWidth(_NewsKidBtn.bounds)-42, 44.0f)];
    [_revampLbl setBackgroundColor:[UIColor clearColor]];
    _revampLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    _revampLbl.textAlignment = NSTextAlignmentLeft;
    _revampLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    _revampLbl.text = LOCALIZATION(@"text_change");
    
    [_NewsKidBtn addSubview:_revampLbl];
    if(_revampLbl.text.length>2)
    {
        
        _NewsKidBtn.frame=CGRectMake(Drive_Wdith  -((_revampLbl.text.length*9)+55), 5, (_revampLbl.text.length*9)+45, 44);
        _revampLbl.frame=CGRectMake(32.0f, 0.0f, (_revampLbl.text.length*9), 44.0f);
    }
    
    UIImageView * ImgView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_NewsKidBtn.bounds)-12, 14, 12, 16)];
    [ImgView setImage:[UIImage imageNamed:@"arrow_go"]];
        ImgView.tag=99;
    [_NewsKidBtn addSubview:ImgView];
    
    
    //通告标题
    UIView *changeView =[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith * 2 +10, 54, Drive_Wdith-20, 44)];
    changeView.backgroundColor=[UIColor clearColor];
    [_MainInfoScrollView addSubview:changeView];
    
    //表现
    _performanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(changeView.bounds)/2, 48)];
    //设置按显示图片
    [_performanceBtn setTitle:LOCALIZATION(@"btn_performance") forState:UIControlStateNormal];
    [_performanceBtn setTitleColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1] forState:UIControlStateNormal];
    [_performanceBtn setTitleColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1] forState:UIControlStateSelected];
    [_performanceBtn setSelected:YES];
    //设置按钮背景颜色
    [_performanceBtn setBackgroundColor:[UIColor whiteColor]];
    //设置按钮是否圆角
    [_performanceBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_performanceBtn.layer setCornerRadius:4.0];
    //设置按钮响应事件
    [_performanceBtn addTarget:self action:@selector(showPerformanceAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeView addSubview:_performanceBtn];
    
    //间隔线2
    _divisionTwoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(_performanceBtn.bounds)-7, CGRectGetWidth(_performanceBtn.bounds), 3)];
    [_divisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    
    [_performanceBtn addSubview:_divisionTwoLbl];
    
    //活动
    _activitiesBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(changeView.bounds)/2, 0, CGRectGetWidth(changeView.bounds)/2, 48)];
    //设置按显示图片
    [_activitiesBtn setTitle:LOCALIZATION(@"btn_activities") forState:UIControlStateNormal];
    [_activitiesBtn setTitleColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1] forState:UIControlStateNormal];
    [_activitiesBtn setTitleColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1] forState:UIControlStateSelected];
    
    //设置按钮背景颜色
    [_activitiesBtn setBackgroundColor:[UIColor whiteColor]];
    //设置按钮是否圆角
    [_activitiesBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [_activitiesBtn.layer setCornerRadius:4.0];
    
    //设置按钮响应事件
    [_activitiesBtn addTarget:self action:@selector(showaActivitiesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [changeView addSubview:_activitiesBtn];
    
    //间隔线
    UILabel *divisionLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(changeView.bounds)/2, 0.0f, 1, 48)];
    [divisionLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [changeView addSubview:divisionLbl];
    
    
    
    
    //间隔线4
    _divisionFourLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_activitiesBtn.bounds)-5, CGRectGetWidth(_activitiesBtn.bounds), 1)];
    [_divisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_activitiesBtn addSubview:_divisionFourLbl];
    
    
    
    //选择显示范围
    _PerformanceTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith * 2 +10, 98, CGRectGetWidth(_MainInfoScrollView.frame)-20, 40)];
    //设置按钮背景颜色
    [_PerformanceTimeBtn setBackgroundColor:[UIColor whiteColor]];
    
    //设置按钮响应事件
    [_PerformanceTimeBtn addTarget:self action:@selector(dateChageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_MainInfoScrollView addSubview:_PerformanceTimeBtn];
    
    
    
    //间隔线3
    UILabel *divisionThreeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(_PerformanceTimeBtn.bounds)-1, CGRectGetWidth(_PerformanceTimeBtn.bounds)-20, 1)];
    [divisionThreeLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_PerformanceTimeBtn addSubview:divisionThreeLbl];
    
    //本日色块
    UILabel *todayColorLbl = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 14.0f, 14.0f, 14.0f)];
    [todayColorLbl setBackgroundColor:[UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1]];
    [_PerformanceTimeBtn addSubview:todayColorLbl];
    //本日
    NSString *str=LOCALIZATION(@"text_today");
    _todayLbl = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 14.0f, (str.length>2?str.length*8.0f:str.length*15), 16.0f)];
    [_todayLbl setBackgroundColor:[UIColor clearColor]];
    _todayLbl.font=[UIFont fontWithName:@"Helvetica" size:14];
    _todayLbl.textAlignment = NSTextAlignmentLeft;
    _todayLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    _todayLbl.text = [str copy];
    [_PerformanceTimeBtn addSubview:_todayLbl];
    
    
    //自定义色块 todayLbl.bounds
    _customizedColorLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_todayLbl.bounds)+_todayLbl.frame.origin.x+5, 14.0f, 14.0f, 14.0f)];
    [_customizedColorLbl setBackgroundColor:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]];
    [_PerformanceTimeBtn addSubview:_customizedColorLbl];
    //自定义
    NSString *str2=LOCALIZATION(@"text_customized");
    _customizedLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_customizedColorLbl.bounds)+_customizedColorLbl.frame.origin.x+5, 14.0f, (str2.length>4?str2.length*7.5f:str2.length*15), 16.0f)];
    [_customizedLbl setBackgroundColor:[UIColor clearColor]];
    _customizedLbl.font=[UIFont fontWithName:@"Helvetica" size:14];
    _customizedLbl.textAlignment = NSTextAlignmentLeft;
    _customizedLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    _customizedLbl.text = [str2 copy];
    [_PerformanceTimeBtn addSubview:_customizedLbl];
    
    NSString *str3=LOCALIZATION(@"this_Week");
    //查询条件
    _conditionLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_customizedLbl.bounds)+_customizedLbl.frame.origin.x, 14.0f, (str3.length>2?str3.length*8.0f:str3.length*15), 16.0f)];
    [_conditionLbl setBackgroundColor:[UIColor clearColor]];
    _conditionLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    _conditionLbl.textAlignment = NSTextAlignmentLeft;
    _conditionLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    _conditionLbl.text = [str3 copy];
    [_PerformanceTimeBtn addSubview:_conditionLbl];
    str=nil;
    str2=nil;
    str3=nil;
    _conditionImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_conditionLbl.bounds)+_conditionLbl.frame.origin.x, 15.5,20,13)];
    [_conditionImgView setImage:[UIImage imageNamed:@"arrow_down"]];
    [_PerformanceTimeBtn addSubview:_conditionImgView];
    
    
    //初始化表现列表
    _PerformanceTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith * 2 +10, 138, CGRectGetWidth(_MainInfoScrollView.frame)-20, CGRectGetHeight(_MainInfoScrollView.frame)-138)];
    _PerformanceTableView.dataSource = self;
    _PerformanceTableView.delegate = self;
    //隐藏table自带的cell下划线
    _PerformanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_PerformanceTableView];
    //    _PerformanceTableView.hidden=YES;
    
    
    
    //初始化活动列表
    _ActivitiesTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith * 2 +10, 98, CGRectGetWidth(_MainInfoScrollView.frame)-20, CGRectGetHeight(_MainInfoScrollView.frame)-98)];
    _ActivitiesTableView.dataSource = self;
    _ActivitiesTableView.delegate = self;
    self.ActivitiesTableView.tableFooterView = [[UIView alloc] init];
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_ActivitiesTableView];
    _ActivitiesTableView.hidden=YES;
    
    _bulletinLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, Drive_Wdith -20, 30)];
    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
    _bulletinLbl.textColor=[UIColor blackColor];
    _bulletinLbl.font=[UIFont systemFontOfSize:16];
    _bulletinLbl.textAlignment=NSTextAlignmentCenter;
    //    [_MainInfoScrollView addSubview:_bulletinLbl];
    [self.view addSubview:_bulletinLbl];
    _bulletinLbl.hidden=YES;
    
    //------------------------个人信息-------------------------------
    
    
    //用户名
    UIView *PersonageView=[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 0, Drive_Wdith, 54)];
    PersonageView.backgroundColor=[UIColor clearColor];
    
    _UserNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 54.0f)];
    [_UserNameLbl setBackgroundColor:[UIColor clearColor]];
    _UserNameLbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    _UserNameLbl.textAlignment = NSTextAlignmentLeft;
    _UserNameLbl.textColor=[UIColor blackColor];
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    
    _UserNameLbl.text = [userDefaultes objectForKey:LoginViewController_name];
    
    [PersonageView addSubview:_UserNameLbl];
    
    //室内定位条件刷选
    UIButton * SettingBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-54, 5, 44, 44)];
    //设置按显示图片
    [SettingBtn setImage:[UIImage imageNamed:@"btn_settings"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [SettingBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [SettingBtn addTarget:self action:@selector(goToSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [PersonageView addSubview:SettingBtn];
    
    
    [_MainInfoScrollView addSubview:PersonageView];
    
    //通告标题
    UIView *PersonageTitleView =[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 54, Drive_Wdith, 30)];
    PersonageTitleView.backgroundColor=[UIColor whiteColor];
    
    _PersonageLbl = [[UILabel alloc] initWithFrame:CGRectMake(-1.0f, -1.0f, Drive_Wdith+2, 31.0f)];
    [_PersonageLbl setBackgroundColor:[UIColor clearColor]];
    _PersonageLbl.font=[UIFont fontWithName:@"Helvetica" size:16];
    _PersonageLbl.textAlignment = NSTextAlignmentCenter;
    _PersonageLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    [_PersonageLbl.layer setBorderWidth:1.0]; //边框宽度
    [_PersonageLbl.layer setBorderColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1].CGColor];//边框颜色
    _PersonageLbl.text = LOCALIZATION(@"text_notifications");
    
    [PersonageTitleView addSubview:_PersonageLbl];
    [_MainInfoScrollView addSubview:PersonageTitleView];
    
    //初始化个人信息
    _PersonageTableView= [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 84, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    _PersonageTableView.dataSource = self;
    _PersonageTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_PersonageTableView];
    
    
    //------------------------遮盖层------------------------
    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    

    //弹出遮盖层
    _PopRoomSosSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, Drive_Wdith, Drive_Height)];
    _PopRoomSosSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopRoomSosSView];
    [_PopRoomSosSView setHidden:YES];
    
    /* pop View Container */
    _popRoomViewContainer=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-140, Drive_Wdith-10, 176)];
    [_popRoomViewContainer setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_popRoomViewContainer.layer setMasksToBounds:YES];
    //圆角像素化
    [_popRoomViewContainer.layer setCornerRadius:4.0];
    [_PopRoomSosSView addSubview:_popRoomViewContainer];
    
    //pop view dividing top line
    UILabel * popTopLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_popRoomViewContainer.frame)/2 + 45, CGRectGetWidth(_popRoomViewContainer.frame) - 20, 1)];
    [popTopLabel.layer setBorderWidth:1.0]; //边框宽度
    [popTopLabel.layer setBorderColor:[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3].CGColor];
    [_popRoomViewContainer addSubview:popTopLabel];
    
    
    UIImageView *sosImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_popRoomViewContainer.frame) /2 - 50,  CGRectGetHeight(_popRoomViewContainer.frame)/2 - 75 , 100, 100)
                          ];
    
    sosImg.image = [UIImage imageNamed:@"btn_funcbarbeepred"];
    [_popRoomViewContainer addSubview:sosImg];
    
    
    UIButton *confirmRoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(0 , 134 ,CGRectGetWidth(_popRoomViewContainer.frame) , 40)];
    //设置按显示文字
    [confirmRoomBtn setTitle:LOCALIZATION(@"btn_confirm") forState:UIControlStateNormal];
    [confirmRoomBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [confirmRoomBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [confirmRoomBtn addTarget:self action:@selector(roomSOSAction) forControlEvents:UIControlEventTouchUpInside];
    [_popRoomViewContainer addSubview:confirmRoomBtn];
    
    
    
    //pop view dividing bottom line
//    UILabel * popBottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_popRoomViewContainer.frame)/2 - 45, CGRectGetWidth(_popRoomViewContainer.frame) - 20, 1)];
//    [popBottomLabel.layer setBorderWidth:1.0]; //边框宽度
//    [popBottomLabel.layer setBorderColor:[UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3].CGColor];
//    [_popRoomViewContainer addSubview:popBottomLabel];

    
    
    //单击空白处关闭遮盖层
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    
    [_PopupSView addGestureRecognizer:self.singleTap];
    
    //房间列表设置列表
    _listTypeView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-88, Drive_Wdith-10, 176)];
    [_listTypeView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_listTypeView.layer setMasksToBounds:YES];
    //圆角像素化
    [_listTypeView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_listTypeView];
    
    
    //儿童信息
    _kidsMassageView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-75, Drive_Wdith-10, 150)];
    [_kidsMassageView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_kidsMassageView.layer setMasksToBounds:YES];
    //圆角像素化
    [_kidsMassageView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_kidsMassageView];
    
    DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 75, 75)];
    [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
    [KidsImgView.layer setMasksToBounds:YES];
    [KidsImgView.layer setBorderWidth:2];
    
    [KidsImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    
    [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
    
    KidsImgView.tag=219;
    [_kidsMassageView addSubview:KidsImgView];
    
    UILabel * kidNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 10, CGRectGetWidth(_kidsMassageView.frame)-100, 20)];
    //[kidNameLbl setText:@"sss"];
    //            [messageLbl setAlpha:0.6];
    [kidNameLbl setFont:[UIFont systemFontOfSize: 15.0]];
    [kidNameLbl setTextColor:[UIColor blackColor]];
    [kidNameLbl setTextAlignment:NSTextAlignmentLeft];
    kidNameLbl.tag=220;
    [_kidsMassageView addSubview:kidNameLbl];
    
    UILabel * roomNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 35, CGRectGetWidth(_kidsMassageView.frame)-100, 40)];
    //[roomNameLbl setText:@"sss"];
    //            [messageLbl setAlpha:0.6];
    [roomNameLbl setFont:[UIFont systemFontOfSize: 12.0]];
    [roomNameLbl setTextColor:[UIColor blackColor]];
    [roomNameLbl setTextAlignment:NSTextAlignmentLeft];
    roomNameLbl.numberOfLines = 2;
    roomNameLbl.tag=221;
    [_kidsMassageView addSubview:roomNameLbl];
    
    //间隔线
    divisionRadarLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_kidsMassageView.frame)-41, CGRectGetWidth(_kidsMassageView.frame), 1)];
    [divisionRadarLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_kidsMassageView addSubview:divisionRadarLbl];
    
    
    //map button
    UIButton * mapBtn=[[UIButton alloc]initWithFrame:CGRectMake(90, 74, (Drive_Wdith/2) - 10 , Drive_Wdith/8 - 10)];
    [mapBtn setTitle:LOCALIZATION(@"btn_map") forState:UIControlStateNormal];
    [mapBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    
    [mapBtn addTarget:self action:@selector(mapAction) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [mapBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [mapBtn.layer setCornerRadius:4.0];
    [mapBtn.layer setBorderWidth:1.0]; //边框宽度
    [mapBtn.layer setBorderColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1].CGColor];//边框颜色
    [_kidsMassageView addSubview:mapBtn];
    
    //提交按钮
    _closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_kidsMassageView.frame)-40,CGRectGetWidth(_kidsMassageView.frame), 40)];
    //设置按显示文字
    [_closeBtn setTitle:LOCALIZATION(@"btn_back") forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_closeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_kidsMassageView addSubview:_closeBtn];
    
    
    
    
    
    
    //机构显示选择列表
    _organizationTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 132, Drive_Wdith-40, 44)];
    [_organizationTableView setBackgroundColor:[UIColor whiteColor] ];
    _organizationTableView.dataSource = self;
    _organizationTableView.delegate = self;
    [_organizationTableView.layer setBorderWidth:2.0]; //边框宽度
    [_organizationTableView.layer setBorderColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:0.4].CGColor];//边框颜色
    //隐藏table自带的cell下划线
    //    _organizationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_PopupSView addSubview:_organizationTableView];
    
    
    //时间段选择
    _dateTableView=[[UITableView alloc]initWithFrame:CGRectMake((Drive_Wdith-20)/2-10, 176, (Drive_Wdith-20)/2, 132)];
    [_dateTableView setBackgroundColor:[UIColor whiteColor] ];
    _dateTableView.dataSource = self;
    _dateTableView.delegate = self;
    [_dateTableView.layer setBorderWidth:2.0]; //边框宽度
    [_dateTableView.layer setBorderColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:0.4].CGColor];//边框颜色
    //隐藏table自带的cell下划线
    //    _organizationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_PopupSView addSubview:_dateTableView];
    
    
    //设定title
    _listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_listTypeView.frame), 44)];
    [_listtitleLal setText:LOCALIZATION(@"btn_options")];
    [_listtitleLal setTextColor:[UIColor blackColor]];
    [_listtitleLal setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [_listtitleLal setTextAlignment:NSTextAlignmentCenter];
    [_listtitleLal setBackgroundColor:[UIColor clearColor]];
    [_listTypeView addSubview:_listtitleLal];
    
    _listTypeTableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(_listTypeView.frame), 88)];
    _listTypeTableView.dataSource = self;
    _listTypeTableView.delegate = self;
    //设置table是否可以滑动
    _listTypeTableView.scrollEnabled = NO;
    //隐藏table自带的cell下划线
    //    _listTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTypeView addSubview:_listTypeTableView];
    
    //提交按钮
    _listTypeChangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 134,CGRectGetWidth(_listTypeView.frame), 40)];
    //设置按显示文字
    [_listTypeChangeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [_listTypeChangeBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_listTypeChangeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_listTypeChangeBtn addTarget:self action:@selector(SaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_listTypeView addSubview:_listTypeChangeBtn];
    
    _FeekBackView =[[UIView alloc]initWithFrame:CGRectMake(5, 50, Drive_Wdith-10, 267)];
    _FeekBackView.backgroundColor=[UIColor whiteColor];
    //设置按钮是否圆角
    [_FeekBackView.layer setMasksToBounds:YES];
    //圆角像素化
    [_FeekBackView.layer setCornerRadius:4.0];
    _FeekBackView.center=self.view.center;
    [_PopupSView addSubview:_FeekBackView];
    _FeekBackView.hidden=YES;
    
    
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


//重写UIGestureRecognizerDelegate,解决UITapGestureRecognizer与didSelectRowAtIndexPath冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}



#pragma mark -
#pragma mark-------------Tableview delegate--------

/**tableViewCell的高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //房间列表
    if(tableView == self.RoomTableView){
        //                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        if([cell viewWithTag:201]!=nil)
        {
            NSArray *tempChildArray;
            if (self.isallRoomOn==YES) {
                tempChildArray=[_childrenDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
            }
            else
            {
                tempChildArray=[_childrenByRoomDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
            }
            //儿童图标行数
            int kindRow =0;
            if (tempChildArray.count>0) {
                kindRow =tempChildArray.count%4>0?tempChildArray.count/4:tempChildArray.count/4-1;
            }
            
            
            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
            return (130+(((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*kindRow));
            tempChildArray=nil;
        }
        else
        {
            return 110;
        }
    }
    
    if(tableView == self.RadarConnectTableView){
        
        return 45;
    }else if (tableView == self.RadarDisconnectTableView){
         return 45;
    }else if (tableView == self.antiLostTb){
        return 45;
    }
    
    else if(tableView == self.ActivitiesTableView){
        
        return 100;
        
        
    }
    else if(tableView == self.PersonageTableView){
        return 100;
    }
    else if(tableView == self.PerformanceTableView){
        return 100;
    }
    else if(tableView == self.dateTableView){
        return 44;
    }
    
    
    return 44;
    
    
    
    
}

/**table需要显示的行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //房间列表
    if(tableView == self.RoomTableView){
        
        return _roomArray.count;
        
        
    }
    else if(tableView == self.RadarConnectTableView){
    
    
        
        return _connectKidsByScanedAy.count;
    }
    else if (tableView == self.RadarDisconnectTableView){
        
     
        
        return _tempDisconnectKidsAy.count;
    }else if (tableView == self.antiLostTb){
        return myDelegate.antiLostSelectedKidsAy.count;
    }
    else if(tableView == self.ActivitiesTableView){
        return _activityInfosArray.count;
    }
    else if(tableView == self.PersonageTableView){
        return (_personalDetailsArray.count+1);
    }
    else if(tableView == self.listTypeTableView){
        return 2;
    }
    else if(tableView == self.organizationTableView){
        return _organizationArray.count;
    }
    else if(tableView == self.PerformanceTableView){
        return _dailyAvgFigureArray.count;
    }
    else if(tableView == self.dateTableView){
        return 3;
    }
    else{
        return  0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    int row=indexPath.row;
    //    NSString *CellIdentifier;
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //房间列表显示/刷新设置
    if(tableView == self.antiLostTb){
        int row = indexPath.row;
        NSDictionary *tempChildDictionary=[NSDictionary dictionary];
        
        
        tempChildDictionary=[myDelegate.antiLostSelectedKidsAy  objectAtIndex:row];
        
//        NSLog(@"myDelegate.antiLostSelectedKidsAy -> %@",myDelegate.antiLostSelectedKidsAy);

        
      
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
            
            //儿童图标
            DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 2.5, 40, 40)];
            [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
            [KidsImgView.layer setMasksToBounds:YES];
            [KidsImgView.layer setBorderWidth:2];
            
            [KidsImgView.layer setBorderColor:[UIColor redColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            [KidsImgView setImageWithPath:[pathOne copy]];
            pathOne=nil;
            
            KidsImgView.tag=701;
            [cell addSubview:KidsImgView];
            
            
            
            //儿童名称
            UILabel * KidsLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 5, CGRectGetWidth(cell.frame)-80, 20)];
            
            [KidsLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [KidsLbl setTextColor:[UIColor blackColor]];
            [KidsLbl setTextAlignment:NSTextAlignmentLeft];
            KidsLbl.tag=702;
            [cell addSubview:KidsLbl];
            
            
            //device status
            
            UILabel * deviceStatusLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 25, CGRectGetWidth(cell.frame)-80, 20)];
            [deviceStatusLbl setText:LOCALIZATION(@"btn_missed")];
            [deviceStatusLbl setFont:[UIFont systemFontOfSize: 13.0]];
            [deviceStatusLbl setTextColor:[UIColor redColor]];
            [deviceStatusLbl setTextAlignment:NSTextAlignmentLeft];
            deviceStatusLbl.tag=703;
            
            [cell addSubview:deviceStatusLbl];
        }
        
        if (isMoreThanThree) {
            //kid image
            DBImageView * KidsImgView=(DBImageView *)[cell viewWithTag:701];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            
            //儿童名称
            UILabel * KidsLbl =(UILabel *)[cell viewWithTag:702];
//            [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
            
            UILabel * kidStatus =(UILabel *)[cell viewWithTag:703];
            [KidsImgView setImageWithPath:[pathOne copy]];
            
            
            [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
            
            for (int y =0 ; y < _localChildInfo.count;  y++) {
                NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
                if ([[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                    if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                        
                        
                        
                        NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                        UIImage *image = [UIImage imageWithData:imageData];
                        [KidsImgView setImage:image];
                        
                        //  NSLog(@"resourcePath  %@",path);
                        
                    }else{
                        
                        
                        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
                        
                        [KidsImgView setImageWithPath:[pathOne copy]];
                    }
                    
                    
                    if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                        
                        
                        
                        [KidsLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
                    }else{
                        
                        
                        [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
                        
                    }
                    
                    
                }
                
            }

            // if miss
            
            [KidsImgView.layer setBorderColor:[UIColor redColor].CGColor];
            [kidStatus setTextColor:[UIColor redColor]];
            [kidStatus setText:LOCALIZATION(@"btn_missed")];

            
            
            for (int i = 0; i < _antiLostMore3scanDataAy.count ; i ++) {
                NSDictionary *tempDic = [NSDictionary dictionary];
                tempDic = [_antiLostMore3scanDataAy objectAtIndex:i];
                if ([NSString stringWithFormat:@"%@", [tempDic objectForKey:@"kCBAdvDataManufacturerData"]].length == 15) {
                    NSString * scanedMajorAndMinor = [[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"kCBAdvDataManufacturerData"]] substringWithRange:NSMakeRange(1, 8)];
                    NSLog(@"tempDic %@",scanedMajorAndMinor);
                    
                    
              
                        NSString *major = [self getMajor:[NSString stringWithFormat:@"%@", [tempChildDictionary objectForKey:@"major"]]];
                        NSString *minor = [self getMinor:[NSString stringWithFormat:@"%@", [tempChildDictionary objectForKey:@"minor"]]];
                        NSString *kidsMajorAndMinor = [NSString stringWithFormat:@"%@%@",minor,major];
                        
                        if ([kidsMajorAndMinor isEqualToString:scanedMajorAndMinor]) {
                        
                            [KidsImgView.layer setBorderColor:[UIColor greenColor].CGColor];
                            [kidStatus setTextColor:[UIColor blackColor]];
                            [kidStatus setText:LOCALIZATION(@"text_network_connecting")];
                    
                        }
                        
                    
                    
                    
                }
            }
            
            
        }else{
            //no more than three
            //kid image
            DBImageView * KidsImgView=(DBImageView *)[cell viewWithTag:701];
            
//            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
//            
//            [KidsImgView setImageWithPath:[pathOne copy]];
            
            //儿童名称
            UILabel * KidsLbl =(UILabel *)[cell viewWithTag:702];
//            [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
            
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            
            [KidsImgView setImageWithPath:[pathOne copy]];
            
                     [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
            for (int y =0 ; y < _localChildInfo.count;  y++) {
                NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
                if ([[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                    if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                        
                        
                        
                        NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                        UIImage *image = [UIImage imageWithData:imageData];
                        [KidsImgView setImage:image];
                        
                        //  NSLog(@"resourcePath  %@",path);
                        
                    }else{
                        
                        
                        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
                        
                        [KidsImgView setImageWithPath:[pathOne copy]];
                    }
                    
                    
                    if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                        
                        
                        
                        [KidsLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
                    }else{
                        
                        
                        [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
                        
                    }
                    
                    
                }
                
            }

            
            
            UILabel * kidStatus =(UILabel *)[cell viewWithTag:703];

            
            if ([antiLostNoMore3 isEqualToString:[NSString stringWithFormat:@"%@%@",[self getMajor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"minor"]]],[self getMinor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"major"]]]]]) {
                
                [KidsImgView.layer setBorderColor:[UIColor redColor].CGColor];
                //change status
                [kidStatus setText:LOCALIZATION(@"btn_missed")];
                [kidStatus setTextColor:[UIColor redColor]];
                
                antiLostNoMore3 = nil;
              
                
            }else if ([reconnectNoMore3 isEqualToString:[NSString stringWithFormat:@"%@%@",[self getMajor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"minor"]]],[self getMinor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"major"]]]]]){
                
                [KidsImgView.layer setBorderColor:[UIColor greenColor].CGColor];
                //change status
                [kidStatus setText:LOCALIZATION(@"text_network_connecting")];
                [kidStatus setTextColor:[UIColor blackColor]];
                reconnectNoMore3 = nil;
                
            }else{
                for (int i = 0; i < antiResultAy.count; i ++) {
                    if ([[NSString stringWithFormat:@"%@",[antiResultAy objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%@%@",[self getMajor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"minor"]]],[self getMinor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"major"]]]]]) {
                        
                        [KidsImgView.layer setBorderColor:[UIColor greenColor].CGColor];
//                        NSLog(@" %@ ---aa",[NSString stringWithFormat:@"%@",[antiResultAy objectAtIndex:i]] );
                        [kidStatus setTextColor:[UIColor blackColor]];
                        [kidStatus setText:LOCALIZATION(@"text_network_connecting")];
                        
                        
                    }
                    
                    //            else{
                    //                [KidsImgView.layer setBorderColor:[UIColor redColor].CGColor];
                    //
                    //            }
                    
                }

            }
        }
        
            
       
        
    }else if (tableView == self.RadarConnectTableView) {
        
        int row = indexPath.row;
        
        NSDictionary *tempChildDictionary=[NSDictionary dictionary];
       // NSDictionary *tempChildRssiDictionary=[NSDictionary dictionary];
   
        tempChildDictionary=[_connectKidsByScanedAy  objectAtIndex:row];
        //tempChildRssiDictionary = [_connectKidsRssiAy  objectAtIndex:row];
        
        //NSLog(@"tempChildDictionary is%@",tempChildDictionary);
        NSLog(@"tempChildDictionary message is%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]);
        
        
        //}
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
            
            //儿童图标
            DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 2.5, 40, 40)];
            [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
            [KidsImgView.layer setMasksToBounds:YES];
            [KidsImgView.layer setBorderWidth:2];
            
            [KidsImgView.layer setBorderColor:[UIColor greenColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            [KidsImgView setImageWithPath:[pathOne copy]];
            pathOne=nil;
            
            KidsImgView.tag=801;
            [cell addSubview:KidsImgView];
            
            
            
            //儿童名称
            UILabel * KidsLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 5, CGRectGetWidth(cell.frame)-80, 20)];
            
            [KidsLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [KidsLbl setTextColor:[UIColor blackColor]];
            [KidsLbl setTextAlignment:NSTextAlignmentLeft];
            KidsLbl.tag=802;
            [cell addSubview:KidsLbl];
            
            
            //device status
            
            UILabel * deviceStatusLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 25, CGRectGetWidth(cell.frame)-80, 20)];
            
            [deviceStatusLbl setFont:[UIFont systemFontOfSize: 13.0]];
      
            [deviceStatusLbl setTextColor:[UIColor blackColor]];
            [deviceStatusLbl setTextAlignment:NSTextAlignmentLeft];
            deviceStatusLbl.tag=803;
            deviceStatusLbl.text = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_weak"),94];
            [cell addSubview:deviceStatusLbl];
        }
        
        //kid image
        DBImageView * KidsImgView=(DBImageView *)[cell viewWithTag:801];
        
//        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
//        
//        [KidsImgView setImageWithPath:[pathOne copy]];
        //儿童名称
        UILabel * KidsLbl =(UILabel *)[cell viewWithTag:802];
//        [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
        
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
        
        [KidsImgView setImageWithPath:[pathOne copy]];
        
             [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
        for (int y =0 ; y < _localChildInfo.count;  y++) {
            NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
            if ([[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                    
                    
                    
                    NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                    UIImage *image = [UIImage imageWithData:imageData];
                    [KidsImgView setImage:image];
                    
                    //  NSLog(@"resourcePath  %@",path);
                    
                }else{
                    
                    
                    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
                    
                    [KidsImgView setImageWithPath:[pathOne copy]];
                }
                
                
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                    
                    
                    
                    [KidsLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
                }else{
                    
                    
                    [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
                    
                }
                
                
            }
            
        }

        
        
        
        //kids rssi
         NSLog(@"namenamename -----------     %@",[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]);
        NSLog(@"_connectKidsRssiAy.count -----------     %lu",(unsigned long)_connectKidsRssiAy.count);
        NSLog(@"---------------- %@",[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]);
        if (_connectKidsRssiAy.count > 0) {
            //set color
            UILabel * KidsdeviceStatusLbl =(UILabel *)[cell viewWithTag:803];
            
             KidsdeviceStatusLbl.text = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_weak"),94];
            
            if ([[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]intValue] > -50) {
                [KidsdeviceStatusLbl setTextColor:[UIColor blackColor]];
            }else if ([[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]intValue] < -50 && [[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]intValue] > - 80){
                [KidsdeviceStatusLbl setTextColor:[UIColor blackColor]];
            }else if ([[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]intValue] < -80){
                [KidsdeviceStatusLbl setTextColor:[UIColor blackColor]];
                
            }
            
            //set text string
            if ([[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]isEqualToString:@"" ] || [[_connectKidsRssiAy objectAtIndex:row] isKindOfClass:[NSNull class]]) {
                  KidsdeviceStatusLbl.text = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_weak"),94];
                
            }else{
               KidsdeviceStatusLbl.text = [self rssiLevel:[[NSString stringWithFormat:@"%@",[_connectKidsRssiAy objectAtIndex:row]]intValue]];
            }
           

        }else{
            
            
            
        }
            // _connectKidsByScanedAy.removeAllObjects;
       
    }

    if (tableView == self.RadarDisconnectTableView) {
        
        int row = indexPath.row;
        
        NSDictionary *tempChildDictionary=[NSDictionary dictionary];
       
        tempChildDictionary=[_tempDisconnectKidsAy  objectAtIndex:row];

        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
            
            //儿童图标
            DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 2.5, 40, 40)];
            [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
            [KidsImgView.layer setMasksToBounds:YES];
            [KidsImgView.layer setBorderWidth:2];
            
            [KidsImgView.layer setBorderColor:[UIColor redColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            [KidsImgView setImageWithPath:[pathOne copy]];
            pathOne=nil;
            
            KidsImgView.tag=901;
            [cell addSubview:KidsImgView];
            
            
            
            //儿童名称
            UILabel * KidsLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 5, CGRectGetWidth(cell.frame)-80, 20)];
            
            [KidsLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [KidsLbl setTextColor:[UIColor blackColor]];
            [KidsLbl setTextAlignment:NSTextAlignmentLeft];
            KidsLbl.tag=902;
            [cell addSubview:KidsLbl];
            
            
            
            
            
            
            //device status

            UILabel * deviceStatusLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 25, CGRectGetWidth(cell.frame)-80, 20)];
            
            [deviceStatusLbl setFont:[UIFont systemFontOfSize: 13.0]];
            [deviceStatusLbl setTextColor:[UIColor redColor]];
            [deviceStatusLbl setTextAlignment:NSTextAlignmentLeft];
            deviceStatusLbl.tag=903;
            deviceStatusLbl.text = LOCALIZATION(@"btn_missed");
            [cell addSubview:deviceStatusLbl];
        }
        
        //kid image
        DBImageView * KidsImgView=(DBImageView *)[cell viewWithTag:901];
        
//        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
//        
//        [KidsImgView setImageWithPath:[pathOne copy]];
        //儿童名称
        UILabel * KidsLbl =(UILabel *)[cell viewWithTag:902];
//        [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
//        
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
        
        [KidsImgView setImageWithPath:[pathOne copy]];
        
                 [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
        for (int y =0 ; y < _localChildInfo.count;  y++) {
            NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
            if ([[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                    
                    
                    
                    NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                    UIImage *image = [UIImage imageWithData:imageData];
                    [KidsImgView setImage:image];
                    
                    //  NSLog(@"resourcePath  %@",path);
                    
                }else{
                    
                    
                    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
                    
                    [KidsImgView setImageWithPath:[pathOne copy]];
                }
                
                
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                    
                    
                    
                    [KidsLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
                }else{
                    
                    
                    [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
                    
                }
                
                
            }
            
        }

        // _tempDisconnectKidsAy.removeAllObjects;
        
    }
    
    
    
    
    if(tableView == self.listTypeTableView)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
        }
        if (indexPath.row==0) {
            if([cell viewWithTag:104]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:LOCALIZATION(@"text_auto_refresh")];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:104];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:104];
                [refreshLbl setText:LOCALIZATION(@"text_auto_refresh")];
            }
            if([cell viewWithTag:105]==nil)
            {
                _refreshImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                [_refreshImgView setImage:[UIImage imageNamed:@"selected_off"]];
                
                [_refreshImgView setTag:105];
                [cell addSubview:_refreshImgView];
                
            }
            else
            {
                
                
                [_refreshImgView setImage:[UIImage imageNamed:@"selected_off"]];
                
            }
            
            
        }
        else if(indexPath.row==1)
        {
            if([cell viewWithTag:106]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:LOCALIZATION(@"text_view_all_room")];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:106];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:106];
                [refreshLbl setText:LOCALIZATION(@"text_view_all_room")];
            }
            
            if([cell viewWithTag:107]==nil)
            {
                _ShowALLRoomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"selected_off"]];
                [_ShowALLRoomImgView setTag:107];
                [cell addSubview:_ShowALLRoomImgView];
                
            }
            else
            {
                
                
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"selected_off"]];
                
            }
        }
        else
        {
            
        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    //选择机构
    else if(tableView == self.organizationTableView){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        }
        switch (myDelegate.applanguage) {
            case 0:
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"name"];
                break;
            case 1:
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"nameTc"];
                break;
            case 2:
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"nameSc"];
                break;
                
            default:
                break;
        }
        
        cell.textLabel.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    }
    //房间列表
    else if(tableView == self.RoomTableView){
        //NSLog(@"sadasdsa (%@)",[self allChildren]);
        //_localChildInfo = [self allChildren];
        NSArray *tempChildArray;
        if (self.isallRoomOn==YES) {
            tempChildArray=[_childrenDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
        }
        else
        {
            tempChildArray=[_childrenByRoomDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
        }
        NSString *str=[NSString stringWithFormat:@"%zi",tempChildArray.count];
        //儿童数量位数
        NSInteger kindNum=str.length>3?3:str.length;
        //儿童图标行数
        int kindRow =0;
        if (tempChildArray.count>0) {
            kindRow =tempChildArray.count%4>0?tempChildArray.count/4:tempChildArray.count/4-1;
        }
        
        if(_dateFormatter==nil)
        {
            _dateFormatter=[[NSDateFormatter alloc] init];
        }
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //当前时间
        NSDate *senderDate = [_dateFormatter dateFromString:[_dateFormatter stringFromDate:[NSDate date]]];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            //            NSLog(@"cell.frame.size.height is %f",cell.frame.size.height);
            UIButton * RoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, 100+((CGRectGetWidth(cell.frame)-10-130)/4+8)*kindRow)];
            
            //设置按钮背景颜色
            if(indexPath.row>9)
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:(indexPath.row%10)]];
            }
            else
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            }
            
            //设置按钮响应事件
            [RoomBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
            //设置按钮是否圆角
            [RoomBtn.layer setMasksToBounds:YES];
            //圆角像素化
            [RoomBtn.layer setCornerRadius:4.0];
            RoomBtn.tag=201;
            [cell addSubview:RoomBtn];
            
            
            
            
            //房间图标
            
        
            DBImageView * RoomImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            [RoomImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            
            
            [RoomImgView.layer setCornerRadius:CGRectGetHeight([RoomImgView bounds]) / 2];
            [RoomImgView.layer setMasksToBounds:YES];
            [RoomImgView.layer setBorderWidth:2];
            
            [RoomImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];
              if (![[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"] isKindOfClass:[NSNull class]] ) {
                   [RoomImgView setImageWithPath:[pathOne copy]];
              }
           
            pathOne=nil;
            
            RoomImgView.tag=202;
            [RoomBtn addSubview:RoomImgView];
            
            //房间名称
            UILabel * RoomLbl =[[UILabel alloc]initWithFrame:CGRectMake(72, 17, CGRectGetWidth(cell.frame)-100, 20)];
            
            
            if (_roomArray.count>0) {
                
                switch (myDelegate.applanguage) {
                    case 0:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"locationName"]];
                        break;
                    case 1:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]];
                        break;
                    case 2:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]];
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            else
            {
                [RoomLbl setText:@"*****"];
            }
            [RoomLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [RoomLbl setTextColor:[UIColor whiteColor]];
            [RoomLbl setTextAlignment:NSTextAlignmentLeft];
            RoomLbl.tag=203;
            [RoomBtn addSubview:RoomLbl];
            
            //当前房间人数
            UIView * roomKindNumView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20)];
            //设置按钮是否圆角
            [roomKindNumView.layer setMasksToBounds:YES];
            //圆角像素化
            [roomKindNumView.layer setCornerRadius:8.5];
            [roomKindNumView setBackgroundColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:0.5]];
            roomKindNumView.tag=204;
            [RoomBtn addSubview:roomKindNumView];
            
            UIImageView *numImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 1, 16, 16)];
            [numImgView setImage:[UIImage imageNamed:@"ppl_no"]];
            //            [numImgView setAlpha:0.5];
            [roomKindNumView addSubview:numImgView];
            
            
            //房间开关
            UISwitch *switchRoomButton = [[UISwitch alloc] initWithFrame:CGRectMake(15, 85, 60, 60)];
            switchRoomButton.onTintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
            
            for (int i = 0 ;i < _roomSosNumber.count ; i ++) {
                if ([[NSString stringWithFormat:@"%@",[_roomSosNumber objectAtIndex:i]]isEqualToString:[NSString stringWithFormat:@"%zi",indexPath.row]]) {
                    [switchRoomButton setOn:YES];
                }
            }

            
          
            [switchRoomButton addTarget:self action:@selector(switchRoomAction:) forControlEvents:UIControlEventValueChanged];
            
            switchRoomButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [cell addSubview:switchRoomButton];
            
            
            //房间孩子数量
            UILabel * KindNumLbl =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, CGRectGetWidth(roomKindNumView.frame)-35, 20)];
            [KindNumLbl setText:str];
            [KindNumLbl setAlpha:0.6];
            [KindNumLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [KindNumLbl setTextColor:[UIColor whiteColor]];
            [KindNumLbl setTextAlignment:NSTextAlignmentLeft];
            KindNumLbl.tag=205;
            [roomKindNumView addSubview:KindNumLbl];
            
            
            
            
            //儿童图标行数
            for (int i = 0 ;i < _roomSosNumber.count ; i ++) {
                if ([[NSString stringWithFormat:@"%@",[_roomSosNumber objectAtIndex:i]]isEqualToString:[NSString stringWithFormat:@"%zi",indexPath.row]]) {
                    if (tempChildArray.count > 0) {
                        
                        [self playSound];
                        [_PopRoomSosSView setHidden:NO];
                        
                        
                    }
                }
            }
            
            
            int sNum=0;
            for (int i=0; i<tempChildArray.count; i++) {
                
                
                if (i>0&&i%4==0) {
                    sNum++;
                }
                
                DBImageView * kindImgView=[[DBImageView alloc] initWithFrame:CGRectMake(72+((CGRectGetWidth(RoomBtn.frame)-130)/4+10)*(i%4),45+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*sNum , (CGRectGetWidth(RoomBtn.frame)-130)/4, (CGRectGetWidth(RoomBtn.frame)-130)/4)];
                [kindImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
                
                
                [kindImgView.layer setCornerRadius:CGRectGetHeight([kindImgView bounds]) / 2];
                [kindImgView.layer setMasksToBounds:YES];
                [kindImgView.layer setBorderWidth:2];
                
                [kindImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
                NSString* pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]];
                //NSLog(@"[tempChildArray objectAtIndex:i]-->%@",[tempChildArray objectAtIndex:i]);
                 if (![[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] isKindOfClass:[NSNull class]] ) {
                     [kindImgView setImageWithPath:[pathOne copy]];
                     
                     
                     
                     for (int y =0 ; y < _localChildInfo.count;  y++) {
                         NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
                         
                         NSLog(@"localChildInfo.count -- >%@",[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]);
                         if ([[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                             
                             
                             if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                                 
                                 
                                 
                                 NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                                 UIImage *image = [UIImage imageWithData:imageData];
                                 [kindImgView setImage:image];
                                 
                                 //  NSLog(@"resourcePath  %@",path);
                                 
                             }else{
                                 
                                 
                                 [kindImgView setImageWithPath:[pathOne copy]];
                             }
                             
                         }
                         
                     }

                 }
                
             
                
                
                //[kindImgView setImageWithPath:[pathOne copy]];
                {
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([[[tempChildArray objectAtIndex:i] objectForKey:@"lastAppearTime"]doubleValue] / 1000)];
                    //得到相差秒数
                    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
                    int minute = ((int)time>0?(int)time:-((int)time))/60;
                    
                    
                    if (minute>10) {
                        [kindImgView setAlpha:0.5];
                    }
                }
                [RoomBtn addSubview:kindImgView];
                
                //儿童图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                kindBtn.frame=kindImgView.frame;
                
                [kindBtn setBackgroundColor:[UIColor clearColor]];
                
                
                
                
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKindAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000+i;
                [RoomBtn addSubview:kindBtn];
                
            

            
            }
            
            
        }
        if(indexPath.row==5)
        {
            
        }
        if ([cell viewWithTag:201]!=nil) {
            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
            RoomBtn.frame=CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, 120+((CGRectGetWidth(cell.frame)-10-130)/4+8)*kindRow);
            if(indexPath.row>9)
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:(indexPath.row%10)]];
            }
            else
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            }
            
            for (UIView *view in [RoomBtn subviews])
            {
                //                NSLog(@"view.tag is%d",view.tag);
                
                if ([view isKindOfClass:[UIView class]])
                {
                    [view removeFromSuperview];
                }
                
                //            DBImageView * RoomImgView=(DBImageView *)[RoomBtn viewWithTag:202];
                //            [RoomImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
                //            NSString* pathOne =[NSString stringWithFormat: @"%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];
                //
                //                [RoomImgView setImageWithPath:[pathOne copy]];
                //
                //            pathOne=nil;
                //
                //            UILabel * RoomLbl=(UILabel *)[RoomBtn viewWithTag:203];
                //            if (_roomArray.count>0) {
                //
                //                switch (myDelegate.applanguage) {
                //                    case 0:
                //                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]];
                //                        break;
                //                    case 1:
                //                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]];
                //                        break;
                //                    case 2:
                //                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"namec"]];
                //                        break;
                //
                //                    default:
                //                        break;
                //                }
                //            }
                //            else
                //            {
                //                [RoomLbl setText:@"*****"];
                //            }            //            [LoginBtn setAlpha:0.4];
                //
            }
            
            //            UIView * roomKindNumView=(UIView *)[RoomBtn viewWithTag:204];
            //            roomKindNumView.frame=CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20);
            //            UILabel * KindNumLbl=(UILabel *)[RoomBtn viewWithTag:205];
            //            KindNumLbl.frame=CGRectMake(30, 0, CGRectGetWidth(roomKindNumView.frame)-35, 20);
            //            [KindNumLbl setText:str];
            
            
            //房间图标
            
            
            DBImageView * RoomImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            [RoomImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            
            
            [RoomImgView.layer setCornerRadius:CGRectGetHeight([RoomImgView bounds]) / 2];
            [RoomImgView.layer setMasksToBounds:YES];
            [RoomImgView.layer setBorderWidth:2];
            
            [RoomImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];
            if (![[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"] isKindOfClass:[NSNull class]] ) {
                [RoomImgView setImageWithPath:[pathOne copy]];
            }

            pathOne=nil;
            
            RoomImgView.tag=202;
            [RoomBtn addSubview:RoomImgView];
            
            //房间名称
            UILabel * RoomLbl =[[UILabel alloc]initWithFrame:CGRectMake(72, 17, CGRectGetWidth(cell.frame)-100, 20)];
            
            
            if (_roomArray.count>0) {
                
                switch (myDelegate.applanguage) {
                    case 0:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"locationName"]];
                        break;
                    case 1:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]];
                        break;
                    case 2:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]];
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            else
            {
                [RoomLbl setText:@"*****"];
            }
            [RoomLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [RoomLbl setTextColor:[UIColor whiteColor]];
            [RoomLbl setTextAlignment:NSTextAlignmentLeft];
            RoomLbl.tag=203;
            [RoomBtn addSubview:RoomLbl];
            
//            //房间开关
//            UISwitch *switchRoomButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10 + 50), 20, 35+(10*kindNum), 20)];
//            switchRoomButton.onTintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
//            for (int i = 0 ;i < _roomSosNumber.count ; i ++) {
//                if ([[NSString stringWithFormat:@"%@",[_roomSosNumber objectAtIndex:i]]isEqualToString:[NSString stringWithFormat:@"%zi",indexPath.row]]) {
//                    [switchRoomButton setOn:YES];
//                }
//            }
//
//            
//            [switchRoomButton addTarget:self action:@selector(switchRoomAction:) forControlEvents:UIControlEventValueChanged];
//            
//            switchRoomButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
//            [cell addSubview:switchRoomButton];
            
            //当前房间人数
            UIView * roomKindNumView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20)];
            //设置按钮是否圆角
            [roomKindNumView.layer setMasksToBounds:YES];
            //圆角像素化
            [roomKindNumView.layer setCornerRadius:8.5];
            [roomKindNumView setBackgroundColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:0.5]];
            roomKindNumView.tag=204;
            [RoomBtn addSubview:roomKindNumView];
            
            UIImageView *numImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 1, 16, 16)];
            [numImgView setImage:[UIImage imageNamed:@"ppl_no"]];
            //            [numImgView setAlpha:0.5];
            [roomKindNumView addSubview:numImgView];
            
            
            //房间孩子数量
            UILabel * KindNumLbl =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, CGRectGetWidth(roomKindNumView.frame)-35, 20)];
            [KindNumLbl setText:str];
            [KindNumLbl setAlpha:0.6];
            [KindNumLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [KindNumLbl setTextColor:[UIColor whiteColor]];
            [KindNumLbl setTextAlignment:NSTextAlignmentLeft];
            KindNumLbl.tag=205;
            [roomKindNumView addSubview:KindNumLbl];
            
            
            
            
            int sNum=0;
            for (int i=0; i<tempChildArray.count; i++) {
                
                //儿童图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%4==0) {
                    sNum++;
                }
                
                DBImageView * kindImgView=[[DBImageView alloc] initWithFrame:CGRectMake(72+((CGRectGetWidth(RoomBtn.frame)-130)/4+10)*(i%4),45+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*sNum , (CGRectGetWidth(RoomBtn.frame)-130)/4, (CGRectGetWidth(RoomBtn.frame)-130)/4)];
                [kindImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
                
                
                [kindImgView.layer setCornerRadius:CGRectGetHeight([kindImgView bounds]) / 2];
                [kindImgView.layer setMasksToBounds:YES];
                [kindImgView.layer setBorderWidth:2];
                
                [kindImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
                NSString* pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]];
                
                if (![[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] isKindOfClass:[NSNull class]] ) {
                    [kindImgView setImageWithPath:[pathOne copy]];
                    
                    
                    for (int y =0 ; y < _localChildInfo.count;  y++) {
                        NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
                        if ([[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                            if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                                
                                
                                
                                NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                                UIImage *image = [UIImage imageWithData:imageData];
                                [kindImgView setImage:image];
                                
                                //  NSLog(@"resourcePath  %@",path);
                                
                            }else{
                                
                                
                                [kindImgView setImageWithPath:[pathOne copy]];
                            }
                            
                        }
                        
                    }
                    

                }
               
                

                //[kindImgView setImageWithPath:[pathOne copy]];
                {
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([[[tempChildArray objectAtIndex:i] objectForKey:@"lastAppearTime"]doubleValue] / 1000)];
                    //得到相差秒数
                    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
                    int minute = ((int)time>0?(int)time:-((int)time))/60;
                    
                    
                    if (minute>10) {
                        [kindImgView setAlpha:0.5];
                    }
                }
                [RoomBtn addSubview:kindImgView];
                kindBtn.frame=kindImgView.frame;
                
                [kindBtn setBackgroundColor:[UIColor clearColor]];
                
                
                
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKindAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000+i;
                [RoomBtn addSubview:kindBtn];
                
                
     

            }
            
        }
        
        tempChildArray=nil;
        
    }
    //个人设置
    else if (tableView==self.PersonageTableView)
    {
        
        NSDictionary *tempDictionary;
        NSString* pathOne;
        if (indexPath.row>0) {
            tempDictionary=[[_personalDetailsArray objectAtIndex:(indexPath.row-1)]copy];
            pathOne=[NSString stringWithFormat: @"%@",[tempDictionary objectForKey:@"icon"]];
        }
        
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //房间图标
            DBImageView * messageImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            [messageImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            //设置按钮为圆形
            [messageImgView.layer setCornerRadius:CGRectGetHeight([messageImgView bounds]) / 2];
            [messageImgView.layer setMasksToBounds:YES];
            [messageImgView.layer setBorderWidth:2];
            
            [messageImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [messageImgView setImageWithPath:[pathOne copy]];
            
            
            
            messageImgView.tag=206;
            [cell addSubview:messageImgView];
            
            UILabel * messageLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 27, CGRectGetWidth(cell.frame)-100, 20)];
            if (indexPath.row>0) {
                switch (myDelegate.applanguage) {
                    case 0:
                        [messageLbl setText:[tempDictionary objectForKey:@"title"]];
                        break;
                    case 1:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleTc"]];
                        break;
                    case 2:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleSc"]];
                        break;
                        
                    default:
                        break;
                }
                
            }
            else
            {
                
                [messageLbl setText:LOCALIZATION(@"text_feed_back")];
            }
            
            //            [messageLbl setAlpha:0.6];
            [messageLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [messageLbl setTextColor:[UIColor blackColor]];
            [messageLbl setTextAlignment:NSTextAlignmentLeft];
            messageLbl.tag=207;
            [cell addSubview:messageLbl];
            
            UILabel * timeLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 47, CGRectGetWidth(cell.frame)-100, 20)];
            if (indexPath.row>0) {
                [timeLbl setText:[tempDictionary objectForKey:@"validUntil"]];
            }
            else
            {
                [timeLbl setText:@""];
            }
            //            [messageLbl setAlpha:0.6];
            [timeLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [timeLbl setTextColor:[UIColor blackColor]];
            [timeLbl setTextAlignment:NSTextAlignmentLeft];
            timeLbl.tag=208;
            [cell addSubview:timeLbl];
            
        }
        if([cell viewWithTag:206]!=nil)
        {
            DBImageView * messageImgView=(DBImageView *)[cell viewWithTag:206];
          
            
            [messageImgView setImageWithPath:[pathOne copy]];
            
        }
        
        if([cell viewWithTag:207]!=nil)
        {
            UILabel * messageLbl =(UILabel *)[cell viewWithTag:207];
            if (indexPath.row>0) {
                switch (myDelegate.applanguage) {
                    case 0:
                        [messageLbl setText:[tempDictionary objectForKey:@"title"]];
                        break;
                    case 1:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleTc"]];
                        break;
                    case 2:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleSc"]];
                        break;
                        
                    default:
                        break;
                }
                
            }
            else
            {
                
                [messageLbl setText:LOCALIZATION(@"text_feed_back")];
            }
            
            
        }
        if([cell viewWithTag:208]!=nil)
        {
            UILabel * timeLbl =(UILabel *)[cell viewWithTag:208];
            if (indexPath.row>0) {
                [timeLbl setText:[tempDictionary objectForKey:@"validUntil"]];
            }
            else
            {
                [timeLbl setText:@""];
            }
            
        }
        
        
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
    }
    //表现
    else if (tableView==self.PerformanceTableView)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
            UILabel * roomNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, Drive_Wdith-60, 30)];
            //            [roomNameLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            [roomNameLbl setTextColor:[UIColor blackColor]];
            [roomNameLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [roomNameLbl setTag:209];
            [cell addSubview:roomNameLbl];
            
            UIView * compareView=[[UIView alloc]initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 50)];
            [compareView setBackgroundColor:[UIColor colorWithRed:0.957 green:0.957 blue:0.922 alpha:1]];
            [compareView setTag:222];
            [cell addSubview:compareView];
            
            compareView.hidden=YES;
            //本日数据条
            EAColourfulProgressView *progressView= [[EAColourfulProgressView alloc] initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 25)];
//            progressView.showText = @NO;
//            progressView.flat = @YES;
//            progressView.animate = @NO;
//            progressView.borderRadius = @0;
//            progressView.type = LDProgressSolid;
//            progressView.color = [UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1];
            progressView.tag=210;
            [cell addSubview:progressView];
            progressView.hidden=YES;
            [progressView awakeFromNib];
            progressView.maximumValue=100;
            progressView.currentValue=0;
            [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1]  animated:YES];
            
            //本日数据
            UILabel *progressLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 25)];
            
            
            [progressLbl setTextColor:[UIColor colorWithRed:0.808 green:0.808 blue:0.776 alpha:1]];
            [progressLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [progressLbl setTextAlignment:NSTextAlignmentRight];
            [progressLbl setTag:224];
            [cell addSubview:progressLbl];
            
            
            
            //自定义数据条
            progressView = [[EAColourfulProgressView alloc] initWithFrame:CGRectMake(20, 55, Drive_Wdith-60, 25)];
//            progressView.showText = @NO;
//            progressView.flat = @YES;
//            progressView.animate = @NO;
//            progressView.borderRadius = @0;
//            progressView.type = LDProgressSolid;
//            progressView.color = [UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1];
            progressView.tag=223;
            
            [cell addSubview:progressView];
            progressView.hidden=YES;
            [progressView awakeFromNib];
            progressView.maximumValue=100;
            [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]  animated:YES];
            
            //自定义数据
            UILabel * progressLbl2 =[[UILabel alloc]initWithFrame:CGRectMake(20, 55, Drive_Wdith-60, 25)];
            
            
            [progressLbl2 setTextColor:[UIColor colorWithRed:0.808 green:0.808 blue:0.776 alpha:1]];
            [progressLbl2 setFont:[UIFont systemFontOfSize: 18.0]];
            [progressLbl2 setTextAlignment:NSTextAlignmentRight];
            [progressLbl2 setTag:225];
            [cell addSubview:progressLbl2];
            
            
        }
        if([cell viewWithTag:209]!=nil)
        {
            UILabel * roomNameLbl =(UILabel *)[cell viewWithTag:209];
            if (_dailyAvgFigureArray.count>0) {
                switch (myDelegate.applanguage) {
                    case 0:
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locName"]];
                        break;
                    case 1:
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locNameTc"]];
                        break;
                    case 2:
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locNameSc"]];
                        break;
                        
                    default:
                        break;
                }
                
                
                
                roomNameLbl.hidden=NO;
            }
            else
            {
                roomNameLbl.hidden=YES;
            }
            
        }
        if([cell viewWithTag:222]!=nil)
        {
            UIView * compareView=(UIView *)[cell viewWithTag:222];
            if (_dailyAvgFigureArray.count>0) {
                compareView.hidden=NO;
            }
            else
            {
                
                compareView.hidden=YES;
            }
        }
        if([cell viewWithTag:210]!=nil)
        {
            
            EAColourfulProgressView *progressView = (EAColourfulProgressView *)[cell viewWithTag:210];
            if (_dailyAvgFigureArray.count>0) {
                if ([[[_dailyAvgFigureArray objectAtIndex:indexPath.row]objectForKey:@"daily"] integerValue]>0) {
                    progressView.hidden=NO;
                    UILabel *progressLbl =(UILabel *)[cell viewWithTag:224];
                    
                    int num=(int)[[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"daily"]doubleValue];
//                    progressView.progress =num*1.00/([self.avgDaysStr doubleValue]*24.00*60.00);

                    [progressLbl setText:[NSString stringWithFormat:@"%dhr %dmin",num/60,num%60]];
                    [progressView updateToCurrentValue:(100-(num*100.00/([self.avgDaysStr doubleValue]*24.00*60.00))) color:[UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1]  animated:YES];
                    
                }
                else
                {
                    [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1]  animated:YES];
                    progressView.hidden=YES;
//                    progressView.progress = 0.00;
                }
            }
            else
            {
                [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1]  animated:YES];
                progressView.hidden=YES;
//                progressView.progress = 0.00;
                
                
            }
            
            
        }
        
        if([cell viewWithTag:223]!=nil)
        {
            EAColourfulProgressView *progressView = (EAColourfulProgressView *)[cell viewWithTag:223];
            if (_dailyAvgFigureArray.count>0) {
                progressView.hidden=NO;
                if ([[[_dailyAvgFigureArray objectAtIndex:indexPath.row]objectForKey:@"average"] integerValue]>0) {
                    
                    
                    
                    //                    progressView.progress = 0.50;
                    
                    int num=(int)[[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"average"]doubleValue];
//                    progressView.progress =num*1.00/([self.avgDaysStr doubleValue]*24.00*60.00);
                 
//                    NSLog(@"---%d",(int)(num*100.00/([self.avgDaysStr doubleValue]*24.00*60.00)));
                    [progressView updateToCurrentValue:(100-(num*100.00/([self.avgDaysStr doubleValue]*24.00*60.00))) color:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]  animated:YES];
                    UILabel *progressLbl =(UILabel *)[cell viewWithTag:225];
                    [progressLbl setText:[NSString stringWithFormat:@"%dhr %dmin",num/60,num%60]];
                }
                else
                {
progressView.hidden=YES;
                    [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]  animated:YES];
                }
            }
            else
            {
progressView.hidden=YES;
                [progressView updateToCurrentValue:100 color:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]  animated:YES];
                
            }
            
        }
        
    }
    //活动
    else if (tableView==self.ActivitiesTableView)
    {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //活动图标
            DBImageView * messageImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            [messageImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            
            //            UIImageView * messageImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            //设置按钮为圆形
            [messageImgView.layer setCornerRadius:CGRectGetHeight([messageImgView bounds]) / 2];
            [messageImgView.layer setMasksToBounds:YES];
            [messageImgView.layer setBorderWidth:2];
            
            [messageImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            //            [messageImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            messageImgView.tag=211;
            [cell addSubview:messageImgView];
            
            UILabel * messageLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 27, CGRectGetWidth(cell.frame)-100, 20)];
            [messageLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            //            [messageLbl setAlpha:0.6];
            [messageLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [messageLbl setTextColor:[UIColor blackColor]];
            [messageLbl setTextAlignment:NSTextAlignmentLeft];
            messageLbl.tag=212;
            [cell addSubview:messageLbl];
            
            UILabel * timeLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 47, CGRectGetWidth(cell.frame)-100, 20)];
            [timeLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            //            [messageLbl setAlpha:0.6];
            [timeLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [timeLbl setTextColor:[UIColor blackColor]];
            [timeLbl setTextAlignment:NSTextAlignmentLeft];
            timeLbl.tag=213;
            [cell addSubview:timeLbl];
            
        }
        if([cell viewWithTag:211]!=nil)
        {
            DBImageView * messageImgView=(DBImageView *)[cell viewWithTag:211];
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];
            [messageImgView setImageWithPath:[pathOne copy]];
            
        }
        
        if([cell viewWithTag:212]!=nil)
        {
            UILabel * messageLbl =(UILabel *)[cell viewWithTag:212];
            
            switch (myDelegate.applanguage) {
                case 0:
                    [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
                    break;
                case 1:
                    [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"titleTc"]];
                    break;
                case 2:
                    [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"titleSc"]];
                    break;
                    
                default:
                    break;
            }
            
        }
        if([cell viewWithTag:213]!=nil)
        {
            UILabel * timeLbl =(UILabel *)[cell viewWithTag:213];
            [timeLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"validUntil"]];
            
        }
        
        
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
    }
    else if(tableView==self.dateTableView)
    {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
        }
        if (indexPath.row==0) {
            cell.textLabel.text=LOCALIZATION(@"this_Week");
            
        }
        if (indexPath.row==1) {
            cell.textLabel.text=LOCALIZATION(@"Last_14_days");
            
        }
        if (indexPath.row==2) {
            cell.textLabel.text=LOCALIZATION(@"50_days");
            
        }
        cell.textLabel.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    }
    else
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            
            
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //房间列表设置
    if(tableView == self.listTypeTableView)
    {
        
        if (indexPath.row==0) {
            if (
                _isautoOn==YES) {
                [_refreshImgView setImage:[UIImage imageNamed:@"selected_off"]];
                _isautoOn=NO;
            }
            else
            {
                [_refreshImgView setImage:[UIImage imageNamed:@"selected"]];
                _isautoOn=YES;
            }
        }
        if (indexPath.row==1) {
            if (_isallRoomOn==YES) {
                _isallRoomOn=NO;
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"selected_off"]];
                _roomArray=_kidsRoomArray;
                
            }
            else
            {
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"selected"]];
                _isallRoomOn=YES;
                _roomArray=_allRoomArray;
            }
            
            [_RoomTableView reloadData];
        }
    }
    //个人表现时间段查询
    else if(tableView ==self.dateTableView)
    {
        
        CGRect temp=self.conditionLbl.frame ;
        NSString *str3;
        if (indexPath.row==0) {
            str3=LOCALIZATION(@"this_Week");
            [_conditionLbl setText:str3];
            self.avgDaysStr=@"5";
            
        }
        else if(indexPath.row==1)
        {
            str3=LOCALIZATION(@"Last_14_days");
            [_conditionLbl setText:str3];
            self.avgDaysStr=@"14";
        }
        else if (indexPath.row==2)
        {
            str3=LOCALIZATION(@"50_days");
            [_conditionLbl setText:str3];
            self.avgDaysStr=@"50";
        }
        //查询条件
        _conditionLbl.frame = CGRectMake(temp.origin.x, temp.origin.y, (str3.length>2?str3.length*8.0f:str3.length*15), temp.size.height);
        _conditionImgView.frame=CGRectMake(CGRectGetWidth(_conditionLbl.bounds)+_conditionLbl.frame.origin.x, 14.0f, 15.0F, 15.0F);
        [_PopupSView setHidden:YES];
        
        if (myDelegate.childDictionary!=nil) {
            NSDictionary *tempDictionary=[NSDictionary dictionaryWithObjectsAndKeys:[myDelegate.childDictionary objectForKey:@"child_id"], @"childId",self.avgDaysStr, @"avgDays", nil];
            [self getRequest:GET_REPORTS delegate:self RequestDictionary:[tempDictionary copy]];
            tempDictionary=nil;
            //开启加载
            //            [HUD show:YES];
            //            [_PerformanceTableView reloadData];
        }
    }
    //个人表现时间段查询
    else if(tableView ==self.organizationTableView)
    {
        self.organizationIndex=indexPath.row;
        
        //机构名称列表选择-----------------------------
        NSString *organizationStr;
        switch (myDelegate.applanguage) {
            case 0:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"name"];
                break;
            case 1:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameTc"];
                break;
            case 2:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameSc"];
                break;
                
            default:
                break;
        }
        
        [self.organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
        
        UIImageView * osBtnImgView=(UIImageView *)[self.organizationShowBtn viewWithTag:218];
        osBtnImgView.frame=CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),15.5,20,13);
        [_RoomTableView reloadData];
        [_PopupSView setHidden:YES];
        [_organizationTableView setHidden:YES];
    }
    //活动
    else if(tableView ==self.ActivitiesTableView)
    {
        NSString *urlStr;
        
        switch (myDelegate.applanguage) {
            case 0:
                urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activity"];
                break;
            case 1:
                urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activityTc"];
                break;
            case 2:
                urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activitySc"];
                break;
                
            default:
                break;
        }
        if (self.web==nil) {
            self.web =[[WebViewController alloc]init];
        }
        //为web页面赋值
        self.web.urlStr=urlStr;
        [self.navigationController pushViewController:self.web animated:YES];
    }
    
    //个人设置
    else if (tableView==self.PersonageTableView)
    {
        if (indexPath.row==0) {
            if(_isloadFeekBack==YES)
            {
                _isloadFeekBack=NO;
                UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, Drive_Wdith-30, 40)];
                titleLbl.text=LOCALIZATION(@"text_feed_back");
                [titleLbl setFont:[UIFont systemFontOfSize:20]];
                [titleLbl setTextColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                titleLbl.textAlignment=NSTextAlignmentLeft;
                [_FeekBackView addSubview:titleLbl];
                UILabel *lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, CGRectGetWidth(_FeekBackView.frame), 4)];
                lineLbl.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
                [_FeekBackView addSubview:lineLbl];
                
                titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 47, Drive_Wdith-30, 60)];
                titleLbl.text=LOCALIZATION(@"text_feed_back_content");
                titleLbl.numberOfLines=0;
                [titleLbl setFont:[UIFont systemFontOfSize:15]];
                [titleLbl setTextColor:[UIColor blackColor]];
                titleLbl.textAlignment=NSTextAlignmentLeft;
                [_FeekBackView addSubview:titleLbl];
                _FeekBackTxt=[[UITextField alloc]initWithFrame:CGRectMake(15, 107, Drive_Wdith-40, 35)];
                _FeekBackTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
                
                UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_email"]];
                _FeekBackTxt.leftView=imgV;//设置输入框内左边的图标
                _FeekBackTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
                _FeekBackTxt.leftViewMode=UITextFieldViewModeAlways;
                _FeekBackTxt.placeholder=LOCALIZATION(@"text_your_comments");//默认显示的字
                _FeekBackTxt.secureTextEntry=NO;//设置成密码格式
                _FeekBackTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
                _FeekBackTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
                _FeekBackTxt.delegate=self;//设置委托
                [_FeekBackView addSubview:_FeekBackTxt];
                
                lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 139, CGRectGetWidth(_FeekBackView.frame)-10, 2)];
                lineLbl.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
                [_FeekBackView addSubview:lineLbl];
                
                NSArray *segmentedArray = [[NSArray alloc]initWithObjects:LOCALIZATION(@"text_feedback_idea"),LOCALIZATION(@"text_feedback_question"),nil];
                //初始化UISegmentedControl
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
                segmentedControl.frame = CGRectMake(CGRectGetWidth(_FeekBackView.frame)-190, 180, 150.0, 30.0);
                segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
                segmentedControl.tintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
                //                [segmentedControl setBackgroundImage:[UIImage imageNamed:@"zyyy_choose_middle.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
                //                [segmentedControl setBackgroundImage:[UIImage imageNamed:@"zyyy_choose_middle_touch.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
                segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
                [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
                [_FeekBackView addSubview:segmentedControl];
                
                //取消按钮
                UIButton * CencelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 230, CGRectGetWidth(_FeekBackView.frame)/2, 38)];
                //设置按显示文字
                [CencelBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
                [CencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [CencelBtn setImage:[UIImage imageNamed:@"cross2"] forState:UIControlStateNormal];
                //设置按钮背景颜色
                [CencelBtn setBackgroundColor:[UIColor clearColor]];
                //设置按钮响应事件
                [CencelBtn addTarget:self action:@selector(CencelAction:) forControlEvents:UIControlEventTouchUpInside];
                //                //CencelBtn按钮是否圆角
                //                [CencelBtn.layer setMasksToBounds:YES];
                //                //圆角像素化
                //                [CencelBtn.layer setCornerRadius:4.0];
                [CencelBtn.layer setBorderWidth:0.5]; //边框宽度
                [CencelBtn.layer setBorderColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1].CGColor];//边框颜色
                
                [_FeekBackView addSubview:CencelBtn];
                
                //确定按钮
                UIButton * OkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_FeekBackView.frame)/2, 230, CGRectGetWidth(_FeekBackView.frame)/2, 38)];
                //设置按显示文字
                [OkBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
                [OkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [OkBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
                //设置按钮背景颜色
                [OkBtn setBackgroundColor:[UIColor clearColor]];
                //设置按钮响应事件
                [OkBtn addTarget:self action:@selector(OkAction:) forControlEvents:UIControlEventTouchUpInside];
                //                //CencelBtn按钮是否圆角
                //                [CencelBtn.layer setMasksToBounds:YES];
                //                //圆角像素化
                //                [CencelBtn.layer setCornerRadius:4.0];
                [OkBtn.layer setBorderWidth:0.5]; //边框宽度
                [OkBtn.layer setBorderColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1].CGColor];//边框颜色
                
                [_FeekBackView addSubview:OkBtn];
                
                
            }
            _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.5];
            _PopupSView.hidden=NO;
            [_dateTableView setHidden:YES];
            [_listTypeView setHidden:YES];
            [_dateTableView setHidden:YES];
            [_organizationTableView setHidden:YES];
            [_kidsMassageView setHidden:YES];
             _FeekBackView.hidden=NO;
        }
        else
        {
            NSString *urlStr;
            switch (myDelegate.applanguage) {
                case 0:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"notice"];
                    break;
                case 1:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"noticeTc"];
                    break;
                case 2:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"noticeSc"];
                    break;
                    
                default:
                    break;
            }
            if (self.web==nil) {
                self.web =[[WebViewController alloc]init];
            }
            //为web页面赋值
            self.web.urlStr=urlStr;
            [self.navigationController pushViewController:self.web animated:YES];
        }
    }
    
    
    
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}




#pragma mark - Scroll
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //    scrollView.
////    NSLog(@"%@",scrollView.class);
////    if (scrollView==_MainInfoScrollView) {
////        if(huaHMSegmentedControl==0){
////
////            [self getRequest:@"reportService/api/childrenLocList" delegate:self];
////
////        }
////        else if(huaHMSegmentedControl==2){
////
////            //        myDelegate.headStr = nil;
////            //        myDelegate.footStr = nil;
////            //        [self.RadarConnectTableView tableViewDidScroll:scrollView];
////        }
////        else if(huaHMSegmentedControl==3){
////
////            [self getRequest:@"reportService/api/notices" delegate:self];
////        }
////    }
//
//
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (scrollView==_MainInfoScrollView) {
//
//        if(huaHMSegmentedControl !=1)
//        {
//            switch (huaHMSegmentedControl) {
//                case 0:
//                    [_HomeBtn setSelected:YES];
//                    [_HomeBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
//                    [_RadarBtn setSelected:NO];
//                    [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_NewsBtn setSelected:NO];
//                    [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_PersonageBtn setSelected:NO];
//                    [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
//                    [self getRequest:@"reportService/api/childrenLocList" delegate:self];
//                    break;
//                case 2:
//                    [_HomeBtn setSelected:NO];
//                    [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_RadarBtn setSelected:NO];
//                    [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_NewsBtn setSelected:YES];
//                    [_NewsBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
//                    [_PersonageBtn setSelected:NO];
//                    [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
//                    break;
//                case 3:
//                    [_HomeBtn setSelected:NO];
//                    [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_RadarBtn setSelected:NO];
//                    [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_NewsBtn setSelected:NO];
//                    [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
//                    [_PersonageBtn setSelected:YES];
//                    [_PersonageBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
//                     [self getRequest:@"reportService/api/notices" delegate:self];
//                    break;
//
//                default:
//                    break;
//            }
//            [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
//
//        }
//        else
//        {
//
//            [[[UIAlertView alloc] initWithTitle:@"系统提示"
//                                        message:@"IOS暂时不支持此功能，敬请期待"
//                                       delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil] show];
//            [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
//        }
////        if(huaHMSegmentedControl==0){
////
////            [self getRequest:@"reportService/api/childrenLocList" delegate:self];
////
////        }
////        else if(huaHMSegmentedControl==2){
////
////            //        myDelegate.headStr = nil;
////            //        myDelegate.footStr = nil;
////            //        [self.RadarConnectTableView tableViewDidScroll:scrollView];
////        }
////        else if(huaHMSegmentedControl==3){
////
////            [self getRequest:@"reportService/api/notices" delegate:self];
////        }
//    }
//}

#pragma mark ------------scrollview delegate-------
/**列表切换*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 101) {
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        //        if (scrollView.contentOffset.x!=320.000000) {
        
        huaHMSegmentedControl = (int)page;
        switch (huaHMSegmentedControl) {
            case 0:
                if ([_childrenByAreaArray isEqual:[NSNull null]]||_childrenByAreaArray.count<1) {
                    _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                }
                else
                {
                    _bulletinLbl.hidden=YES;
                }
                _progressView.frame=CGRectMake(0, 0.0f, Drive_Wdith, 3.0f);
                _progressView.hidden=YES;
                [_HomeBtn setSelected:YES];
                [_HomeBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                [_RadarBtn setSelected:NO];
                [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
                [_NewsBtn setSelected:NO];
                [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
                [_PersonageBtn setSelected:NO];
                [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
                
                if(_isreloadRoomList==YES)
                {
                    [self getRequest:GET_CHILDREN_LOC_LIST delegate:self RequestDictionary:nil];
                    //开启加载
                    //                        [HUD show:YES];
                    if(_isautoOn==YES)
                    {
                        //开启定时器
                        [self.refreshTimer setFireDate:[NSDate distantPast]];
                    }
                }
                
                break;
                
            case 1:
                [_HomeBtn setSelected:NO];
                [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
                [_RadarBtn setSelected:YES];
                [_RadarBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                [_NewsBtn setSelected:NO];
                [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
                [_PersonageBtn setSelected:NO];
                [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
                _bulletinLbl.hidden=YES;
                
                
                break;
            case 2:
                //                    if (_disconectKidsAy.count == 0) {
                //                        [self getRequest:GET_CHILDREN_INFO_LIST delegate:self RequestDictionary:nil];
                //                    }
                if(_ActivitiesTableView.hidden==YES)
                {
                    if (_dailyAvgFigureArray.count<1) {
                        _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
                        _bulletinLbl.hidden=NO;
                        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                        
                    }
                    else
                    {
                        _bulletinLbl.hidden=YES;
                    }
                    
                    //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    //                        [self.view bringSubviewToFront:_bulletinLbl];
                }
                else
                {
                    if (_activityInfosArray.count<1) {
                        _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
                        _bulletinLbl.hidden=NO;
                        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                        //                        [self.view bringSubviewToFront:_bulletinLbl];
                    }
                    else
                    {
                        _bulletinLbl.hidden=YES;
                    }
                    
                    
                }
                [_HomeBtn setSelected:NO];
                [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
                [_RadarBtn setSelected:NO];
                [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
                [_NewsBtn setSelected:YES];
                [_NewsBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                [_PersonageBtn setSelected:NO];
                [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
                if(_isloadNews==YES)
                {
                    [self insertChildMessage];
                }
                //关闭定时器
                [self.refreshTimer setFireDate:[NSDate distantFuture]];
                break;
            case 3:
                
                _bulletinLbl.hidden=YES;
                _progressView.frame=CGRectMake(Drive_Wdith*2, 0.0f, Drive_Wdith, 3.0f);
                _progressView.hidden=YES;
                [_HomeBtn setSelected:NO];
                [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
                [_RadarBtn setSelected:NO];
                [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
                [_NewsBtn setSelected:NO];
                [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
                [_PersonageBtn setSelected:YES];
                [_PersonageBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
                //关闭定时器
                [self.refreshTimer setFireDate:[NSDate distantFuture]];
                if(_isreloadpersonal==YES)
                {
                    [self getRequest:GET_NOTICES delegate:self RequestDictionary:nil];
                    //开启加载
                    //                        [HUD show:YES];
                    
                }
                break;
                
                
        }
        
        
        //            [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
        
        //        }
        //        else
        //        {
        //
        ////            [[[UIAlertView alloc] initWithTitle:@"系统提示"
        ////                                        message:@"IOS暂时不支持此功能，敬请期待"
        ////                                       delegate:self
        ////                              cancelButtonTitle:@"确定"
        ////                              otherButtonTitles:nil] show];
        //            if (huaHMSegmentedControl==0) {
        //                [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        //            }
        //            else if (huaHMSegmentedControl==2)
        //            {
        //                [scrollView setContentOffset:CGPointMake(640,0) animated:YES];
        //            }
        //        }
        
    }
    //        else
    //        {
    //            [[[UIAlertView alloc] initWithTitle:@"系统提示"
    //                                        message:@"IOS暂时不支持此功能，敬请期待"
    //                                       delegate:self
    //                              cancelButtonTitle:@"确定"
    //                              otherButtonTitles:nil] show];
    //            if (huaHMSegmentedControl==0) {
    //                [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    //            }
    //            else if (huaHMSegmentedControl==2)
    //            {
    //                [scrollView setContentOffset:CGPointMake(640,0) animated:YES];
    //            }
    //        }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollView is %@",scrollView.class);
    CGPoint pt = [scrollView contentOffset];
    if (scrollView==_RoomTableView&& pt.y < -68.500000) {
        
        _progressView.hidden=NO;
        //        [_progressView setProgress:0.0];
        
        
        //        [self simulateProgress];
        [self getRequest:GET_CHILDREN_LOC_LIST delegate:self RequestDictionary:nil];
        
        if ([_childrenByAreaArray isEqual:[NSNull null]]||_childrenByAreaArray.count<1) {
            _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
            _bulletinLbl.hidden=NO;
        }
        else
        {
            _bulletinLbl.hidden=YES;
        }

        //开启加载
        //        [HUD show:YES];
    }
    if(scrollView==_PersonageTableView&& pt.y < -68.500000)
    {
        _progressView.hidden=NO;
        //        [_progressView setProgress:0.0];
        
        
        //        [self simulateProgress];
        [self getRequest:GET_NOTICES delegate:self RequestDictionary:nil];
        //开启加载
        //        [HUD show:YES];
    }
}
#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    
    if([tag isEqualToString:POST_LOCATION]){
        NSData *responseData = [request responseData];
        
        NSString * resPOST_LOCATION = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"POST_LOCATION %@",resPOST_LOCATION);
        
        
        
        
        
        
        
        
    }
    //    NSString *responseString = [request responseString];
    //请求房间列表
    if ([tag isEqualToString:GET_CHILDREN_LOC_LIST]) {
        NSData *responseData = [request responseData];
        if(_organizationArray!=nil&&_organizationArray.count>0)
        {
            _organizationArray=nil;
            _organizationArray=[[NSMutableArray alloc]init];
            //            [_organizationArray removeAllObjects];
            
        }
        if(_childrenByAreaArray!=nil&&_childrenByAreaArray.count>0)
        {
            _childrenByAreaArray=nil;
            _childrenByAreaArray=[[NSMutableArray alloc]init];
            
        }
        if(_allRoomArray!=nil&&_allRoomArray.count>0)
        {
            _allRoomArray=nil;
            _allRoomArray=[[NSMutableArray alloc]init];
            
        }
        if(_childrenDictionary!=nil&&_childrenDictionary.count>0)
        {
            [_childrenDictionary removeAllObjects];
            
        }
        if(_kidsRoomArray!=nil&&_kidsRoomArray.count>0)
        {
            _kidsRoomArray=nil;
            _kidsRoomArray=[[NSMutableArray alloc]init];
            
        }
        if(_childrenByRoomDictionary!=nil&&_childrenByRoomDictionary.count>0)
        {
            [_childrenByRoomDictionary removeAllObjects];
            
        }
        _organizationArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"allLocations"] copy];
        _childrenByAreaArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"childrenByArea"] copy];
        
        if ([_organizationArray isEqual:[NSNull null]]) {
            _organizationArray=nil;
        }
        if ([_childrenByAreaArray isEqual:[NSNull null]]) {
            _childrenByAreaArray=nil;
        }
        
        if(_organizationArray.count>0&&_childrenByAreaArray.count>0)
        {
            if (myDelegate.childrenBeanArray==nil) {
                myDelegate.childrenBeanArray=[[NSDictionary alloc]init];
            }
            else
            {
                myDelegate.childrenBeanArray=nil;
                myDelegate.childrenBeanArray=[[NSDictionary alloc]init];
            }
            if(_childrenByAreaArray.count>0)
            {
                myDelegate.childrenBeanArray=(NSDictionary *)[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"] ;
                _organizationShowBtn.hidden=NO;
                //[self delLodChild];
                
            }
            else
            {
                _organizationShowBtn.hidden=YES;
                
            }
            
            responseData=nil;
            //机构名称列表选择-----------------------------
            NSString *organizationStr;
            switch (myDelegate.applanguage) {
                case 0:
                    organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"name"];
                    break;
                case 1:
                    organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameTc"];
                    break;
                case 2:
                    organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameSc"];
                    break;
                    
                default:
                    break;
            }
            [self.organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
            
            UIImageView * osBtnImgView=(UIImageView *)[self.organizationShowBtn viewWithTag:218];
            osBtnImgView.frame=CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),15.5,20,13);
            
            CGRect  tempRect= _organizationTableView.frame;
            _organizationTableView.frame=CGRectMake(tempRect.origin.x,tempRect.origin.y,tempRect.size.width,(44*_organizationArray.count));
            [_organizationTableView reloadData];
            
            NSArray *tempArray;
            
            
            tempArray =[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
            
           // NSLog(@"tempArray is %@",tempArray);
            
            _allRoomArray=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"locations"] copy];
            NSMutableArray *tempChindrenArray=[[NSMutableArray alloc]init];
            if(tempArray){
                for(int i=0;i<_allRoomArray.count;i++)
                {
                    for(int j=0;j<tempArray.count;j++)
                    {
                        if(![[[tempArray objectAtIndex:j] objectForKey:@"locId"] isEqual:[NSNull null]])
                        {
                            if([[[tempArray objectAtIndex:j] objectForKey:@"locId"] longLongValue] ==[[[_allRoomArray objectAtIndex:i] objectForKey:@"locationId"] longLongValue])
                            {
                                [tempChindrenArray addObject:[[tempArray objectAtIndex:j]copy]];
                                
                                
                            }
                        }
                    }
                    if(tempChindrenArray.count>0)
                    {
                        [_childrenDictionary setObject:[tempChindrenArray copy] forKey:[NSString stringWithFormat:@"%d",i]];
                        if([tempChindrenArray copy]!=nil&&tempChindrenArray.count>0)
                        {
                            [_kidsRoomArray addObject:[[_allRoomArray objectAtIndex:i] copy] ];
                            [_childrenByRoomDictionary setObject:[tempChindrenArray copy] forKey:[NSString stringWithFormat:@"%zi",(_kidsRoomArray.count-1)]];
                        }
                        
                        [tempChindrenArray removeAllObjects];
                    }
                }
                
            }
            //        NSLog(@"_childrenDictionary %@\n",_childrenDictionary);
            if (_childrenDictionary.count>0) {
                if(myDelegate.childDictionary !=nil)
                {
                    myDelegate.childDictionary=nil;
                    
                    myDelegate.childDictionary=[[NSDictionary alloc]init];
                }
                if(myDelegate.childDictionary ==nil)
                {
                    
                    
                    myDelegate.childDictionary=[[NSDictionary alloc]init];
                }
                //             NSLog(@"_childrenDictionary %@\n",[[[[_childrenDictionary objectForKey:@"0"] objectAtIndex:0]objectForKey:@"childRel"]objectForKey:@"child" ]);
                //             NSLog(@"_childrenDictionary %@\n",[[_childrenDictionary objectForKey:@"0"] objectAtIndex:0]);
                if(_childrenDictionary.count>0)
                {
                    NSArray *keyArray=[_childrenDictionary allKeys];
                    NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
                    
                    [tempDictionary setObject:[[[[[_childrenDictionary objectForKey:[keyArray objectAtIndex:0]] objectAtIndex:0]objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] forKey:@"icon"];
                    
                    
                    
                    
                    [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[[[[_childrenDictionary objectForKey:[keyArray objectAtIndex:0]] objectAtIndex:0] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] forKey:@"child_id"];
                    
                    [tempDictionary setObject:[[[[[_childrenDictionary objectForKey:[keyArray objectAtIndex:0]] objectAtIndex:0] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] forKey:@"name"];
                    
                    [tempDictionary setObject:[[[[_childrenDictionary objectForKey:[keyArray objectAtIndex:0]] objectAtIndex:0] objectForKey:@"childRel"]objectForKey:@"relation" ]forKey:@"relation_with_user"];
                    
                    [tempDictionary setObject:[[[_childrenDictionary objectForKey:[keyArray objectAtIndex:0]] objectAtIndex:0] objectForKey:@"macAddress"] forKey:@"mac_address"];
                    
                    myDelegate.childDictionary=(NSDictionary *)[tempDictionary copy];
                    [tempDictionary removeAllObjects];
                    tempDictionary=nil;
                }
                
                
                //            [self SaveChildren:_childrenDictionary];
            }
            
            NSLog(@"myDelegate.childDictionary %@\n",myDelegate.childDictionary);
            if (_isallRoomOn==YES) {
                _roomArray=_allRoomArray;
            }
            else
            {
                _roomArray=_kidsRoomArray;
            }
            //_RoomTableView.hidden = NO;
            [_RoomTableView reloadData];
            [tempChindrenArray removeAllObjects];
            tempChindrenArray=nil;
            tempArray=nil;
            _isreloadRoomList=NO;
            _organizationShowBtnShowView.hidden = NO;
            _bulletinLbl.hidden=YES;
        }
        
        else
        {
            _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
            _bulletinLbl.hidden=NO;
            _organizationShowBtnShowView.hidden = YES;
            //_RoomTableView.hidden = YES;
        }
        
        
        /**
         *  to get the all child information from here
         */
        [self getRequest:GET_CHILDREN_INFO_LIST delegate:self RequestDictionary:nil];
      

        
    }
    
    //请求个人信息
    if ([tag isEqualToString:GET_NOTICES]) {
        
        NSData *responseData = [request responseData];
        if(_personalDetailsArray!=nil)
        {
            _personalDetailsArray=nil;
            _personalDetailsArray=[NSMutableArray array];
        }
        _personalDetailsArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"notices"] copy];
        responseData=nil;
        [_PersonageTableView reloadData];
        _isreloadpersonal=NO;
        
    }
    //请求简报
    if ([tag isEqualToString:GET_REPORTS]) {
        //        NSString *responseString = [request responseString];
        NSData *responseData = [request responseData];
        NSString * resFEED_BACK = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"FEED_BACK %@",resFEED_BACK);
        
        if(_activityInfosArray!=nil)
        {
            _activityInfosArray=nil;
            _activityInfosArray=[NSMutableArray array];
        }
        if(_dailyAvgFigureArray!=nil)
        {
            _dailyAvgFigureArray=nil;
            _dailyAvgFigureArray=[NSMutableArray array];
        }
        
        NSString *activityInfoStr=[[responseData mutableObjectFromJSONData] objectForKey:@"activityInfos"];
        if ((NSNull *)activityInfoStr != [NSNull null]) {
            _activityInfosArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"activityInfos"] copy];
        }
        
        NSString *dailyAvgStr=[[responseData mutableObjectFromJSONData] objectForKey:@"dailyAvgFigure"];
        if ((NSNull *)dailyAvgStr != [NSNull null]) {
            _dailyAvgFigureArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"dailyAvgFigure"] copy];
        }
        
        
        
        
        responseData=nil;
        
        
        [_PerformanceTableView reloadData];
        [_ActivitiesTableView reloadData];
        _isloadNews=NO;
        
        if(_ActivitiesTableView.hidden==YES)
        {
            if (![_dailyAvgFigureArray isEqual:[NSNull null]]&&_dailyAvgFigureArray.count>0) {
                _bulletinLbl.hidden=YES;
            }
            else
            {
                _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
                _bulletinLbl.hidden=NO;
                _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            [self.view bringSubviewToFront:_bulletinLbl];
            }
        }
        else
        {
            if (![_activityInfosArray isEqual:[NSNull null]]&&_activityInfosArray.count>0) {
                _bulletinLbl.hidden=YES;
            }
            else
            {
                _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
                _bulletinLbl.hidden=NO;
                _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            [self.view bringSubviewToFront:_bulletinLbl];
            }
            
        }
    }
    
    //请求个人信息
    if ([tag isEqualToString:FEED_BACK]) {
        
        NSData *responseData = [request responseData];
        NSString * resFEED_BACK = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"FEED_BACK %@",resFEED_BACK);
        if ([resFEED_BACK isEqualToString:@"true"]) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_tick"]];
            HUD.labelText = LOCALIZATION(@"text_feed_back_successful");
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            
        }else{
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_network_error")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
    }
    
    if ([tag isEqualToString:GET_CHILDREN_INFO_LIST]) {
        //myDelegate.allKidsWithMacAddressBeanArray=[[NSMutableArray alloc]init];
        [myDelegate.allKidsWithMacAddressBeanArray removeAllObjects];
        [_disconectKidsAy removeAllObjects];
        NSData *responseData = [request responseData];
        NSMutableArray* childrenArray=[[responseData mutableObjectFromJSONData] objectForKey:@"childrenInfo"];
        if ([childrenArray isKindOfClass:[NSNull class]]) {
            childrenArray = nil;
        }else{
            if (myDelegate.allKidsBeanArray==nil) {
                myDelegate.allKidsBeanArray=[[NSMutableArray alloc]init];
            }
            myDelegate.allKidsBeanArray = [childrenArray mutableCopy];
        }
        
        //NSLog(@"myDelegate.allKidsBeanArray - -> %@",myDelegate.allKidsBeanArray);
        
        
        
        
       // NSMutableArray *teapAry = [NSMutableArray new];
        
        
        // NSLog(@"childrenInfo = %@" , childrenArray);
        for(int i=0;i<childrenArray.count; i++)
        {
            NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
            if (![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqual:[NSNull null]]) {
                [tempDictionary setObject:[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] forKey:@"mac_address"];
                
                
                if (![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
                    [_disconectKidsAy addObject:[childrenArray objectAtIndex:i]];
                }
                
                //                if ([[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
                //                                    }
                
            }
            
            
            //[teapAry addObject:[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]];
            
            
            
        }
        
        //[self delLodChild];
        
        NSLog(@"childrenArray--  > %@",childrenArray);
        [self SaveChildren:childrenArray];
        
        
        
        
        
        myDelegate.allKidsWithMacAddressBeanArray = [_disconectKidsAy mutableCopy];
        NSLog(@"myDelegate.allKidsWithMacAddressBeanArray (%lu)",(unsigned long)myDelegate.allKidsWithMacAddressBeanArray.count);
        
        _localChildInfo = [self allChildren];
        //NSLog(@"childrenArray--  > %lu",(unsigned long)childrenArray.count);
        NSLog(@"[self allChildren] -- > %@   ===(%lu) ",[self allChildren] ,(unsigned long)[self allChildren].count);
        NSLog(@"childrenArray--  > %lu",(unsigned long)childrenArray.count);
    }
    
    
        
    [_progressView setHidden:YES];
    //关闭加载
    //    [HUD hide:YES afterDelay:0];
    
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request  tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    [_progressView setHidden:YES];
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@" text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
    
}
#pragma mark - 本地数据处理
/**根据选择的机构加载房间和儿童信息*/
-(void)loadroomMessage
{
    if (_childrenDictionary.count>0) {
        [_childrenDictionary removeAllObjects];
    }
    if (_kidsRoomArray.count>0) {
        [_kidsRoomArray removeAllObjects];
    }
    if (_childrenByRoomDictionary.count>0) {
        [_childrenByRoomDictionary removeAllObjects];
    }
    NSArray *tempArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
    
    //        NSLog(@"_childrenArray %@\n",_childrenArray);
    
    _allRoomArray=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"locations"] copy];
    NSMutableArray *tempChindrenArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<_allRoomArray.count;i++)
    {
        for(int j=0;j<tempArray.count;j++)
        {
            
            if([[[tempArray objectAtIndex:j] objectForKey:@"locId"] longLongValue] ==[[[_allRoomArray objectAtIndex:i] objectForKey:@"locationId"] longLongValue])
            {
                [tempChindrenArray addObject:[[tempArray objectAtIndex:j]copy]];
                
                
            }
        }
        [_childrenDictionary setObject:[tempChindrenArray copy] forKey:[NSString stringWithFormat:@"%d",i]];
        if([tempChindrenArray copy]!=nil&&tempChindrenArray.count>0)
        {
            [_kidsRoomArray addObject:[[_allRoomArray objectAtIndex:i] copy] ];
            [_childrenByRoomDictionary setObject:[tempChindrenArray copy] forKey:[NSString stringWithFormat:@"%zi",(_kidsRoomArray.count-1)]];
        }
        [tempChindrenArray removeAllObjects];
    }
    //            NSLog(@"_childrenDictionary %@\n",_childrenDictionary);
    if (_isallRoomOn==YES) {
        _roomArray=_allRoomArray;
    }
    else
    {
        _roomArray=_kidsRoomArray;
    }
    [_RoomTableView reloadData];
    [tempChindrenArray removeAllObjects];
    tempChindrenArray=nil;
    tempArray=nil;
    _isreloadRoomList=NO;
    
}


//third page .change child button
-(void)insertChildMessage
{
    if (![_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count>0) {
        kidImgView.hidden=NO;
        NSString* pathOne =[NSString stringWithFormat: @"%@",[myDelegate.childDictionary objectForKey:@"icon" ]];
        NSLog(@"myDelegate.childDictionary -> %@",myDelegate.childDictionary);
        [kidImgView setImageWithPath:[pathOne copy]];
        for (int y =0 ; y < _localChildInfo.count;  y++) {
            NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
            if ([[NSString stringWithFormat: @"%@",[myDelegate.childDictionary objectForKey:@"child_id" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                    
                    
                    
                    NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                    UIImage *image = [UIImage imageWithData:imageData];
                    [kidImgView setImage:image];
                    
                    //  NSLog(@"resourcePath  %@",path);
                    
                }else{
                    
                    
                    [kidImgView setImageWithPath:[pathOne copy]];
                }
                
            }
            
        }

        //[kidImgView setImageWithPath:[pathOne copy]];
        
        NSLog(@"!!!!!%@",myDelegate.childDictionary);
        
        NSDictionary *tempDictionary=[NSDictionary dictionaryWithObjectsAndKeys:[myDelegate.childDictionary objectForKey:@"child_id"], @"childId",self.avgDaysStr, @"avgDays", nil];
        [self getRequest:GET_REPORTS delegate:self RequestDictionary:[tempDictionary copy]];
        tempDictionary=nil;
    }
    //开启加载
    //    [HUD show:YES];
}

-(void)timerFired:(id)sender
{
    [_RoomTableView reloadData];
}

/**
 *  获取输入框的Y坐标
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.FeekBackTxt) {
        textHeight=_FeekBackView.frame.origin.y+142;
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
    if (theTextField == self.FeekBackTxt) {
        [theTextField resignFirstResponder];
    }
    
    
    return YES;
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.FeekBackTxt resignFirstResponder];
    
    
}

#pragma mark - change language
-(void)updateLanuage
{
    
    
    
    NSString *organizationStr;
    if (![_organizationArray isEqual:[NSNull null]] && _organizationArray.count > 0) {
        switch (myDelegate.applanguage) {
            case 0:
                
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"name"];
                _crossImageView.hidden = YES;
                _tickImageView.hidden = YES;
                
                break;
            case 1:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameTc"];
                _crossImageView.hidden = NO;
                _tickImageView.hidden = NO;
                break;
            case 2:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameSc"];
                _crossImageView.hidden = NO;
                _tickImageView.hidden = NO;
                break;
                
            default:
                break;
        }
        

    }
    
    
    [self.organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
    
    UIImageView * osBtnImgView=(UIImageView *)[self.organizationShowBtn viewWithTag:218];
    osBtnImgView.frame=CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),15.5,20,13);
    [_RoomTableView reloadData];

    _labelTitle.text = LOCALIZATION(@"text_indoor_locator");
    _radarLbl.text = LOCALIZATION(@"text_radar_tracking");
    [_childrenListBtn setTitle:LOCALIZATION(@"text_kids_list") forState:UIControlStateNormal];
    [_radarViewSegmentedControl setTitle:LOCALIZATION(@"text_radar_tracking") forSegmentAtIndex:0];
    [_radarViewSegmentedControl setTitle:LOCALIZATION(@"text_anti_lost_mode") forSegmentAtIndex:1];
    
    [_connectBtn setTitle:[NSString stringWithFormat:@"%d %@",connectNum,LOCALIZATION(@"btn_supervised")]   forState:UIControlStateNormal];
    //image view
    if ([[self getCurrentAppLanguage]isEqualToString:@"en"] || [[self getCurrentSystemLanguage]isEqualToString:@"en"] || [[self getCurrentAppLanguage]isKindOfClass:[NSNull class]]) {
        [_tickImageView setHidden:YES];
        _crossImageView.hidden = YES;
    }else{
        _tickImageView.hidden = NO;
        _crossImageView.hidden = NO;
    }

    
    [_disconnectBtn setTitle:[NSString stringWithFormat:@"%d %@",disconnectNum,LOCALIZATION(@"btn_missed")] forState:UIControlStateNormal];
    

    _NewsLbl.text = LOCALIZATION(@"text_report");
    _revampLbl.text = LOCALIZATION(@"text_change");
    
    if(_revampLbl.text.length>2)
    {
        
        _NewsKidBtn.frame=CGRectMake(Drive_Wdith  -((_revampLbl.text.length*9)+55), 5, (_revampLbl.text.length*9)+45, 44);
        _revampLbl.frame=CGRectMake(32.0f, 0.0f, (_revampLbl.text.length*9), 44.0f);
    }
    
    UIImageView * ImgView=(UIImageView *)[_NewsKidBtn viewWithTag:99];
    ImgView.frame=CGRectMake(CGRectGetWidth(_NewsKidBtn.bounds)-12, 14, 12, 16);
    [_performanceBtn setTitle:LOCALIZATION(@"btn_performance") forState:UIControlStateNormal];
    [_activitiesBtn setTitle:LOCALIZATION(@"btn_activities") forState:UIControlStateNormal];
    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
    
    NSString *str=LOCALIZATION(@"text_today");
    _todayLbl.frame = CGRectMake(28.0f, 14.0f, (str.length>2?str.length*8.0f:str.length*15), 16.0f);
    _todayLbl.text = [str copy];
    
    _customizedColorLbl.frame = CGRectMake(CGRectGetWidth(_todayLbl.bounds)+_todayLbl.frame.origin.x+5, 14.0f, 14.0f, 14.0f);

    
    NSString *str2=LOCALIZATION(@"text_customized");
    _customizedLbl.frame = CGRectMake(CGRectGetWidth(_customizedColorLbl.bounds)+_customizedColorLbl.frame.origin.x+5, 14.0f, (str2.length>4?str2.length*7.5f:str2.length*15), 16.0f);

    _customizedLbl.text = [str2 copy];
    
    NSString *str3=LOCALIZATION(@"this_Week");
    //查询条件
    _conditionLbl.frame = CGRectMake(CGRectGetWidth(_customizedLbl.bounds)+_customizedLbl.frame.origin.x, 14.0f, (str3.length>2?str3.length*8.0f:str3.length*15), 16.0f);
    _conditionLbl.text = [str3 copy];
    
    str=nil;
    str2=nil;
    str3=nil;
    
    _conditionImgView.frame = CGRectMake(CGRectGetWidth(_conditionLbl.bounds)+_conditionLbl.frame.origin.x, 15.5,20,13);
    
    _PersonageLbl.text = LOCALIZATION(@"text_notifications");
    [_closeBtn setTitle:LOCALIZATION(@"btn_back") forState:UIControlStateNormal];
    [_listtitleLal setText:LOCALIZATION(@"btn_options")];
    [_listTypeChangeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    
    
    UILabel * refreshLbl=(UILabel *)[_listTypeTableView viewWithTag:106];
    [refreshLbl setText:LOCALIZATION(@"text_view_all_room")];
    
    UILabel * refresh =(UILabel *)[_listTypeTableView viewWithTag:104];
    [refresh setText:LOCALIZATION(@"text_auto_refresh")];
    
    [_PersonageTableView reloadData];
    
    [_PerformanceTableView reloadData];
    [_ActivitiesTableView reloadData];
    [_organizationTableView reloadData];
    
}

#pragma mark --
#pragma mark - Handle Gestures (hide the pop view)

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    //[_PopupSView setHidden:YES];
    [self.FeekBackTxt resignFirstResponder];
}



#pragma mark --点击事件
-(void)roomSOSAction{
    [_PopRoomSosSView setHidden:YES];
}

/**弹出房间列表显示设置*/
-(void)mapAction{
    ChildLocationController *childloc= [[ChildLocationController alloc] init];
    //        tt._childrenArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
    
    
    childloc.childId = childId;
    childloc.childName = locChildName;
    
    //NSLog(@" tt._childrenArray  (%@)", tt._childrenArray);
    [self.navigationController pushViewController:childloc animated:YES];

    
}


-(void)changeAction:(id)sender
{
    if(![_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count>0)
    {
        [_PopupSView setHidden:NO];
        _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
        [_listTypeView setHidden:NO];
        [_dateTableView setHidden:YES];
        [_organizationTableView setHidden:YES];
        [_kidsMassageView setHidden:YES];
        _FeekBackView.hidden=YES;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_no_data")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
}
/**选查看儿童简报的列表*/
-(void)showChildrenList
{

    if (![_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count>0) {
        _isloadNews=YES;
        ChildrenListViewController *tt= [[ChildrenListViewController alloc] init];
        //        tt._childrenArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
        
        
        tt._childrenArray = [myDelegate.allKidsWithMacAddressBeanArray copy];
        
        //NSLog(@" tt._childrenArray  (%@)", tt._childrenArray);
        [self.navigationController pushViewController:tt animated:YES];
        tt .title = @"";
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_no_data")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
    
}

-(void)goToSettingAction:(id)sender
{
    
    
    
    if (isButtonOn) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow"]];
        HUD.labelText = LOCALIZATION(@"text_can_not_open_options");
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }else{
        _settingVc= [[SettingsViewController alloc] init];
        
        
        [self.navigationController pushViewController:self.settingVc animated:YES];
    }

    
}

/**显示机构选择列表*/
-(void)changeRoomAction:(id)sender
{
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.0];
    [_listTypeView setHidden:YES];
    [_dateTableView setHidden:YES];
    [_organizationTableView setHidden:NO];
    [_kidsMassageView setHidden:YES];
     _FeekBackView.hidden=YES;
}

/**显示房间信息*/
-(void)ShowRoomAction:(id)sender
{
    
}

/**保存房间列表显示设置*/
-(void)SaveAction:(id)sender
{
    [_PopupSView setHidden:YES];
    
}
/**显示儿童列表*/
-(void)childrenListAction:(id)sender
{
    if (![_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count>0) {
        [self getRequest:@"kindergartenList" delegate:self RequestDictionary:nil];
        
        //    KidslistViewController * kindlist = [[KidslistViewController alloc] init];
        //
        //    kindlist.childrenArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
        //
        //     NSLog(@"---%@",kindlist.childrenArray);
        //    [self.navigationController pushViewController:kindlist animated:YES];
        //    kindlist.title = @"";
        
        KidViewController* kindlist = [[KidViewController alloc] init];
        
        kindlist.childrenArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
        kindlist.kidsRoomArray=_roomArray;
        NSLog(@"---%@",kindlist.childrenArray);
        NSLog(@"kindlist.kidsRoomArray%@",kindlist.kidsRoomArray);
        [self.navigationController pushViewController:kindlist animated:YES];
        kindlist.title = @"";
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_no_data")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
}





//first page
/**儿童头像点击事件*/
- (void)ShowKindAction:(id)sender
{
    
    
    UIButton *tempBtn=sender;
    NSEnumerator * enumeratorKey;
    NSMutableArray *keyArray=[NSMutableArray array];
    NSMutableArray *keyNumber=[NSMutableArray array];
    if (self.isallRoomOn==YES) {
         enumeratorKey=[_childrenDictionary keyEnumerator];
    }
    else
    {
        enumeratorKey=[_childrenByRoomDictionary keyEnumerator];
        
    }

    NSLog(@"_childrenDictionary - > (%@)",_childrenDictionary);
    NSLog(@"_childrenByRoomDictionary - > (%@)",_childrenByRoomDictionary);
    
    for(NSString *s in enumeratorKey)
    {
        [keyArray addObject:s];
    }
    UITableViewCell *cell = (UITableViewCell *)[[tempBtn superview]superview];
    NSIndexPath *indexPath = [self.RoomTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %zi",indexPath.row);
    
    NSArray *tempChildArray;
    if (self.isallRoomOn==YES) {
          tempChildArray=[_childrenDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
    }
    else
    {
          tempChildArray=[_childrenByRoomDictionary objectForKey:[[keyArray objectAtIndex: indexPath.row]copy]];
    }
    NSLog(@"tempChildArray -- > (%@)",keyArray);
  NSLog(@"tempChildArray -- > (%@)",[NSString stringWithFormat:@"%zi",indexPath.row]);
    keyArray=nil;
    enumeratorKey=nil;
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [_listTypeView setHidden:YES];
    [_dateTableView setHidden:YES];
    [_organizationTableView setHidden:YES];
    [_FeekBackView setHidden:YES];
    [_kidsMassageView setHidden:NO];
    
    DBImageView  * KidsImgView=(DBImageView *)[_kidsMassageView viewWithTag:219];
    //KidsImgView.image= tempBtn.imageView.image;
    [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]];
    //NSLog(@"pathOnepathOne  -> %@",pathOne);
    childId = [NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]];
    locChildName = [NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
    
    
    //[KidsImgView setImageWithPath:[pathOne copy]];
    UILabel * kidNameLbl =(UILabel *)[_kidsMassageView viewWithTag:220];
  

       KidsImgView.imageWithPath = [pathOne copy];
    
    
    [kidNameLbl setText:[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
    for (int y =0 ; y < _localChildInfo.count;  y++) {
        NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
        if ([[NSString stringWithFormat: @"%@",childId] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
            if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                
                
                
                NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                UIImage *image = [UIImage imageWithData:imageData];
                [KidsImgView setImage:image];
                
                //  NSLog(@"resourcePath  %@",path);
                
            }else{
                
                
                  KidsImgView.imageWithPath = [pathOne copy];
            }
            
            
            if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                
                
                
                [kidNameLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
            }else{
                
                
                  [kidNameLbl setText:[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
            }

            
        }
        
    }

  
    
    
    
    UILabel * roomNameLbl =(UILabel *)[_kidsMassageView viewWithTag:221];
//    NSLog(@"lastAppearTime %@",[NSString stringWithFormat:@"%@",[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"lastAppearTime"]]);
    NSString * kidsAppearDate =  [self timeSp2date:[NSString stringWithFormat:@"%@",[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"lastAppearTime"]]];
    
    switch (myDelegate.applanguage) {
            
            
        case 0:
            [roomNameLbl setText:[NSString stringWithFormat:@"@%@  \n%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"locationName"], kidsAppearDate ]];
            break;
        case 1:
            [roomNameLbl setText:[NSString stringWithFormat:@"@%@  \n%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"],kidsAppearDate  ]];
            break;
        case 2:
            [roomNameLbl setText:[NSString stringWithFormat:@"@%@  \n%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"],kidsAppearDate ]];
            break;
            
        default:
            break;
    }
    
    
    //map button
    
  
}

/**显示表现*/
- (void)showPerformanceAction:(id)sender
{
    
    _divisionTwoLbl.frame=CGRectMake(0,CGRectGetHeight(_performanceBtn.bounds)-7, CGRectGetWidth(_performanceBtn.bounds), 3);
    [_divisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    _divisionFourLbl.frame=CGRectMake(0, CGRectGetHeight(_activitiesBtn.bounds)-5, CGRectGetWidth(_activitiesBtn.bounds), 1);
    [_divisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    
    [_performanceBtn setSelected:YES];
    [_activitiesBtn setSelected:NO];
    _PerformanceTableView.hidden=NO;
    _PerformanceTimeBtn.hidden=NO;
    _ActivitiesTableView.hidden=YES;
    if (_dailyAvgFigureArray.count>0) {
        _bulletinLbl.hidden=YES;
        //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
    {
        _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
        _bulletinLbl.hidden=NO;
        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
        //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.view bringSubviewToFront:_bulletinLbl];
    }
    //    _bulletinLbl.hidden=YES;
}

/**显示活动*/
- (void)showaActivitiesAction:(id)sender
{
    _divisionFourLbl.frame=CGRectMake(0,CGRectGetHeight(_activitiesBtn.bounds)-7, CGRectGetWidth(_activitiesBtn.bounds), 3);
    [_divisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    _divisionTwoLbl.frame=CGRectMake(0, CGRectGetHeight(_performanceBtn.bounds)-5, CGRectGetWidth(_performanceBtn.bounds), 1);
    [_divisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_performanceBtn setSelected:NO];
    [_activitiesBtn setSelected:YES];
    _PerformanceTableView.hidden=YES;
    _PerformanceTimeBtn.hidden=YES;
    _ActivitiesTableView.hidden=NO;
    
    if (_activityInfosArray.count>0) {
        _bulletinLbl.hidden=YES;
        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
    {
        _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
        _bulletinLbl.hidden=NO;
        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.view bringSubviewToFront:_bulletinLbl];
    }
    
}


- (void)tabAction:(id)sender
{
    UIButton *tempBtn=(UIButton *)sender;
    int num=(int)tempBtn.tag-214;
    //    if(num !=1)
    //    {
    switch (tempBtn.tag) {
        case 214:
            if ([_childrenByAreaArray isEqual:[NSNull null]]) {
                _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
                _bulletinLbl.hidden=NO;
                
            }
            else
            {
                if (_childrenByAreaArray.count<1) {
                    _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                  
                }
                else
                {
                    _bulletinLbl.hidden=YES;
                   
                }
            }
            _progressView.frame=CGRectMake(0, 0.0f, Drive_Wdith, 1.0f);
            _progressView.hidden=YES;
            [_HomeBtn setSelected:YES];
            [_HomeBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            [_RadarBtn setSelected:NO];
            [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
            [_NewsBtn setSelected:NO];
            [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
            [_PersonageBtn setSelected:NO];
            [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
            break;
        case 215:
            [_HomeBtn setSelected:NO];
            [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
            [_RadarBtn setSelected:YES];
            [_RadarBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            [_NewsBtn setSelected:NO];
            [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
            [_PersonageBtn setSelected:NO];
            [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
            _bulletinLbl.hidden=YES;
            
            break;
            
            
            
        case 216:
            [_HomeBtn setSelected:NO];
            [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
            [_RadarBtn setSelected:NO];
            [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
            [_NewsBtn setSelected:YES];
            [_NewsBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            [_PersonageBtn setSelected:NO];
            [_PersonageBtn setBackgroundColor:[UIColor whiteColor]];
            if(_ActivitiesTableView.hidden==YES)
            {
                if (_dailyAvgFigureArray.count<1) {
                    _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                    
                }
                else
                {
                    _bulletinLbl.hidden=YES;
                }
                
                //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //                        [self.view bringSubviewToFront:_bulletinLbl];
            }
            else
            {
                if (_activityInfosArray.count<1) {
                    _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                    _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    //                        [self.view bringSubviewToFront:_bulletinLbl];
                }
                else
                {
                    _bulletinLbl.hidden=YES;
                }
                
                
            }
            
            break;
        case 217:
            _bulletinLbl.hidden=YES;
            _progressView.frame=CGRectMake(Drive_Wdith*2, 0.0f, Drive_Wdith, 1.0f);
            _progressView.hidden=YES;
            [_HomeBtn setSelected:NO];
            [_HomeBtn setBackgroundColor:[UIColor whiteColor]];
            [_RadarBtn setSelected:NO];
            [_RadarBtn setBackgroundColor:[UIColor whiteColor]];
            [_NewsBtn setSelected:NO];
            [_NewsBtn setBackgroundColor:[UIColor whiteColor]];
            [_PersonageBtn setSelected:YES];
            [_PersonageBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            break;
            
        default:
            break;
    }
    
    NSLog(@"numnum -- > %d",num);
    huaHMSegmentedControl = num;
    [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * num, 0, Drive_Wdith, Drive_Height-44) animated:YES];
    if(num==0)
    {
        //            [self getRequest:@"reportService/api/childrenLocList" delegate:self];
        if (self.isautoOn==YES) {
            //开启定时器
            [self.refreshTimer setFireDate:[NSDate distantPast]];
        }
        
    }
    if(num==1){
        //[self.refreshTimer setFireDate:[NSDate distantPast]];
        [self.refreshTimer setFireDate:[NSDate distantFuture]];
//        if (_disconectKidsAy.count == 0) {
//            [self getRequest:GET_CHILDREN_INFO_LIST delegate:self RequestDictionary:nil];
//        }
        
    }
    if (num==2) {

        
        if(_isloadNews==YES)
        {
            //关闭定时器
            [self.refreshTimer setFireDate:[NSDate distantFuture]];
            [self insertChildMessage];
            
            
        }
    }
    if (num==3) {
        
        if(_isreloadpersonal==YES)
        {
            //关闭定时器
            [self.refreshTimer setFireDate:[NSDate distantFuture]];
            [self getRequest:GET_NOTICES delegate:self RequestDictionary:nil];
            //开启加载
            //                [HUD show:YES];
        }
    }
    //    }
    //    else
    //    {
    //
    //        [[[UIAlertView alloc] initWithTitle:@"系统提示"
    //                                    message:@"IOS暂时不支持此功能，敬请期待"
    //                                   delegate:self
    //                          cancelButtonTitle:@"确定"
    //                          otherButtonTitles:nil] show];
    //        [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
    //    }
    //    UISegmentedControl *segmentedControl=(UISegmentedControl *)sender;
    //    if([sender selectedSegmentIndex] !=1)
    //    {
    //        huaHMSegmentedControl = [sender selectedSegmentIndex];
    //        [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * [sender selectedSegmentIndex], 0, Drive_Wdith, Drive_Height-44) animated:YES];
    //    }
    //    else
    //    {
    //        segmentedControl.selectedSegmentIndex = huaHMSegmentedControl;
    //        [[[UIAlertView alloc] initWithTitle:@"系统提示"
    //                                    message:@"IOS暂时不支持此功能，敬请期待"
    //                                   delegate:self
    //                          cancelButtonTitle:@"确定"
    //                          otherButtonTitles:nil] show];
    //        [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
    //    }
    
}
/**显示时间段选择列表*/
-(void)dateChageAction:(id)sender
{
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [_listTypeView setHidden:YES];
    [_dateTableView setHidden:NO];
    [_organizationTableView setHidden:YES];
    [_kidsMassageView setHidden:YES];
    _FeekBackView.hidden=YES;
}
//提交按钮
- (void)closeAction
{
    [_PopupSView setHidden:YES];
    
    
    
}

-(void)CencelAction:(id)sender
{
    [_PopupSView setHidden:YES];
}
-(void)OkAction:(id)sender
{
    if([_FeekBackTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0)
    {
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:self.FeekBackTxt.text, @"content", @"b",@"type",nil];
        [self postRequest:FEED_BACK RequestDictionary:[tempDoct copy] delegate:self];
        tempDoct=nil;
        [_PopupSView setHidden:YES];
    }
    else
    {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow"]];
        HUD.labelText = LOCALIZATION(@"text_something_has_gone_wrong");
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
    }
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    selected = Seg.selectedSegmentIndex;
    
    //    NSLog(@"Index %i", Index);
    //
    //    switch (Index) {
    //
    //        case 0:
    //            break;
    //    }
}


/**
 *  switch button
 *
 *  @param sender <#sender description#>
 */

-(void)switchRoomAction:(id)sender{
    UISwitch *tempBtn=sender;
    
    UITableViewCell *cell = (UITableViewCell *)[tempBtn superview];
    NSIndexPath *indexPath = [self.RoomTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %zi",indexPath.row);
    
    isButtonOn = [tempBtn isOn];
    if (isButtonOn) {
        [_roomSosNumber addObject:[NSString stringWithFormat:@"%zi",indexPath.row]];
        
    }else{
        for (int i = 0; i < _roomSosNumber.count ; i ++) {
            if ([[NSString stringWithFormat:@"%@",[_roomSosNumber objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%zi",indexPath.row]]) {
                [_roomSosNumber removeObjectAtIndex:i];
            }
        }
    }
    
}


-(void)switchAction:(id)sender
{
    
    isButtonOn = [_switchButton isOn];
    if (isButtonOn) {
        [self scanTheDevice];
        //reg broad cast
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanDeviceBroadcast:) name:nil object:nil ];
        [_RadarScrollView setAlpha:1.0];
        [self rotate360DegreeWithImageView:_bgRadarRotate];
        
        _RadarScrollView.hidden = NO;
        _antiLostTb.hidden = YES;
        
        [_locationManager startUpdatingLocation];
        
        [self startLocationTimer];

    }else {
        [self stopScanTheDevice];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_SCAN_DEVICE_BROADCAST_NAME object:nil];
        [_bgRadarRotate.layer removeAllAnimations];
        //[_RadarPopupSView setHidden:NO];
        
        //set default is 0
        _radarViewSegmentedControl.selectedSegmentIndex = 0;
        
        [_RadarScrollView setAlpha:0.3];
        
        //stop anti lost function
        [self stopAntiLostService];
        
        _RadarScrollView.hidden = NO;
        _antiLostTb.hidden = YES;
        
        [_locationManager stopUpdatingLocation];
        
        [self stopLocationTimer];
        
    }
}

/**
 *  choose radar tracking or anti lost
 *
 *  @param Seg <#Seg description#>
 */
-(void)radarViewSegmentAction:(UISegmentedControl *)Seg{
    if (isButtonOn){
        NSInteger Index = Seg.selectedSegmentIndex;
        
        NSLog(@"Index %li", (long)Index);
        
        switch (Index) {
                
            case 0:
                [self scanTheDevice];
                _RadarScrollView.hidden = NO;
                _antiLostTb.hidden = YES;
                
                [self stopAntiLostService];
                break;
                
            case 1:
                /**
                 *  turn on the anti lost and turn off the scan
                 */
                [self stopScanTheDevice];
                
                if(_antiLostView == nil){
                    _antiLostView = [[AntiLostKidsSelectedListViewController alloc]init];
                }
                
                _antiLostView.SelectedchildrenArray = [_connectKidsByScanedToAntiLostAy mutableCopy];
                //            NSLog(@"_antiLostView.SelectedchildrenArray  - %@",_antiLostView.SelectedchildrenArray );
                [self.navigationController pushViewController:_antiLostView animated:YES];
                break;
                
                
        }

    }else{
        
        //set default is 0
        _radarViewSegmentedControl.selectedSegmentIndex = 0;
    }
    
}


-(void)radarConnectionAction:(id)sender{
    isSelectedMissed = false;
    
    _RadarDivisionTwoLbl.frame=CGRectMake(0,CGRectGetHeight(_connectBtn.bounds)-7, CGRectGetWidth(_connectBtn.bounds), 3);
    [_RadarDivisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    _radarDivisionFourLbl.frame=CGRectMake(0, CGRectGetHeight(_disconnectBtn.bounds)-5, CGRectGetWidth(_disconnectBtn.bounds), 1);
    [_radarDivisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    
    [_connectBtn setSelected:YES];
    [_disconnectBtn setSelected:NO];
    
    //show the connect table
    _RadarConnectTableView.hidden = NO;
    //hide the disconnect table
    _RadarDisconnectTableView.hidden = YES;
    
    

        
    CGSize newSize = CGSizeMake(0, self.view.frame.size.height + _connectKidsByScanedAy.count * 45  -223 + 1);
    [_RadarScrollView setContentSize:newSize];
    
}

-(void)radarDisconnectionAction:(id)sender{
    
    isSelectedMissed = true;
    
    _radarDivisionFourLbl.frame=CGRectMake(0,CGRectGetHeight(_disconnectBtn.bounds)-7, CGRectGetWidth(_disconnectBtn.bounds), 3);
    [_radarDivisionFourLbl setBackgroundColor:[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1]];
    _RadarDivisionTwoLbl.frame=CGRectMake(0, CGRectGetHeight(_connectBtn.bounds)-5, CGRectGetWidth(_connectBtn.bounds), 1);
    [_RadarDivisionTwoLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_connectBtn setSelected:NO];
    [_disconnectBtn setSelected:YES];
    
    //hide the connect table
    _RadarConnectTableView.hidden = YES;
    //show the disconnect table
    _RadarDisconnectTableView.hidden = NO;
    
    
    CGSize newSize = CGSizeMake(0, self.view.frame.size.height + _tempDisconnectKidsAy.count * 45  -223 + 1);
    [_RadarScrollView setContentSize:newSize];
}

#pragma mark - ui-image rotate 360
- (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 1.0;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
   //[imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
     [imageView.image drawInRect:CGRectMake(0,0,imageView.frame.size.width,imageView.frame.size.height)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

#pragma mark - broadcast

- (void) changeIcon{
        _localChildInfo = [self allChildren];
    
    [_RadarDisconnectTableView reloadData];
    [_RadarConnectTableView reloadData];
    [_antiLostTb reloadData];
    [_RoomTableView reloadData];
    
    
}

- (void) scanDeviceBroadcast:(NSNotification *)notification{
    if ([[notification name] isEqualToString:BLUETOOTH_SCAN_DEVICE_BROADCAST_NAME]){
        NSLog(@"BLUETOOTH_SCAN_DEVICE_BROADCAST_NAME");
        
        
        NSArray *views = [_bgRadaCircle subviews];
        for(UIImageView* view in views)
        {
            [view removeFromSuperview];
        }
        _connectKidsAy = [(NSMutableArray *)[notification object] mutableCopy];
        
        NSLog(@"-----> %@",_connectKidsAy);
        
        _tempDisconnectKidsAy = [[NSMutableArray alloc]init];
        _connectKidsByScanedAy = [[NSMutableArray alloc]init];
//        [_tempDisconnectKidsAy removeAllObjects];
//        [_connectKidsByScanedAy removeAllObjects];
        _tempDisconnectKidsAy = [myDelegate.allKidsWithMacAddressBeanArray mutableCopy];
        

         NSLog(@"_tempDisconnectKidsAy CONUT--- > %lu",(unsigned long)_tempDisconnectKidsAy.count);
        
        for (int i = 0; i < _connectKidsAy.count ; i ++) {
            NSDictionary *tempDic = [NSDictionary dictionary];
            tempDic = [_connectKidsAy objectAtIndex:i];
            if ([NSString stringWithFormat:@"%@", [tempDic objectForKey:@"kCBAdvDataManufacturerData"]].length == 15) {
                NSString * scanedMajorAndMinor = [[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"kCBAdvDataManufacturerData"]] substringWithRange:NSMakeRange(1, 8)];
                NSLog(@"tempDic %@",scanedMajorAndMinor);
                
                
                for (int y =0 ; y < _tempDisconnectKidsAy.count; y++) {
                   
                    NSDictionary *tempDic = [NSDictionary dictionary];
                    tempDic = [_tempDisconnectKidsAy objectAtIndex:y];
                    NSString *major = [self getMajor:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"major"]]];
                    NSString *minor = [self getMinor:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"minor"]]];
                    NSString *macAddress = [self getMinor:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"macAddress"]]];
                    NSString *kidsMajorAndMinor = [NSString stringWithFormat:@"%@%@",minor,major];
                            NSLog(@"---> _tempDisconnectKidsAy ---> %@",kidsMajorAndMinor);
                    
                    
                    if ([kidsMajorAndMinor isEqualToString:scanedMajorAndMinor]) {
                        [_connectKidsByScanedAy addObject:[_tempDisconnectKidsAy objectAtIndex:y]];
                        
                        
                        if(![_locationAy containsObject:macAddress]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [_locationAy addObject:macAddress];
                                 NSLog(@"_locationAy  %@",_locationAy);
                            });
                        }

                        
                        if (_tempDisconnectKidsAy.count > 0) {
                            [_tempDisconnectKidsAy removeObjectAtIndex:y];
                        }
                        if(_connectKidsRssiAy.count > 0 && _connectKidsRssiAy.count > y){
                             [_connectKidsRssiAy removeObjectAtIndex:y];
                        }
                        
                       
                    }
                    
                }

                
            }
            
        }

        
               //        _disconectKidsAy = [[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
        NSLog(@"_connectKidsAy CONUT--- > %lu",(unsigned long)_connectKidsAy.count);
        NSLog(@"_connectKidsRssiAy CONUT--- > %lu",(unsigned long)_connectKidsRssiAy.count);
         NSLog(@"_tempDisconnectKidsAy CONUT--- > %lu",(unsigned long)_tempDisconnectKidsAy.count);
        NSLog(@"_connectKidsByScanedAy CONUT--- > %lu",(unsigned long)_connectKidsByScanedAy.count);

        _connectKidsByScanedToAntiLostAy = [_connectKidsByScanedAy mutableCopy];
        disconnectNum = _tempDisconnectKidsAy.count;
        [_disconnectBtn setTitle:[NSString stringWithFormat:@"%d %@",disconnectNum,LOCALIZATION(@"btn_missed")] forState:UIControlStateNormal];
        _RadarDisconnectTableView.frame = CGRectMake( 0, 255, CGRectGetWidth(_MainInfoScrollView.frame) - 10,  disconnectNum * 45);
        _RadarDisconnectTableView.userInteractionEnabled = NO;
        _RadarDisconnectTableView.scrollEnabled = NO;
        _RadarDisconnectTableView.dataSource = self;
        _RadarDisconnectTableView.delegate = self;
        //    [self.positionDetailsTableView setBounces:NO];
        _RadarDisconnectTableView.tableFooterView = [[UIView alloc] init];
        _RadarDisconnectTableView.tag = 900;
        
        [_RadarScrollView addSubview:_RadarDisconnectTableView];
        
        
        
        connectNum = _connectKidsByScanedAy.count;
        [_connectBtn setTitle:[NSString stringWithFormat:@"%d %@",connectNum,LOCALIZATION(@"btn_supervised")] forState:UIControlStateNormal];
        _RadarConnectTableView.frame = CGRectMake( 0, 255, CGRectGetWidth(_MainInfoScrollView.frame) - 10,  connectNum * 45);
        _RadarConnectTableView.userInteractionEnabled = NO;
        _RadarConnectTableView.scrollEnabled = NO;
        _RadarConnectTableView.dataSource = self;
        _RadarConnectTableView.delegate = self;
        //    [self.positionDetailsTableView setBounces:NO];
        _RadarConnectTableView.tableFooterView = [[UIView alloc] init];
        _RadarConnectTableView.tag = 800;
        
        [_RadarScrollView addSubview:_RadarConnectTableView];
        
        
        if (isSelectedMissed) {
            CGSize newSize = CGSizeMake(0, self.view.frame.size.height + _tempDisconnectKidsAy.count * 45 - 223+ 1);
            [_RadarScrollView setContentSize:newSize];
            _RadarDisconnectTableView.hidden = NO;
            _RadarConnectTableView.hidden = YES;
        } else {
            CGSize newSize = CGSizeMake(0, self.view.frame.size.height + _connectKidsByScanedAy.count * 45 -223 + 1);
            [_RadarScrollView setContentSize:newSize];
            _RadarDisconnectTableView.hidden = YES;
            _RadarConnectTableView.hidden = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
      
            
            [_RadarConnectTableView reloadData];
            [_RadarDisconnectTableView reloadData];
        });
        
//        if(![self.connectKidsByScanedAy containsObject:advertisementData]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//    
//                
//            });
//        }

        
       
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_SCAN_DEVICE_RSSI_BROADCAST_NAME]){
        
         _connectKidsRssiAy = [(NSMutableArray *)[notification object] mutableCopy];
        
    }else if ([[notification name] isEqualToString:ANTILOST_VIEW_ANTI_LOST_CONFIRM_BROADCAST]){
        
        NSString * result = [(NSString *)[notification object]copy];
        if ([result isEqualToString:@"turn_on"]) {
            
            //set default is 0
            _radarViewSegmentedControl.selectedSegmentIndex = 1;
            
            _RadarScrollView.hidden = YES;
            _antiLostTb.hidden = NO;
//            NSMutableArray * tempArray = [myDelegate.antiLostSelectedKidsAy mutableCopy];
//            NSLog(@"myDelegate.antiLostSelectedKidsAy (%@)) ",tempArray);
            
            _antiLostTb.frame = CGRectMake( Drive_Wdith + 5 , 80, CGRectGetWidth(_MainInfoScrollView.frame) - 10,  Drive_Height - 80 - 45);
            _antiLostTb.scrollEnabled = YES;
            _antiLostTb.dataSource = self;
            _antiLostTb.delegate = self;
            //    [self.positionDetailsTableView setBounces:NO];
            _antiLostTb.tableFooterView = [[UIView alloc] init];
//            CGSize newSize = CGSizeMake(0, (myDelegate.antiLostSelectedKidsAy.count + 1) * 45+ 1);
//            [_antiLostTb setContentSize:newSize];
            _antiLostTb.tag = 700;
            
            NSDictionary *tempChildDictionary=[NSDictionary dictionary];
            NSMutableArray *tempDeviceAy = [[NSMutableArray alloc]init];
            NSMutableArray *tempNameAy = [[NSMutableArray alloc]init];
            for(int i = 0; i < myDelegate.antiLostSelectedKidsAy.count ; i++){
                tempChildDictionary=[myDelegate.antiLostSelectedKidsAy  objectAtIndex:i];

//                NSLog(@"LALALA -- %@",[NSString stringWithFormat:@"%@%@",[self getMajor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"minor"]]],[self getMinor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"major"]]]]);
                NSLog(@"tempChildDictionary - >%@",tempChildDictionary);
                [tempDeviceAy addObject:[NSString stringWithFormat:@"%@%@",[self getMajor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"minor"]]],[self getMinor:[NSString stringWithFormat:@"%@",[tempChildDictionary objectForKey:@"major"]]]]];
                [tempNameAy addObject:  [NSString stringWithFormat:@"%@",[[[tempChildDictionary objectForKey:@"childRel"] objectForKey:@"child" ]objectForKey:@"name" ]]];
            }
          
            [self antiLostService:tempDeviceAy NameAy:tempNameAy];
            
            [_MainInfoScrollView addSubview:_antiLostTb];
            
            [_antiLostTb reloadData];

        } else if([result isEqualToString:@"turn_off"]){
            
            //set default is 0
            _radarViewSegmentedControl.selectedSegmentIndex = 0;
            
            _RadarScrollView.hidden = NO;
              _antiLostTb.hidden = YES;
            [self scanTheDevice];
        }
        
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_ANTI_LOST_BROADCAST_DATA_BROADCAST_NAME]){
        //if the device has been connected
        NSString * antiResult  = [(NSString *)[notification object]copy];
        [antiResultAy addObject:antiResult];
        NSLog(@"BLUETOOTH_ANTI_LOST_BROADCAST_DATA_BROADCAST_NAME = %@",antiResult);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.antiLostTb reloadData];
        });
        
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_ANTI_LOST_NO_MORE_THAN_3_RECONNECT_BROADCAST_DATA_BROADCAST_NAME]){
        isMoreThanThree = false;
        
        reconnectNoMore3 = (NSString *)[notification object];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.antiLostTb reloadData];
        });
        
    }
    
    
    
    else if ([[notification name] isEqualToString:BLUETOOTH_ANTI_LOST_NO_MORE_THAN_3_ALREADY_LOST_BROADCAST_DATA_BROADCAST_NAME]){
        
        antiLostNoMore3 = (NSString *)[notification object];
        NSDictionary *tempChildDictionary=[NSDictionary dictionary];
        for (int i = 0; i < _connectKidsByScanedToAntiLostAy.count; i ++) {
             tempChildDictionary=[_connectKidsByScanedToAntiLostAy  objectAtIndex:i];
            NSString *major = [self getMajor:[NSString stringWithFormat:@"%@", [tempChildDictionary objectForKey:@"major"]]];
            NSString *minor = [self getMinor:[NSString stringWithFormat:@"%@", [tempChildDictionary objectForKey:@"minor"]]];
            NSString *kidsMajorAndMinor = [NSString stringWithFormat:@"%@%@",minor,major];
            if ([antiLostNoMore3 isEqualToString:kidsMajorAndMinor]) {
                 [self scheduleLocalNotification:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
            }
        }
        
       

        isMoreThanThree = false;
        
        
        NSLog(@"BLUETOOTH_ANTI_LOST_NO_MORE_THAN_3_ALREADY_LOST_BROADCAST_DATA_BROADCAST_NAME -- %@",antiLostNoMore3);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.antiLostTb reloadData];
        });
        
        
       
        
    }else if([[notification name] isEqualToString:BLUETOOTH_ANTI_LOST_SCAN_DEVICE_BROADCAST_DATA_BROADCAST_NAME]){
        //no more than three (connect the device)
        
        isMoreThanThree = true;
        
        _antiLostMore3scanDataAy = (NSMutableArray *)[notification object] ;
        NSLog(@"_antiLostMore3scanDataAyPP------------> %lu",_antiLostMore3scanDataAy.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.antiLostTb reloadData];
        });

        
    }else if([[notification name] isEqualToString:BACKGROUND_ACTIVE_BRODACAST]){
        
        
        if (isButtonOn) {

            //[_bgRadarRotate.layer removeAllAnimations];
            [self rotate360DegreeWithImageView:_bgRadarRotate];
          
        }

        
        
    }
    
    
    
    
}


#pragma mark - timeSp to date
-(NSString *)timeSp2date:(NSString *)timeSp{
    
    NSString * timeStampString = timeSp;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@", [objDateformat stringFromDate: date]);
    return [objDateformat stringFromDate: date];
    
}


#pragma mark - rssi level
-(NSString *)rssiLevel:(int) rssi{
    NSString *level = @"";
    NSLog(@"rssi --> %d",rssi);
    
    if (rssi >= -50) {
        
        int OffsetX = (arc4random() % 60) - 30;
        int OffsetY = (arc4random() % 60) - 30;
        UIImageView *radarDot = [[UIImageView alloc] initWithFrame:CGRectMake(90 - 3 + OffsetX,  90 - 3 + OffsetY, 6, 6)];
        radarDot.image = [UIImage imageNamed:@"ic_radar_dot"];
    
        [_bgRadaCircle addSubview:radarDot];

        
        
        level = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_strong"),rssi] ;
        
    }else if (rssi < -50 && rssi > - 80){
        
        
        int OffsetX = (arc4random() % 120) - 60;
        int OffsetY = (arc4random() % 120) - 60;
        UIImageView *radarDot = [[UIImageView alloc] initWithFrame:CGRectMake(90 - 3 + OffsetX,  90 - 3 + OffsetY, 6, 6)];
        radarDot.image = [UIImage imageNamed:@"ic_radar_dot"];
   
        [_bgRadaCircle addSubview:radarDot];

        
        level = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_good"),rssi] ;
        
        
    }else if (rssi <= -80){
        
        
        int OffsetX = (arc4random() % 160) - 90;
        int OffsetY = (arc4random() % 160) - 90;
        UIImageView *radarDot = [[UIImageView alloc] initWithFrame:CGRectMake(90 - 3 + OffsetX,  90 - 3 + OffsetY, 6, 6)];
        radarDot.image = [UIImage imageNamed:@"ic_radar_dot"];
       
        [_bgRadaCircle addSubview:radarDot];
        
     
        
        
        level = [NSString stringWithFormat:@"%@ (%d)",LOCALIZATION(@"text_rssi_weak"),rssi] ;
        
        
        
    }

    
    
    return level;
}

#pragma mark -- local push
- (void)scheduleLocalNotification : (NSString *)childName{
    [self setupNotificationSetting];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = [NSString stringWithFormat:@"%@%@",childName,LOCALIZATION(@"text_is_missing") ] ;
    localNotification.alertAction = LOCALIZATION(@"text_view_list");
    localNotification.category = @"shoppingListReminderCategory";
     localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber++;
    [UIApplication sharedApplication].applicationIconBadgeNumber ++;
    //localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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

#pragma mark - location manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    kidsLatitude = currLocation.coordinate.latitude;
    kidsLongitude = currLocation.coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}


#pragma mark - location timer
- (NSTimer *) locationTimer {
    if (!_locationTimer) {
        _locationTimer = [NSTimer timerWithTimeInterval:locationTimerInterval target:self selector:@selector(timerRefreshLocationSelector:) userInfo:nil repeats:YES];
    }
    return _locationTimer;
}

-(void) startLocationTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.locationTimer forMode:NSRunLoopCommonModes];
    NSLog(@"location timer start...");
}

- (void) stopLocationTimer{
    if (self.locationTimer != nil){
        [self.locationTimer invalidate];
        self.locationTimer = nil;
        NSLog(@"location timer stop...");
    }
}

-(void)timerRefreshLocationSelector:(NSTimer*)timer{
    NSString * macAddressList = @"";
    if (_locationAy.count > 0) {
        if (_locationAy.count == 1) {
            macAddressList = [NSString stringWithFormat:@"%@%@",[_locationAy objectAtIndex:0],@";"];
        }else{
            
            for (int i = 1; i < _locationAy.count ; i ++) {
                macAddressList = [NSString stringWithFormat:@"%@%@%@%@",macAddressList,@";",[_locationAy objectAtIndex:i],@";"];
            }
        }
    }
    NSUserDefaults *loginStatus = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[loginStatus objectForKey:LoginViewController_guardianId]];

    
    NSLog(@"macAddressList -> %@",macAddressList);

    NSDictionary *tempLocationDoct = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", [NSString stringWithFormat:@"%f",kidsLatitude] ,@"latitude",[NSString stringWithFormat:@"%f",kidsLongitude] ,@"longitude", @"300" ,@"radius" ,macAddressList,@"macAddressList",nil];
    
    [self postRequest:POST_LOCATION RequestDictionary:tempLocationDoct delegate:self];
    
    
    
    NSLog(@"timerRefreshLocationSelector...");
    
    [_locationAy removeAllObjects];
}

#pragma mark - sound
-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sos" ofType:@"wav"];
    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

