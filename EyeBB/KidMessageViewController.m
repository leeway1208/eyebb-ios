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
@interface KidMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
//蓝牙设备电量显示
@property (weak, nonatomic) RMDownloadIndicator *closedIndicator;

/**选项列表*/
@property (strong,nonatomic) UITableView * SelectedTView;
@end

@implementation KidMessageViewController
@synthesize major;
@synthesize minor;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(KindergartenListViewControllerLeftAction:)];

    
    [self iv];
    [self lc];
    
    NSLog(@"major(%@) minor(%@)",self.major,self.minor);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    

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
    
    //头像背景容器
    UIView *kidBgView=[[UIView alloc]initWithFrame:CGRectZero];
    kidBgView.frame=CGRectMake(0, 0, Drive_Wdith, Drive_Height/6*2);
    kidBgView.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    [self.view addSubview:kidBgView];
    
    //蓝牙设备电量显示进度条
    [_closedIndicator removeFromSuperview];
    _closedIndicator = nil;

    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake(Drive_Wdith /3, 10, Drive_Wdith /3, Drive_Wdith /3) type:kRMClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    closedIndicator.radiusPercent = 0.45;
    [kidBgView addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    _closedIndicator = closedIndicator;
    //设置downloadedBytes就可以了，这个为电量的百分比
    [_closedIndicator updateWithTotalBytes:100 downloadedBytes:50.0];

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
        
           }
    
    if (indexPath.row==0) {
        
    }else
    {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor colorWithRed:208/255.0 green:44/255.0 blue:55/255.0 alpha:1.0]];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=LOCALIZATION(@"text_battery_life");
            break;
        case 1:
            cell.textLabel.text=LOCALIZATION(@"text_beep");
            break;
        case 2:
            cell.textLabel.text=LOCALIZATION(@"text_get_the_eyebb_device_qr_code");
            break;
        case 3:
            cell.textLabel.text=LOCALIZATION(@"btn_unbind");
            break;
//        case 4:
//            //cell.textLabel.text=LOCALIZATION(@"btn_unbind");
//            break;
        default:
            break;
    }
    
       return cell;
}


@end
