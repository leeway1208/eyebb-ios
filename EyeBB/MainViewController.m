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
#import "LDProgressView.h"
#import "UserDefaultsUtils.h"
//#import "DBImageView.h"
#import "AppDelegate.h"
#import "ChildrenListViewController.h"//查询简报儿童列表
#import "DBImageView.h"//图片加载
//彩色进度条
#import "GradientProgressView.h"

#import "WebViewController.h"

#import "KidViewController.h"//查询儿童列表

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,UIGestureRecognizerDelegate>
{
    /**滑动HMSegmentedControl*/
    int huaHMSegmentedControl;
    
    AppDelegate * myDelegate;
    
}
//-------------------视图控件--------------------
/**选项卡内容容器*/
@property (strong, nonatomic) UIScrollView *MainInfoScrollView;

/**房间信息*/
@property (strong, nonatomic) UITableView *RoomTableView;
/**雷达*/
@property (strong, nonatomic) UITableView *RadarTableView;
/**表现*/
@property (strong, nonatomic) UITableView *PerformanceTableView;
/**活动*/
@property (strong, nonatomic) UITableView *ActivitiesTableView;

/**个人*/
@property (strong, nonatomic) UITableView *PersonageTableView;
/**弹出框*/
@property (strong,nonatomic) UIScrollView * PopupSView;
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
@property (nonatomic) BOOL isallRoomOn;
/**自动刷新功能打开*/
@property (nonatomic) BOOL isautoOn;
/**是否刷新房间列表*/
@property (nonatomic) BOOL isreloadRoomList;
/**是否刷新系统通知*/
@property (nonatomic) BOOL isreloadpersonal;
/**是否加载简报信息*/
@property (nonatomic) BOOL isloadNews;
/**机构下标*/
@property (nonatomic) int organizationIndex;

/**时间格式*/
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
/***/
@property (nonatomic,strong) NSString *avgDaysStr;
/**刷新定时器*/
@property (nonatomic,strong)NSTimer * refreshTimer;

//-------------------跳转页面--------------------
@property (nonatomic,strong) WebViewController * web;


@end

@implementation MainViewController
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
   
    
    
    [self lc];
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
    if (myDelegate.childDictionary!=nil&&huaHMSegmentedControl==2&&self.isloadNews==YES) {
        
        [self insertChildMessage];
       
    }
    if(_isautoOn==YES&&huaHMSegmentedControl==0)
    {
        //开启定时器
        [self.refreshTimer setFireDate:[NSDate distantPast]];
    }
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
    _colorArray=@[[UIColor colorWithRed:0.282 green:0.800 blue:0.922 alpha:1],[UIColor colorWithRed:0.392 green:0.549 blue:0.745 alpha:1],[UIColor colorWithRed:0.396 green:0.741 blue:0.561 alpha:1],[UIColor colorWithRed:0.149 green:0.686 blue:0.663 alpha:1],[UIColor colorWithRed:0.925 green:0.278 blue:0.510 alpha:1],[UIColor colorWithRed:0.690 green:0.380 blue:0.208 alpha:1],[UIColor colorWithRed:0.898 green:0.545 blue:0.682 alpha:1],[UIColor colorWithRed:0.643 green:0.537 blue:0.882 alpha:1],[UIColor colorWithRed:0.847 green:0.749 blue:0.216 alpha:1],[UIColor colorWithRed:0.835 green:0.584 blue:0.329 alpha:1]];
    
    _organizationArray=[[NSMutableArray alloc]init];
    _childrenDictionary=[[NSMutableDictionary alloc]init];
    _personalDetailsArray=[[NSMutableArray alloc]init];
    _kidsRoomArray=[[NSMutableArray alloc]init];
    _childrenByRoomDictionary=[[NSMutableDictionary alloc]init];
    _dailyAvgFigureArray=[[NSMutableArray alloc]init];
    _activityInfosArray=[[NSMutableArray alloc]init];
    _isallRoomOn=NO;
    _isautoOn=NO;
    _isreloadRoomList=YES;
    _isreloadpersonal=YES;
    _isloadNews=YES;
    self.avgDaysStr=@"5";
    self.organizationIndex=0;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
//    [fileManager createDirectoryAtPath:@"localImg" withIntermediateDirectories:YES attributes:nil error:nil];
//     _documentsDirectoryPath=[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"localImg"];
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"_documentsDirectoryPath is%@",_documentsDirectoryPath);
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    _NewsBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4*2, 20, Drive_Wdith/4, 44)];
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
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-64, 44.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    labelTitle.text = LOCALIZATION(@"text_indoor_locator");
    
    [titleView addSubview:labelTitle];
    
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
    UIView *organizationShowBtnShowView =[[UIView alloc]initWithFrame:CGRectMake(0, 45, Drive_Wdith, 44)];
    organizationShowBtnShowView.backgroundColor=[UIColor whiteColor];
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
    [organizationShowBtnShowView addSubview:_organizationShowBtn];
    _organizationShowBtn.hidden=YES;
    [_MainInfoScrollView addSubview:organizationShowBtnShowView];
    
    //室内定位显示选择
    UIButton * childrenListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_MainInfoScrollView.frame)-40, CGRectGetWidth(_MainInfoScrollView.frame), 40)];
    
    //设置按显示title
    [childrenListBtn setTitle:@"儿童列表" forState:UIControlStateNormal];
    [childrenListBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    //设置按钮背景颜色
    [childrenListBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [childrenListBtn addTarget:self action:@selector(childrenListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_MainInfoScrollView addSubview:childrenListBtn];
    
   
    
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
    _RadarTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    
    _RadarTableView.dataSource = self;
    _RadarTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_RadarTableView];
    
    //------------------------简报-------------------------------

    //简报名称
    UIView *NewsView=[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith*2, 0, Drive_Wdith, 54)];
    NewsView.backgroundColor=[UIColor clearColor];
    
    UILabel *NewsLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 54.0f)];
    [NewsLbl setBackgroundColor:[UIColor clearColor]];
    NewsLbl.font=[UIFont fontWithName:@"Helvetica" size:20];
    NewsLbl.textAlignment = NSTextAlignmentLeft;
    NewsLbl.textColor=[UIColor blackColor];
    
    NewsLbl.text = LOCALIZATION(@"text_report");
    
    [NewsView addSubview:NewsLbl];
    
    //选择要查看的儿童
    UIButton * NewsBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-92, 5, 72, 44)];

    //设置按钮背景颜色
    [NewsBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
//<<<<<<< Updated upstream
//    [NewsBtn addTarget:self action:@selector(reportViewChangeChildBtmAction:) forControlEvents:UIControlEventTouchUpInside];
//=======
    [NewsBtn addTarget:self action:@selector(showChildrenList) forControlEvents:UIControlEventTouchUpInside];
//>>>>>>> Stashed changes
    
    [NewsView addSubview:NewsBtn];
    
    [_MainInfoScrollView addSubview:NewsView];
    //kids头像
    kidImgView=[[DBImageView alloc] initWithFrame:CGRectMake(0, 7, 30, 30)];
    [kidImgView.layer setCornerRadius:CGRectGetHeight([kidImgView bounds]) / 2];
    [kidImgView.layer setMasksToBounds:YES];
    [kidImgView.layer setBorderWidth:2];
    
    [kidImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
//    [kidImgView setImage:[UIImage imageNamed:@"20150207105906"]];
    //    kindImgView.tag=206;
    [NewsBtn addSubview:kidImgView];
    kidImgView.hidden=YES;
    
    
    
    
    UILabel *revampLbl = [[UILabel alloc] initWithFrame:CGRectMake(32.0f, 0.0f, CGRectGetWidth(NewsBtn.bounds)-42, 44.0f)];
    [revampLbl setBackgroundColor:[UIColor clearColor]];
    revampLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    revampLbl.textAlignment = NSTextAlignmentLeft;
    revampLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    revampLbl.text = LOCALIZATION(@"text_change");
    
    [NewsBtn addSubview:revampLbl];
    if(revampLbl.text.length>2)
    {
       
        NewsBtn.frame=CGRectMake(Drive_Wdith-((revampLbl.text.length*9)+55), 5, (revampLbl.text.length*9)+45, 44);
         revampLbl.frame=CGRectMake(32.0f, 0.0f, (revampLbl.text.length*9), 44.0f);
    }
    
    UIImageView * ImgView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(NewsBtn.bounds)-12, 14, 12, 16)];
    [ImgView setImage:[UIImage imageNamed:@"arrow_go"]];
    //    kindImgView.tag=206;
    [NewsBtn addSubview:ImgView];
    
    
    //通告标题
    UIView *changeView =[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith*2+10, 54, Drive_Wdith-20, 44)];
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
    _PerformanceTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith*2+10, 98, CGRectGetWidth(_MainInfoScrollView.frame)-20, 40)];
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
    UILabel *todayLbl = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 14.0f, (str.length>2?str.length*8.0f:str.length*15), 16.0f)];
    [todayLbl setBackgroundColor:[UIColor clearColor]];
    todayLbl.font=[UIFont fontWithName:@"Helvetica" size:14];
    todayLbl.textAlignment = NSTextAlignmentLeft;
    todayLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    todayLbl.text = str;
    [_PerformanceTimeBtn addSubview:todayLbl];
    

    //自定义色块 todayLbl.bounds
    UILabel *customizedColorLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(todayLbl.bounds)+todayLbl.frame.origin.x+5, 14.0f, 14.0f, 14.0f)];
    [customizedColorLbl setBackgroundColor:[UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1]];
    [_PerformanceTimeBtn addSubview:customizedColorLbl];
    //自定义
    NSString *str2=LOCALIZATION(@"text_customized");
    UILabel *customizedLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(customizedColorLbl.bounds)+customizedColorLbl.frame.origin.x+5, 14.0f, (str2.length>4?str2.length*7.5f:str2.length*15), 16.0f)];
    [customizedLbl setBackgroundColor:[UIColor clearColor]];
    customizedLbl.font=[UIFont fontWithName:@"Helvetica" size:14];
    customizedLbl.textAlignment = NSTextAlignmentLeft;
    customizedLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    customizedLbl.text = str2;
    [_PerformanceTimeBtn addSubview:customizedLbl];

     NSString *str3=LOCALIZATION(@"this_Week");
    //查询条件
    _conditionLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(customizedLbl.bounds)+customizedLbl.frame.origin.x, 14.0f, (str3.length>2?str3.length*8.0f:str3.length*15), 16.0f)];
    [_conditionLbl setBackgroundColor:[UIColor clearColor]];
    _conditionLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    _conditionLbl.textAlignment = NSTextAlignmentLeft;
    _conditionLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    _conditionLbl.text = str3;
    [_PerformanceTimeBtn addSubview:_conditionLbl];

    _conditionImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_conditionLbl.bounds)+_conditionLbl.frame.origin.x, 15.5,20,13)];
    [_conditionImgView setImage:[UIImage imageNamed:@"arrow_down"]];
     [_PerformanceTimeBtn addSubview:_conditionImgView];
    
    
    //初始化表现列表
    _PerformanceTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*2+10, 138, CGRectGetWidth(_MainInfoScrollView.frame)-20, CGRectGetHeight(_MainInfoScrollView.frame)-138)];
    _PerformanceTableView.dataSource = self;
    _PerformanceTableView.delegate = self;
    //隐藏table自带的cell下划线
    _PerformanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_PerformanceTableView];
//    _PerformanceTableView.hidden=YES;
    

    
    //初始化活动列表
    _ActivitiesTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*2+10, 98, CGRectGetWidth(_MainInfoScrollView.frame)-20, CGRectGetHeight(_MainInfoScrollView.frame)-98)];
    _ActivitiesTableView.dataSource = self;
    _ActivitiesTableView.delegate = self;
    self.ActivitiesTableView.tableFooterView = [[UIView alloc] init];
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_ActivitiesTableView];
      _ActivitiesTableView.hidden=YES;
    
    _bulletinLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, Drive_Wdith-20, 30)];
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
    
    
    _UserNameLbl.text = [userDefaultes objectForKey:LoginViewController_accName];
    
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
    
    UILabel * PersonageLbl = [[UILabel alloc] initWithFrame:CGRectMake(-1.0f, -1.0f, Drive_Wdith+2, 31.0f)];
    [PersonageLbl setBackgroundColor:[UIColor clearColor]];
    PersonageLbl.font=[UIFont fontWithName:@"Helvetica" size:16];
    PersonageLbl.textAlignment = NSTextAlignmentCenter;
    PersonageLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    [PersonageLbl.layer setBorderWidth:1.0]; //边框宽度
    [PersonageLbl.layer setBorderColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1].CGColor];//边框颜色
    PersonageLbl.text = LOCALIZATION(@"text_notifications");
    
    [PersonageTitleView addSubview:PersonageLbl];
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
    
    UIImageView * KidsImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 75, 75)];
    [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
    [KidsImgView.layer setMasksToBounds:YES];
    [KidsImgView.layer setBorderWidth:2];
    
    [KidsImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    
            [KidsImgView setImage:[UIImage imageNamed:@"logo_en"]];
    
    KidsImgView.tag=219;
    [_kidsMassageView addSubview:KidsImgView];
    
    UILabel * kidNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 10, CGRectGetWidth(_kidsMassageView.frame)-100, 20)];
    [kidNameLbl setText:@"sss"];
    //            [messageLbl setAlpha:0.6];
    [kidNameLbl setFont:[UIFont systemFontOfSize: 15.0]];
    [kidNameLbl setTextColor:[UIColor blackColor]];
    [kidNameLbl setTextAlignment:NSTextAlignmentLeft];
    kidNameLbl.tag=220;
    [_kidsMassageView addSubview:kidNameLbl];
    
    UILabel * roomNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 35, CGRectGetWidth(_kidsMassageView.frame)-100, 20)];
    [roomNameLbl setText:@"sss"];
    //            [messageLbl setAlpha:0.6];
    [roomNameLbl setFont:[UIFont systemFontOfSize: 15.0]];
    [roomNameLbl setTextColor:[UIColor blackColor]];
    [roomNameLbl setTextAlignment:NSTextAlignmentLeft];
    roomNameLbl.tag=221;
    [_kidsMassageView addSubview:roomNameLbl];
    
    //间隔线
    divisionRadarLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_kidsMassageView.frame)-41, CGRectGetWidth(_kidsMassageView.frame), 1)];
    [divisionRadarLbl setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [_kidsMassageView addSubview:divisionRadarLbl];
    
    //提交按钮
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_kidsMassageView.frame)-40,CGRectGetWidth(_kidsMassageView.frame), 40)];
    //设置按显示文字
    [closeBtn setTitle:LOCALIZATION(@"btn_back") forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_kidsMassageView addSubview:closeBtn];

    
  
    
    
    
    //机构显示选择列表
    _organizationTableView=[[UITableView alloc]initWithFrame:CGRectMake(20, 132, (Drive_Wdith-20)/2, 44)];
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
    UILabel *listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_listTypeView.frame), 44)];
    [listtitleLal setText:LOCALIZATION(@"btn_options")];
    [listtitleLal setTextColor:[UIColor blackColor]];
    [listtitleLal setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [listtitleLal setTextAlignment:NSTextAlignmentCenter];
    [listtitleLal setBackgroundColor:[UIColor clearColor]];
    [_listTypeView addSubview:listtitleLal];
    
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
            return (110+(((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*kindRow));
            tempChildArray=nil;
        }
        else
        {
            return 110;
        }
    }
    
    if(tableView == self.RadarTableView){
        
        return 70;
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
    else if(tableView == self.RadarTableView){
        return 1;
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
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"nameSc"];
                break;
            case 1:
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"nameTc"];
                break;
            case 2:
                cell.textLabel.text=[[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"area"]objectForKey:@"name"];
                break;
                
            default:
                break;
        }
        
        cell.textLabel.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    }
    //房间列表
    else if(tableView == self.RoomTableView){
        
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
            [RoomImgView setImageWithPath:[pathOne copy]];
             pathOne=nil;

            RoomImgView.tag=202;
            [RoomBtn addSubview:RoomImgView];
            
            //房间名称
            UILabel * RoomLbl =[[UILabel alloc]initWithFrame:CGRectMake(72, 17, CGRectGetWidth(cell.frame)-100, 20)];
            
            
            if (_roomArray.count>0) {

                switch (myDelegate.applanguage) {
                    case 0:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]];
                        break;
                    case 1:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]];
                        break;
                    case 2:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"namec"]];
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
                

                [kindImgView setImageWithPath:[pathOne copy]];
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
      
//                [kindBtn.layer setMasksToBounds:YES];
//                [kindBtn.layer setBorderWidth:2];
                [kindBtn setBackgroundColor:[UIColor clearColor]];
                
//                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
//                if (tempChildArray.count>0&&![[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]] isEqualToString:@""]) {
//                    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]];
//                    
//                    NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
//                    NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."] copy];
//
//
//                    
//                    if ([self loadImage:[array2 objectAtIndex:0] ofType:[[array2 objectAtIndex:1] copy ]inDirectory:_documentsDirectoryPath]!=nil) {
//                        
//                         [kindBtn setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath] forState:UIControlStateNormal];
//                    }
//                    else
//                    {
//                        NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//                        NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
//                        [kindBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//                        //Get Image From URL
//                        UIImage * imageFromURL  = nil;
//                        imageFromURL=[UIImage imageWithData:data];
//                        //Save Image to Directory
//                        [self saveImage:imageFromURL withFileName:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath];
//                        
//                        
//                    }
//                    pathOne=nil;
//                    array=nil;
//                    array2=nil;
//
//                }
//                else
//                {
//                    [kindBtn setImage:[UIImage imageNamed:@"logo_en"] forState:UIControlStateNormal];
//                }
//
                
                
                
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKindAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000+i;
                [RoomBtn addSubview:kindBtn];
            }
            
            
        }
        if ([cell viewWithTag:201]!=nil) {
            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
            RoomBtn.frame=CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, 100+((CGRectGetWidth(cell.frame)-10-130)/4+8)*kindRow);
            if(indexPath.row>9)
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:(indexPath.row%10)]];
            }
            else
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            }

            DBImageView * RoomImgView=(DBImageView *)[RoomBtn viewWithTag:202];
            [RoomImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];

                [RoomImgView setImageWithPath:[pathOne copy]];

            pathOne=nil;
            
            UILabel * RoomLbl=(UILabel *)[RoomBtn viewWithTag:203];
            if (_roomArray.count>0) {
                
                switch (myDelegate.applanguage) {
                    case 0:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]];
                        break;
                    case 1:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]];
                        break;
                    case 2:
                        [RoomLbl setText:[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"namec"]];
                        break;
                        
                    default:
                        break;
                }
            }
            else
            {
                [RoomLbl setText:@"*****"];
            }            //            [LoginBtn setAlpha:0.4];
            
            
            UIView * roomKindNumView=(UIView *)[RoomBtn viewWithTag:204];
            roomKindNumView.frame=CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20);
            UILabel * KindNumLbl=(UILabel *)[RoomBtn viewWithTag:205];
            KindNumLbl.frame=CGRectMake(30, 0, CGRectGetWidth(roomKindNumView.frame)-35, 20);
            [KindNumLbl setText:str];
            
            for (UIView *view in [RoomBtn subviews])
            {
                //                NSLog(@"view.tag is%d",view.tag);
                
                if ([view isKindOfClass:[UIView class]]&&view.tag>999)
                {
                    [view removeFromSuperview];
                }
            }
            
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

                [kindImgView setImageWithPath:[pathOne copy]];
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
                
//                kindBtn.frame=CGRectMake(72+((CGRectGetWidth(RoomBtn.frame)-130)/4+10)*(i%4),45+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*sNum , (CGRectGetWidth(RoomBtn.frame)-130)/4, (CGRectGetWidth(RoomBtn.frame)-130)/4);
                 kindBtn.frame=kindImgView.frame;
//                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                //                [kindBtn.layer setMasksToBounds:YES];
                //                [kindBtn.layer setBorderWidth:2];
                [kindBtn setBackgroundColor:[UIColor clearColor]];
                
                //                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                //                if (tempChildArray.count>0&&![[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]] isEqualToString:@""]) {
                //                    NSString* pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]];
                //
                //                    NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
                //                    NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."] copy];
                //
                //
                //
                //                    if ([self loadImage:[array2 objectAtIndex:0] ofType:[[array2 objectAtIndex:1] copy ]inDirectory:_documentsDirectoryPath]!=nil) {
                //
                //                         [kindBtn setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath] forState:UIControlStateNormal];
                //                    }
                //                    else
                //                    {
                //                        NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
                //                        NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
                //                        [kindBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                //                        //Get Image From URL
                //                        UIImage * imageFromURL  = nil;
                //                        imageFromURL=[UIImage imageWithData:data];
                //                        //Save Image to Directory
                //                        [self saveImage:imageFromURL withFileName:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath];
                //
                //
                //                    }
                //                    pathOne=nil;
                //                    array=nil;
                //                    array2=nil;
                //
                //                }
                //                else
                //                {
                //                    [kindBtn setImage:[UIImage imageNamed:@"logo_en"] forState:UIControlStateNormal];
                //                }
                //
                
                
                
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
                        [messageLbl setText:[tempDictionary objectForKey:@"titleSc"]];
                        break;
                    case 1:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleTc"]];
                        break;
                    case 2:
                        [messageLbl setText:[tempDictionary objectForKey:@"title"]];
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
            UIImageView * messageImgView=(UIImageView *)[cell viewWithTag:206];
            if (_personalDetailsArray.count>0&&![pathOne isEqualToString:@""]&&![pathOne isEqualToString:@"<null>"]&&indexPath.row>0) {
                
                
                NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
                NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."]copy];
                
                
                
                if ([self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath]!=nil) {
                    [messageImgView setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath]];
                    
                }
                else
                {
                    NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
                    NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
                    [messageImgView setImage:[UIImage imageWithData:data]];
                    //Get Image From URL
                    UIImage * imageFromURL  = nil;
                    imageFromURL=[UIImage imageWithData:data];
                    //Save Image to Directory
                    [self saveImage:imageFromURL withFileName:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath];
                    
                    
                }
                pathOne=nil;
                array=nil;
                array2=nil;
            }
            else
            {
                
                [messageImgView setImage:[UIImage imageNamed:@"logo_en"]];
            }

            
        }
        
        if([cell viewWithTag:207]!=nil)
        {
            UILabel * messageLbl =(UILabel *)[cell viewWithTag:207];
            if (indexPath.row>0) {
                switch (myDelegate.applanguage) {
                    case 0:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleSc"]];
                        break;
                    case 1:
                        [messageLbl setText:[tempDictionary objectForKey:@"titleTc"]];
                        break;
                    case 2:
                        [messageLbl setText:[tempDictionary objectForKey:@"title"]];
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
            LDProgressView *progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 25)];
            progressView.showText = @NO;
            progressView.flat = @YES;
            progressView.animate = @NO;
            progressView.borderRadius = @0;
            progressView.type = LDProgressSolid;
            progressView.color = [UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1];
            progressView.tag=210;
            [cell addSubview:progressView];
            
            //本日数据
            UILabel *progressLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 25)];

            
            [progressLbl setTextColor:[UIColor colorWithRed:0.808 green:0.808 blue:0.776 alpha:1]];
            [progressLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [progressLbl setTextAlignment:NSTextAlignmentRight];
            [progressLbl setTag:224];
            [cell addSubview:progressLbl];
            
            
    
            //自定义数据条
            progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 55, Drive_Wdith-60, 25)];
            progressView.showText = @NO;
            progressView.flat = @YES;
            progressView.animate = @NO;
            progressView.borderRadius = @0;
            progressView.type = LDProgressSolid;
            progressView.color = [UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1];
            progressView.tag=223;
            [cell addSubview:progressView];
         
           
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
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locNameSc"]];
                        break;
                    case 1:
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locNameTc"]];
                        break;
                    case 2:
                        [roomNameLbl setText:[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"locName"]];
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

             LDProgressView *progressView = (LDProgressView *)[cell viewWithTag:210];
            if (_dailyAvgFigureArray.count>0) {
                if ([[[_dailyAvgFigureArray objectAtIndex:indexPath.row]objectForKey:@"daily"] integerValue]>0) {
                  
                    UILabel *progressLbl =(UILabel *)[cell viewWithTag:224];
                    
                    int num=(int)[[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"daily"]doubleValue];
                    progressView.progress =num*1.00/([self.avgDaysStr doubleValue]*24.00*60.00);
                    [progressLbl setText:[NSString stringWithFormat:@"%dhr %dmin",num/60,num%60]];
                }
                else
                {
                    progressView.progress = 0.00;
                }
            }
            else
            {
                progressView.progress = 0.00;
                
               
            }

            
        }
        
        if([cell viewWithTag:223]!=nil)
        {
            LDProgressView *progressView = (LDProgressView *)[cell viewWithTag:223];
            if (_dailyAvgFigureArray.count>0) {
                
                if ([[[_dailyAvgFigureArray objectAtIndex:indexPath.row]objectForKey:@"average"] integerValue]>0) {
                    
                    
                    
//                    progressView.progress = 0.50;
                    
                    int num=(int)[[[_dailyAvgFigureArray objectAtIndex:indexPath.row] objectForKey:@"average"]doubleValue];
                    progressView.progress =num*1.00/([self.avgDaysStr doubleValue]*24.00*60.00);
                    
                    
                    UILabel *progressLbl =(UILabel *)[cell viewWithTag:225];
                    [progressLbl setText:[NSString stringWithFormat:@"%dhr %dmin",num/60,num%60]];
                }
                else
                {
                    progressView.progress = 0.00;
                }
            }
            else
            {
                progressView.progress = 0.00;
               
            
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
                      [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"titleSc"]];
                    break;
                case 1:
                      [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"titleTc"]];
                    break;
                case 2:
                      [messageLbl setText:[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
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
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameSc"];
                break;
            case 1:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameTc"];
                break;
            case 2:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"name"];
                break;
                
            default:
                break;
        }

        [self.organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
        
        UIImageView * osBtnImgView=(UIImageView *)[self.organizationShowBtn viewWithTag:218];
        osBtnImgView.frame=CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),15.5,20,13);
        [_RoomTableView reloadData];
    }
    //活动
    else if(tableView ==self.ActivitiesTableView)
    {
        NSString *urlStr;
        
        switch (myDelegate.applanguage) {
            case 0:
               urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activitySc"];
                break;
            case 1:
                 urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activityTc"];
                break;
            case 2:
                urlStr=[[_activityInfosArray objectAtIndex:indexPath.row] objectForKey:@"activity"];
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
            
        }
        else
        {
 NSString *urlStr;
            switch (myDelegate.applanguage) {
                case 0:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"noticeSc"];
                    break;
                case 1:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"noticeTc"];
                    break;
                case 2:
                    urlStr=[[_personalDetailsArray objectAtIndex:indexPath.row-1] objectForKey:@"notice"];
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
////            //        [self.RadarTableView tableViewDidScroll:scrollView];
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
////            //        [self.RadarTableView tableViewDidScroll:scrollView];
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
        if (scrollView.contentOffset.x!=320.000000) {
            
            huaHMSegmentedControl = (int)page;
            switch (huaHMSegmentedControl) {
                case 0:
                    if ([_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count<1) {
                        _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
                        _bulletinLbl.hidden=NO;
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
                case 2:
                    if(_ActivitiesTableView.hidden==YES)
                    {
                        _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
                        _bulletinLbl.hidden=NO;
                        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                        //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                        [self.view bringSubviewToFront:_bulletinLbl];
                    }
                    else
                    {
                        _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
                        _bulletinLbl.hidden=NO;
                        _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                        [self.view bringSubviewToFront:_bulletinLbl];

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
                    _progressView.frame=CGRectMake(Drive_Wdith*3, 0.0f, Drive_Wdith, 3.0f);
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
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"系统提示"
                                        message:@"IOS暂时不支持此功能，敬请期待"
                                       delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            if (huaHMSegmentedControl==0) {
                [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }
            else if (huaHMSegmentedControl==2)
            {
                [scrollView setContentOffset:CGPointMake(640,0) animated:YES];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollView is %@",scrollView.class);
CGPoint pt = [scrollView contentOffset];
    if (scrollView==_RoomTableView&& pt.y < -68.500000) {
        
               _progressView.hidden=NO;
//        [_progressView setProgress:0.0];
        
        
//        [self simulateProgress];
        [self getRequest:GET_CHILDREN_LOC_LIST delegate:self RequestDictionary:nil];
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
        [self delLodChild];
            
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
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameSc"];
                break;
            case 1:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"nameTc"];
                break;
            case 2:
                organizationStr=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"area"] objectForKey:@"name"];
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
        

        
       _allRoomArray=[[[_organizationArray objectAtIndex:self.organizationIndex] objectForKey:@"locations"] copy];
         NSMutableArray *tempChindrenArray=[[NSMutableArray alloc]init];
        if(tempArray){
            for(int i=0;i<_allRoomArray.count;i++)
            {
                for(int j=0;j<tempArray.count;j++)
                {
                    
                    if([[[tempArray objectAtIndex:j] objectForKey:@"locId"] longLongValue] ==[[[_allRoomArray objectAtIndex:i] objectForKey:@"locationId"] longLongValue])
                    {
                        [tempChindrenArray addObject:[[tempArray objectAtIndex:j]copy]];
                        
                        
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
        [_RoomTableView reloadData];
        [tempChindrenArray removeAllObjects];
        tempChindrenArray=nil;
        tempArray=nil;
        _isreloadRoomList=NO;
            
           
        }
            
else
{
    _bulletinLbl.frame=CGRectMake(10, 120, Drive_Wdith-20, 30);
    _bulletinLbl.hidden=NO;
}
        
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

-(void)insertChildMessage
{
    if (![_childrenByAreaArray isEqual:[NSNull null]]&&_childrenByAreaArray.count>0) {
     kidImgView.hidden=NO;
    NSString* pathOne =[NSString stringWithFormat: @"%@",[myDelegate.childDictionary objectForKey:@"icon" ]];
    
      [kidImgView setImageWithPath:[pathOne copy]];
    

    
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

#pragma mark --
#pragma mark - Handle Gestures

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    [_PopupSView setHidden:YES];
}



#pragma mark --点击事件

/**弹出房间列表显示设置*/
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
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:@"请先录入儿童信息"
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
        tt._childrenArray=[[_childrenByAreaArray objectAtIndex:self.organizationIndex] objectForKey:@"childrenBean"];
        [self.navigationController pushViewController:tt animated:YES];
        tt .title = @"";
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:@"请先录入儿童信息"
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
   
}

-(void)goToSettingAction:(id)sender
{
    _settingVc= [[SettingsViewController alloc] init];
    
    
        [self.navigationController pushViewController:self.settingVc animated:YES];
        self.settingVc.title = LOCALIZATION(@"btn_options");
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
                                    message:@"请先录入儿童信息"
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
    }
}






/**儿童头像点击事件*/
- (void)ShowKindAction:(id)sender
{

   
    UIButton *tempBtn=sender;
    
    
    UITableViewCell *cell = (UITableViewCell *)[tempBtn superview];
    NSIndexPath *indexPath = [self.RoomTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %zi",indexPath.row);
     NSArray *tempChildArray=[_childrenDictionary objectForKey:[NSString stringWithFormat:@"%zi",indexPath.row]];
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [_listTypeView setHidden:YES];
    [_dateTableView setHidden:YES];
    [_organizationTableView setHidden:YES];
    
    [_kidsMassageView setHidden:NO];
    
    UIImageView * KidsImgView=(UIImageView *)[_kidsMassageView viewWithTag:219];
    KidsImgView.image= tempBtn.imageView.image;
    UILabel * kidNameLbl =(UILabel *)[_kidsMassageView viewWithTag:220];
    [kidNameLbl setText:[[[[tempChildArray objectAtIndex:(tempBtn.tag-1000)] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
    UILabel * roomNameLbl =(UILabel *)[_kidsMassageView viewWithTag:221];
    switch (myDelegate.applanguage) {
        case 0:
            [roomNameLbl setText:[NSString stringWithFormat:@"@ %@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"]]];
            break;
        case 1:
            [roomNameLbl setText:[NSString stringWithFormat:@"@ %@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"nameTc"]]];
            break;
        case 2:
            [roomNameLbl setText:[NSString stringWithFormat:@"@ %@",[[_roomArray objectAtIndex:indexPath.row] objectForKey:@"locationName"]]];
            break;
            
        default:
            break;
    }
    
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
    int num=tempBtn.tag-214;
    if(num !=1)
    {
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
                    _bulletinLbl.frame=CGRectMake(10, 200, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                    //        _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                    [self.view bringSubviewToFront:_bulletinLbl];
                }
                else
                {
                    _bulletinLbl.frame=CGRectMake(10, 160, Drive_Wdith-20, 30);
                    _bulletinLbl.hidden=NO;
                    _bulletinLbl.text=LOCALIZATION(@"text_no_content");
                    _ActivitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                    [self.view bringSubviewToFront:_bulletinLbl];
                    
                }
                
                break;
            case 217:
                _bulletinLbl.hidden=YES;
                _progressView.frame=CGRectMake(Drive_Wdith*3, 0.0f, Drive_Wdith, 1.0f);
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
    }
    else
    {
        
        [[[UIAlertView alloc] initWithTitle:@"系统提示"
                                    message:@"IOS暂时不支持此功能，敬请期待"
                                   delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        [self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
    }
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
}
//提交按钮
- (void)closeAction
{
    [_PopupSView setHidden:YES];
    
    
   
}




@end

