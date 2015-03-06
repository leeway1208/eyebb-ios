//
//  MainViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-24.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "KindlistViewController.h"
#import "JSONKit.h"
#import "MSCellAccessory.h"
#import "LDProgressView.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,UIGestureRecognizerDelegate>
{
    /**滑动HMSegmentedControl*/
    int huaHMSegmentedControl;
    
    NSInteger kindNum;
    
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
/**列表显示模式列表*/
@property (strong,nonatomic) UITableView * listTypeTableView;
/**列表显示模式改变按钮*/
@property (strong,nonatomic) UIButton * listTypeChangeBtn;
/**是否自动刷新对应显示图标*/
@property (strong,nonatomic) UIImageView * refreshImgView;
/**是否显示所有房间图标*/
@property (strong,nonatomic) UIImageView * ShowALLRoomImgView;
/**选择机构按钮*/
@property (strong,nonatomic) UIButton * organizationShowBtn;
/**机构列表*/
@property (strong,nonatomic) UITableView * organizationTableView;
/**查询日期范围列表*/
@property (strong,nonatomic) UITableView * dateTableView;
/**用户名称*/
@property (strong,nonatomic) UILabel * UserNameLbl;
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


/**活动按钮*/
@property (strong,nonatomic) UIButton * HomeBtn;
/**活动按钮*/
@property (strong,nonatomic) UIButton * RadarBtn;
/**活动按钮*/
@property (strong,nonatomic) UIButton * NewsBtn;
/**活动按钮*/
@property (strong,nonatomic) UIButton * PersonageBtn;


//间隔线2
@property (strong,nonatomic) UILabel *divisionTwoLbl;
//间隔线4
@property (strong,nonatomic) UILabel *divisionFourLbl;
//-------------------视图变量--------------------
/**房间背景颜色数组*/
@property (strong,nonatomic) NSArray *colorArray;
/**机构数组*/
@property (strong,nonatomic) NSMutableArray * organizationArray;

@property (nonatomic,strong) SettingsViewController *settingVc;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = LOCALIZATION(@"app_name");
    // Do any additional setup after loading the view.
    [self iv];
//    [self getRequest:@"kindergartenList" delegate:self];
    [self getRequest:@"reportService/api/childrenLocList" delegate:self];
   
    
    
    [self lc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


/**
 *初始化参数
 */
-(void)iv
{
    _colorArray=@[[UIColor colorWithRed:0.282 green:0.800 blue:0.922 alpha:1],[UIColor colorWithRed:0.392 green:0.549 blue:0.745 alpha:1],[UIColor colorWithRed:0.396 green:0.741 blue:0.561 alpha:1],[UIColor colorWithRed:0.149 green:0.686 blue:0.663 alpha:1],[UIColor colorWithRed:0.925 green:0.278 blue:0.510 alpha:1],[UIColor colorWithRed:0.690 green:0.380 blue:0.208 alpha:1],[UIColor colorWithRed:0.898 green:0.545 blue:0.682 alpha:1],[UIColor colorWithRed:0.643 green:0.537 blue:0.882 alpha:1],[UIColor colorWithRed:0.847 green:0.749 blue:0.216 alpha:1],[UIColor colorWithRed:0.835 green:0.584 blue:0.329 alpha:1]];
    
    _organizationArray=[[NSMutableArray alloc]init];
    
    kindNum=1;
}

/**
 *加载控件
 */
-(void)lc
{
    
//    UISegmentedControl *segmentedControl = [ [ UISegmentedControl alloc ]initWithItems:[NSArray arrayWithObjects:@"",@"",@"",@"",nil]];
//    segmentedControl.frame=CGRectMake(0, 20, Drive_Wdith, 44);
//    segmentedControl.segmentedControlStyle =
//    UISegmentedControlStyleBar;
//  
//    segmentedControl.tintColor = [UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
////    [ segmentedControl insertSegmentWithTitle:
////     @"All" atIndex: 0 animated: NO ];
////    [ segmentedControl insertSegmentWithTitle:
////     @"Missed" atIndex: 1 animated: NO ];
//    [segmentedControl setImage:[UIImage imageNamed:@"actbar_home"] forSegmentAtIndex:0];
//    [segmentedControl setImage:[UIImage imageNamed:@"actbar_tracking"] forSegmentAtIndex:1];
//    [segmentedControl setImage:[UIImage imageNamed:@"actbar_profile"] forSegmentAtIndex:2];
//    [segmentedControl setImage:[UIImage imageNamed:@"actbar_report"] forSegmentAtIndex:3];
//    segmentedControl.selectedSegmentIndex = 0;
//    
//    [segmentedControl addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl];
    
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
    //室内定位titleView
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 44.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    labelTitle.text = @"室内定位";
    
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
    UIView *organizationShowBtnShowView =[[UIView alloc]initWithFrame:CGRectMake(0, 44, Drive_Wdith, 44)];
    organizationShowBtnShowView.backgroundColor=[UIColor whiteColor];
    //室内定位显示选择
    NSString *organizationStr=@"你你你你";
    _organizationShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, Drive_Wdith-30, 44)];
    //设置按显示title
    [_organizationShowBtn setTitle:organizationStr forState:UIControlStateNormal];
    [_organizationShowBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]  forState:UIControlStateNormal];
    //设置按钮title的对齐
    [_organizationShowBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_organizationShowBtn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 20)];
    
    UIImageView * osBtnImgView=[[UIImageView alloc]initWithFrame:CGRectMake((organizationStr.length*15+20>(CGRectGetWidth(_organizationShowBtn.frame)-20)?(CGRectGetWidth(_organizationShowBtn.frame)-20):(organizationStr.length*15+20)),14.5,15,15)];
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
    _RoomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame)-128)];
    
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
    UIButton * NewsBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-82, 5, 62, 44)];

    //设置按钮背景颜色
    [NewsBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [NewsBtn addTarget:self action:@selector(goToSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [NewsView addSubview:NewsBtn];
    
    [_MainInfoScrollView addSubview:NewsView];
    
    UIImageView * kindImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [kindImgView.layer setCornerRadius:CGRectGetHeight([kindImgView bounds]) / 2];
    [kindImgView.layer setMasksToBounds:YES];
    [kindImgView.layer setBorderWidth:2];
    
    [kindImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [kindImgView setImage:[UIImage imageNamed:@"20150207105906"]];
    //    kindImgView.tag=206;
    [NewsBtn addSubview:kindImgView];
    
    UILabel *revampLbl = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 0.0f, CGRectGetWidth(NewsBtn.bounds)-32, 44.0f)];
    [revampLbl setBackgroundColor:[UIColor clearColor]];
    revampLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    revampLbl.textAlignment = NSTextAlignmentLeft;
    revampLbl.textColor=[UIColor colorWithRed:0.925 green:0.247 blue:0.212 alpha:1];
    revampLbl.text = LOCALIZATION(@"text_change");
    
    [NewsBtn addSubview:revampLbl];
    if(revampLbl.text.length>2)
    {
       
        NewsBtn.frame=CGRectMake(Drive_Wdith-((revampLbl.text.length*9)+45), 5, (revampLbl.text.length*9)+35, 44);
         revampLbl.frame=CGRectMake(22.0f, 0.0f, (revampLbl.text.length*9), 44.0f);
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
    [_PerformanceTimeBtn addTarget:self action:@selector(goToSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    UILabel *customizedLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(customizedColorLbl.bounds)+customizedColorLbl.frame.origin.x+5, 14.0f, (str2.length>3?str2.length*7.5f:str2.length*15), 16.0f)];
    [customizedLbl setBackgroundColor:[UIColor yellowColor]];
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

    UIImageView * conditionImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_conditionLbl.bounds)+_conditionLbl.frame.origin.x, 14.0f, 15.0F, 15.0F)];
    [conditionImgView setImage:[UIImage imageNamed:@"arrow_down"]];
     [_PerformanceTimeBtn addSubview:conditionImgView];
    
    
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
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_ActivitiesTableView];
      _ActivitiesTableView.hidden=YES;
    
    //------------------------个人信息-------------------------------
    
    
    //用户名
    UIView *PersonageView=[[UIView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 0, Drive_Wdith, 54)];
    PersonageView.backgroundColor=[UIColor clearColor];
    
    _UserNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 54.0f)];
    [_UserNameLbl setBackgroundColor:[UIColor clearColor]];
    _UserNameLbl.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    _UserNameLbl.textAlignment = NSTextAlignmentLeft;
    _UserNameLbl.textColor=[UIColor blackColor];
    
    _UserNameLbl.text = @"*****";
    
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
    
    //设定title
    UILabel *listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_listTypeView.frame), 44)];
    [listtitleLal setText:@"设定"];
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
    [_listTypeChangeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_listTypeChangeBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_listTypeChangeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_listTypeChangeBtn addTarget:self action:@selector(SaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_listTypeView addSubview:_listTypeChangeBtn];
    
    
    
    
}


#pragma mark -
#pragma mark-------------Tableview delegate--------

/**tableViewCell的高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //房间列表
    if(tableView == self.RoomTableView){
        //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//        if([cell viewWithTag:201]!=nil&&indexPath.row==1)
//        {
//            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
//            return (110+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*1);
//        }
//        else
//        {
            return 110;
//        }
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
        return 11;
    }
    else if(tableView == self.RadarTableView){
        return 1;
    }
    else if(tableView == self.ActivitiesTableView){
        return 1;
    }
    else if(tableView == self.PersonageTableView){
        return 3;
    }
    else if(tableView == self.listTypeTableView){
        return 2;
    }
    else if(tableView == self.organizationTableView){
        return _organizationArray.count;
    }
    else if(tableView == self.PerformanceTableView){
        return 2;
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
    //房间列表显示/刷新设置
    if(tableView == self.listTypeTableView)
    {
        //        static NSString *detailIndicated = @"tableCell";
        //
        //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
        }
        if (indexPath.row==0) {
            if([cell viewWithTag:104]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:@"自动刷新"];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:104];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:104];
                [refreshLbl setText:@"自动刷新"];
            }
            if([cell viewWithTag:105]==nil)
            {
                _refreshImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                [_refreshImgView setImage:[UIImage imageNamed:@"20150207105906"]];
                [_refreshImgView setTag:105];
                [cell addSubview:_refreshImgView];
                
            }
            else
            {
                
                
                [_refreshImgView setImage:[UIImage imageNamed:@"20150207105906"]];
                
            }
            
            
        }
        else if(indexPath.row==1)
        {
            if([cell viewWithTag:106]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:@"查看所有房间"];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:106];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:106];
                [refreshLbl setText:@"查看所有房间"];
            }
            
            if([cell viewWithTag:107]==nil)
            {
                _ShowALLRoomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"20150207105906"]];
                [_ShowALLRoomImgView setTag:107];
                [cell addSubview:_ShowALLRoomImgView];
                
            }
            else
            {
                
                
                [_ShowALLRoomImgView setImage:[UIImage imageNamed:@"20150207105906"]];
                
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
        cell.textLabel.text=[[_organizationArray objectAtIndex:indexPath.row] objectForKey:@"nameSc"];
        cell.textLabel.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    }
    //房间列表
    else if(tableView == self.RoomTableView){
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            NSLog(@"cell.frame.size.height is %f",cell.frame.size.height);
            UIButton * RoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, 100+((CGRectGetWidth(cell.frame)-10-130)/4+8)*1)];
            
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
            UIImageView * RoomImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            [RoomImgView.layer setCornerRadius:CGRectGetHeight([RoomImgView bounds]) / 2];
            [RoomImgView.layer setMasksToBounds:YES];
            [RoomImgView.layer setBorderWidth:2];
            
            [RoomImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [RoomImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            RoomImgView.tag=202;
            [RoomBtn addSubview:RoomImgView];
            
            //房间名称
            UILabel * RoomLbl =[[UILabel alloc]initWithFrame:CGRectMake(72, 17, CGRectGetWidth(cell.frame)-100, 20)];
            [RoomLbl setText:@"*****"];
            [RoomLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [RoomLbl setTextColor:[UIColor whiteColor]];
            [RoomLbl setTextAlignment:NSTextAlignmentLeft];
            RoomLbl.tag=203;
            [RoomBtn addSubview:RoomLbl];
            
            NSString *str=[NSString stringWithFormat:@"%zi",indexPath.row+1];
            kindNum=str.length>3?3:str.length;
            //当前房价人数
            UIView * roomKindNumView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20)];
            //设置按钮是否圆角
            [roomKindNumView.layer setMasksToBounds:YES];
            //圆角像素化
            [roomKindNumView.layer setCornerRadius:8.5];
            [roomKindNumView setBackgroundColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:0.5]];
            roomKindNumView.tag=204;
            [RoomBtn addSubview:roomKindNumView];
            
            UIImageView *numImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
            [numImgView setImage:[UIImage imageNamed:@"20150207105906"]];
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
            for (int i=0; i<10; i++) {
                
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%4==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(72+((CGRectGetWidth(RoomBtn.frame)-130)/4+10)*(i%4),45+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*sNum , (CGRectGetWidth(RoomBtn.frame)-130)/4, (CGRectGetWidth(RoomBtn.frame)-130)/4);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                if (i==2) {
                    [kindBtn setAlpha:0.5];
                }
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKindAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000+i;
                [RoomBtn addSubview:kindBtn];
            }
            
            
        }
        if ([cell viewWithTag:201]!=nil) {
            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
            RoomBtn.frame=CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, 100+((CGRectGetWidth(cell.frame)-10-130)/4+8)*1);
            if(indexPath.row>9)
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:(indexPath.row%10)]];
            }
            else
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            }
            UIImageView * RoomImgView=(UIImageView *)[RoomBtn viewWithTag:202];
            [RoomImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            
            UILabel * RoomLbl=(UILabel *)[RoomBtn viewWithTag:203];
            [RoomLbl setText:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            //            [LoginBtn setAlpha:0.4];
            
            NSString *str=[NSString stringWithFormat:@"%zi",indexPath.row+1];
            kindNum=str.length>3?3:str.length;
            UIView * roomKindNumView=(UIView *)[RoomBtn viewWithTag:204];
            roomKindNumView.frame=CGRectMake(CGRectGetWidth(RoomBtn.frame)-(35+(10*kindNum)+10), 20, 35+(10*kindNum), 20);
            UILabel * KindNumLbl=(UILabel *)[RoomBtn viewWithTag:205];
            KindNumLbl.frame=CGRectMake(30, 0, CGRectGetWidth(roomKindNumView.frame)-35, 20);
            [KindNumLbl setText:str];
            
            for (UIView *view in [RoomBtn subviews])
            {
                //                NSLog(@"view.tag is%d",view.tag);
                
                if ([view isKindOfClass:[UIView class]]&&view.tag>1000)
                {
                    [view removeFromSuperview];
                }
            }
            
            int sNum=0;
            for (int i=0; i<4; i++) {
                
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%4==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(72+((CGRectGetWidth(RoomBtn.frame)-130)/4+10)*(i%4),45+((CGRectGetWidth(RoomBtn.frame)-130)/4+8)*sNum , (CGRectGetWidth(RoomBtn.frame)-130)/4, (CGRectGetWidth(RoomBtn.frame)-130)/4);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                if (i==2) {
                    [kindBtn setAlpha:0.5];
                }
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKindAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000+i;
                [RoomBtn addSubview:kindBtn];
            }
            
        }
        

        
    }
    //个人设置
    else if (tableView==self.PersonageTableView)
    {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //房间图标
            UIImageView * messageImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            //设置按钮为圆形
            [messageImgView.layer setCornerRadius:CGRectGetHeight([messageImgView bounds]) / 2];
            [messageImgView.layer setMasksToBounds:YES];
            [messageImgView.layer setBorderWidth:2];
            
            [messageImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [messageImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            messageImgView.tag=206;
            [cell addSubview:messageImgView];
            
            UILabel * messageLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 27, CGRectGetWidth(cell.frame)-100, 20)];
            [messageLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
//            [messageLbl setAlpha:0.6];
            [messageLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [messageLbl setTextColor:[UIColor blackColor]];
            [messageLbl setTextAlignment:NSTextAlignmentLeft];
            messageLbl.tag=207;
            [cell addSubview:messageLbl];
            
            UILabel * timeLbl =[[UILabel alloc]initWithFrame:CGRectMake(75, 47, CGRectGetWidth(cell.frame)-100, 20)];
            [timeLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
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
            [messageImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            
        }
        
        if([cell viewWithTag:207]!=nil)
        {
            UILabel * messageLbl =(UILabel *)[cell viewWithTag:207];
            [messageLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            
        }
        if([cell viewWithTag:208]!=nil)
        {
            UILabel * timeLbl =(UILabel *)[cell viewWithTag:208];
            [timeLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            
        }
        
        
       cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
    }
    //表现
    else if (tableView==self.PerformanceTableView)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            
            UILabel * roomNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, Drive_Wdith-60, 30)];
            [roomNameLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            [roomNameLbl setTextColor:[UIColor blackColor]];
            [roomNameLbl setFont:[UIFont systemFontOfSize: 18.0]];
            [roomNameLbl setTag:209];
            [cell addSubview:roomNameLbl];
            
            UIView * compareView=[[UIView alloc]initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 50)];
            [compareView setBackgroundColor:[UIColor colorWithRed:0.957 green:0.957 blue:0.922 alpha:1]];
//            [roomNameLbl setTag:210];
            [cell addSubview:compareView];
            LDProgressView *progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 30, Drive_Wdith-60, 25)];
            progressView.progress = 0.40;
            progressView.borderRadius = @0;
            progressView.type = LDProgressSolid;
            progressView.color = [UIColor colorWithRed:0.125 green:0.839 blue:0.992 alpha:1];

            [cell addSubview:progressView];
            
            progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 55, Drive_Wdith-60, 25)];
            progressView.showText = @NO;
            progressView.progress = 0.70;
            progressView.borderRadius = @0;
            progressView.type = LDProgressSolid;
            progressView.color = [UIColor colorWithRed:0.996 green:0.761 blue:0.310 alpha:1];
            [cell addSubview:progressView];
            
        }
        if([cell viewWithTag:209]!=nil)
        {
            UILabel * roomNameLbl =(UILabel *)[cell viewWithTag:209];
            [roomNameLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
        }
    }
    //活动
    else if (tableView==self.ActivitiesTableView)
    {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //活动图标
            UIImageView * messageImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
            //设置按钮为圆形
            [messageImgView.layer setCornerRadius:CGRectGetHeight([messageImgView bounds]) / 2];
            [messageImgView.layer setMasksToBounds:YES];
            [messageImgView.layer setBorderWidth:2];
            
            [messageImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [messageImgView setImage:[UIImage imageNamed:@"20150207105906"]];
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
            UIImageView * messageImgView=(UIImageView *)[cell viewWithTag:211];
            [messageImgView setImage:[UIImage imageNamed:@"20150207105906"]];
            
        }
        
        if([cell viewWithTag:212]!=nil)
        {
            UILabel * messageLbl =(UILabel *)[cell viewWithTag:212];
            [messageLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            
        }
        if([cell viewWithTag:213]!=nil)
        {
            UILabel * timeLbl =(UILabel *)[cell viewWithTag:213];
            [timeLbl setText:[NSString stringWithFormat:@"%zi",indexPath.row]];
            
        }
        
        
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    scrollView.
    
    if(huaHMSegmentedControl==0){

        [self getRequest:@"reportService/api/childrenLocList" delegate:self];
        
    }
    else if(huaHMSegmentedControl==2){
        
        //        myDelegate.headStr = nil;
        //        myDelegate.footStr = nil;
        //        [self.RadarTableView tableViewDidScroll:scrollView];
    }
    else if(huaHMSegmentedControl==2){
        
        [self getRequest:@"reportService/api/notices" delegate:self];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    if(huaHMSegmentedControl==0){
    //
    //        [self.positionDetailsTableView tableViewDidEndDragging:scrollView];
    //    }
    //    else if(huaHMSegmentedControl==2){
    //
    //        [self.allCompanyPositionTableView tableViewDidEndDragging:scrollView];
    //    }
}

#pragma mark ------------scrollview delegate-------
/**列表切换*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 101) {
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        if (scrollView.contentOffset.x!=320.000000) {
            huaHMSegmentedControl = (int)page;
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
#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    NSLog(@"responseString is:%@",responseString);
    //请求机构列表
    if ([tag isEqualToString:@"kindergartenList"]) {
        NSData *responseData = [request responseData];
        _organizationArray=[[responseData mutableObjectFromJSONData] objectForKey:@"allLocationAreasInfo"];
        
        //        NSLog(@"responseStrings %@\n",request);
        NSLog(@"responseStrings %@\n",_organizationArray);
        [self.organizationShowBtn setTitle:[[_organizationArray objectAtIndex:0] objectForKey:@"nameSc"] forState:UIControlStateNormal];
        CGRect  tempRect= _organizationTableView.frame;
        _organizationTableView.frame=CGRectMake(tempRect.origin.x,tempRect.origin.y,tempRect.size.width,(44*_organizationArray.count));
        [_organizationTableView reloadData];
    }
    
    
}
#pragma mark --
#pragma mark --点击事件

/**弹出房间列表显示设置*/
-(void)changeAction:(id)sender
{
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [_listTypeView setHidden:NO];
    [_organizationTableView setHidden:YES];
}

-(void)goToSettingAction:(id)sender
{
    self.settingVc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:self.settingVc  animated:YES];
    self.settingVc .title = @"";
    
    //    [self.navigationController pushViewController:self.settingVc animated:YES];
    //    self.settingVc.title = LOCALIZATION(@"btn_options");
}

/**显示机构选择列表*/
-(void)changeRoomAction:(id)sender
{
    [_PopupSView setHidden:NO];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.0];
    [_listTypeView setHidden:YES];
    [_organizationTableView setHidden:NO];
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
    [self getRequest:@"kindergartenList" delegate:self];
    
    KindlistViewController * kindlist = [[KindlistViewController alloc] init];
    [self.navigationController pushViewController:kindlist animated:YES];
    kindlist.title = @"";
}


#pragma mark - Handle Gestures

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
   [_PopupSView setHidden:YES];
}




/**儿童头像点击事件*/
- (void)ShowKindAction:(id)sender
{
    
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
}


- (void)tabAction:(id)sender
{
    UIButton *tempBtn=(UIButton *)sender;
    int num=tempBtn.tag-214;
    if(num !=1)
    {
        switch (tempBtn.tag) {
            case 214:
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
                break;
            case 217:
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
        }
        if (num==3) {
//             [self getRequest:@"reportService/api/notices" delegate:self];
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

@end

