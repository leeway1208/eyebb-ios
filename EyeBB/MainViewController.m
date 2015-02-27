//
//  MainViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-24.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "MainViewController.h"
#import "HMSegmentedControl.h"
#import "SettingsViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /**滑动HMSegmentedControl*/
    int huaHMSegmentedControl;
}
/**选项卡内容容器*/
@property (strong, nonatomic) UIScrollView *MainInfoScrollView;
/**实现选项卡功能的第三方控件*/
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
//房间信息
@property (strong, nonatomic) UITableView *RoomTableView;
//雷达
@property (strong, nonatomic) UITableView *RadarTableView;
//简报
@property (strong, nonatomic) UITableView *NewsTableView;
//个人
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


@property (strong,nonatomic) NSArray *colorArray;

/**option button*/
@property (strong,nonatomic) UIButton * settingButton;
@property (nonatomic,strong) SettingsViewController *settingVc;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self iv];
    [self lc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
}

/**
 *加载控件
 */
-(void)lc
{
    
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"室内定位", @"雷达",@"简报",@"用户"]];
    
    self.segmentedControl = segmentedControl3;
    [self.segmentedControl setBackgroundColor:[UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1]];
    [self.segmentedControl setTextColor:[UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1]];
    
    //选中后的颜色
    [self.segmentedControl setSelectedTextColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //是否下标
    [self.segmentedControl setSelectionIndicatorHeight:0.0f];
    
    //    [self.segmentedControl setSelectionIndicatorColor:[UIColor colorWithRed:0.227 green:0.408 blue:0.616 alpha:1]];
    //    [self.segmentedControl setselect]
    
    [self.segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmentedControl setFrame:CGRectMake(0, 20, Drive_Wdith, 44)];
    
    __weak typeof(self) weakSelf1 = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if(index!=1)
        {
            huaHMSegmentedControl = (int)index;
             [weakSelf1.self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * index, 0, Drive_Wdith, Drive_Height-44) animated:YES];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"系统提示"
                                        message:@"IOS暂时不支持此功能，敬请期待"
                                       delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            [self.segmentedControl setSelectedSegmentIndex:huaHMSegmentedControl];
             [weakSelf1.self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * huaHMSegmentedControl, 0, Drive_Wdith, Drive_Height-44) animated:YES];
        }
       
    }];
    
    [self.view addSubview:self.segmentedControl];
    
    //设置scrollView
    _MainInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Drive_Wdith, Drive_Height-44)];
    
    [_MainInfoScrollView setDelegate:self];
    _MainInfoScrollView.contentSize = CGSizeMake(Drive_Wdith*4, _MainInfoScrollView.frame.size.height);
    [_MainInfoScrollView setTag:101];
    // 滚动时,是否显示水平滚动条
    _MainInfoScrollView.showsHorizontalScrollIndicator = NO;
    // 滚动时,是否显示垂直滚动条
    _MainInfoScrollView.showsVerticalScrollIndicator = NO;
    //设置滑动不出界反弹
    //    _MainInfoScrollView.bounces = NO;
    _MainInfoScrollView.pagingEnabled = YES;
    [self.view addSubview:_MainInfoScrollView];
    
    //室内定位TitelView
    UIView *titelView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 54)];
    titelView.backgroundColor=[UIColor colorWithRed:0.835 green:0.835 blue:0.835 alpha:1];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 44.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    labelTitle.text = @"室内定位";
    
    [titelView addSubview:labelTitle];
    
    //室内定位条件刷选
    UIButton * listSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-54, 5, 44, 44)];
    
    //设置按显示图片
    [listSetBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [listSetBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [listSetBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [listSetBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    listSetBtn.tag=102;
    [titelView addSubview:listSetBtn];
    
    [_MainInfoScrollView addSubview:titelView];
    
    //房间显示选择View
    UIView *RoomShowView =[[UIView alloc]initWithFrame:CGRectMake(0, 54, Drive_Wdith, 44)];
    RoomShowView.backgroundColor=[UIColor clearColor];
    //室内定位显示选择
    UIButton * RoomShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    //设置按显示titel
    [RoomShowBtn setTitle:@"****" forState:UIControlStateNormal];
    [RoomShowBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]  forState:UIControlStateNormal];
    //设置按钮背景颜色
    [RoomShowBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [RoomShowBtn addTarget:self action:@selector(changeRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [RoomShowBtn.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    RoomShowBtn.tag=103;
    [RoomShowView addSubview:RoomShowBtn];
    [_MainInfoScrollView addSubview:RoomShowView];
    
    //室内定位显示选择
    UIButton * childrenListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_MainInfoScrollView.frame)-40, CGRectGetWidth(_MainInfoScrollView.frame), 40)];
    
    //设置按显示titel
    [childrenListBtn setTitle:@"儿童列表" forState:UIControlStateNormal];
    [childrenListBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    //设置按钮背景颜色
    [childrenListBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮响应事件
    [childrenListBtn addTarget:self action:@selector(childrenListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_MainInfoScrollView addSubview:childrenListBtn];

    
    
    //初始化房间信息
    _RoomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 98, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame)-138)];
    
    _RoomTableView.dataSource = self;
    _RoomTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    //隐藏table自带的cell下划线
    _RoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _RoomTableView.backgroundColor=[UIColor whiteColor];
    [_MainInfoScrollView addSubview:_RoomTableView];
    
    
    //初始化雷达
    _RadarTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    
    _RadarTableView.dataSource = self;
    _RadarTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_RadarTableView];
    
    
    //初始化简报
    _NewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*2, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    
    _NewsTableView.dataSource = self;
    _NewsTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_NewsTableView];
    
    //初始化个人信息
    _PersonageTableView= [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    _PersonageTableView.dataSource = self;
    _PersonageTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    [_MainInfoScrollView addSubview:_PersonageTableView];
    UIButton * settingButton = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-54, 5, 44, 44)];
    //设置按显示图片
    [settingButton setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [settingButton setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [settingButton addTarget:self action:@selector(goToSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮是否圆角
    [settingButton.layer setMasksToBounds:NO];
    //圆角像素化
    //    [listSetBtn.layer setCornerRadius:4.0];
    settingButton.tag=104;
    [_PersonageTableView addSubview:settingButton];

    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    _listTypeView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-88, Drive_Wdith-10, 176)];
    [_listTypeView setBackgroundColor:[UIColor whiteColor] ];
    //设置按钮是否圆角
    [_listTypeView.layer setMasksToBounds:YES];
    //圆角像素化
    [_listTypeView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_listTypeView];
    
    //设定titel
    UILabel *listTitelLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_listTypeView.frame), 44)];
    [listTitelLal setText:@"设定"];
    [listTitelLal setTextColor:[UIColor blackColor]];
    [listTitelLal setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [listTitelLal setTextAlignment:NSTextAlignmentCenter];
    [listTitelLal setBackgroundColor:[UIColor clearColor]];
    [_listTypeView addSubview:listTitelLal];
    
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
    //    //公司信息
    if(tableView == self.RoomTableView){
        
        return 160;
    }
    
    if(tableView == self.RadarTableView){
        
        return 70;
    }
    
    else if(tableView == self.NewsTableView){
        
        return 110;
        
        
    }
    else if(tableView == self.PersonageTableView){
        return 70;
    }
    
    
    
    return 44;
    
    
    
    
}

/**table需要显示的行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == self.RoomTableView){
        return 11;
    }
    else if(tableView == self.RadarTableView){
        return 1;
    }
    else if(tableView == self.NewsTableView){
        return 1;
    }
    else if(tableView == self.PersonageTableView){
        return 1;
    }
    else if(tableView == self.listTypeTableView){
        return 2;
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
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width-60, 44)];
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
                _refreshImgView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-50, 7, 30, 30)];
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
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width-60, 44)];
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
                _ShowALLRoomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-50, 7, 30, 30)];
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    //房间列表
    else if(tableView == self.RoomTableView){
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            NSLog(@"cell.frame.size.height is %f",cell.frame.size.height);
            UIButton * RoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, 150)];
            
            //设置按钮背景颜色
            [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            //设置按钮响应事件
            [RoomBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
            //设置按钮是否圆角
            [RoomBtn.layer setMasksToBounds:YES];
            //圆角像素化
            [RoomBtn.layer setCornerRadius:4.0];
            RoomBtn.tag=201;
            [cell addSubview:RoomBtn];
            
            
            
        }
        if ([cell viewWithTag:201]!=nil) {
            UIButton * RoomBtn=(UIButton *)[cell viewWithTag:201];
            if(indexPath.row>9)
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:(indexPath.row%10)]];
            }
            else
            {
                [RoomBtn setBackgroundColor:[_colorArray objectAtIndex:indexPath.row]];
            }
            
            
        }
        
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"ssss=%d",indexPath.row);
    //    if (tableView==self.comShowTableView) {
    //        self.webSite=[[WebsiteViewController alloc]init];
    //        self.webSite.urlStr=[[self.productArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    //        self.webSite.isPush=1;
    //
    //        [self.navigationController pushViewController:self.webSite animated:YES];
    //    }
    //    else if(tableView == self.comRecruitmentTableView){
    //
    //        NSLog(@"ddd=%@",self.otherMorePositionArray);
    //
    //        NSDictionary * informationDictionary= nil;
    //        informationDictionary=[self.otherMorePositionArray objectAtIndex:indexPath.row];
    //
    //        self.postDetail =[[CPositionDetailsViewController alloc]init];
    //        self.postDetail.postId=[[informationDictionary objectForKey:@"postId"] longValue];
    //        self.postDetail.endId=[[informationDictionary objectForKey:@"entId"] longValue];
    //        self.postDetail.downDictionay=self.PostListDictionary;
    //        self.postDetail.curentNum =indexPath.row;
    //        self.postDetail.callType=3;
    //        [self.navigationController pushViewController:self.postDetail animated:YES];
    //    }
    
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
//        NSLog(@"scrollView.contentOffset.x is %f",scrollView.contentOffset.x);
//        [scrollView setContentOffset:CGPointMake(320,0) animated:YES];
        //        [self.RoomTableView tableViewDidScroll:scrollView];

    }
    else if(huaHMSegmentedControl==2){
        
        //        myDelegate.headStr = nil;
        //        myDelegate.footStr = nil;
        //        [self.RadarTableView tableViewDidScroll:scrollView];
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
        //   NSLog(@"segmentedControl3.selectedSegmentIndex is :%d",self.segmentedControl.selectedSegmentIndex);
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
//        NSLog(@"scrollView.contentOffset.x is %f",scrollView.contentOffset.x);
//        NSLog(@"scrollView.frame.size.width %f",scrollView.frame.size.width);
        if (scrollView.contentOffset.x!=320.000000) {
            huaHMSegmentedControl = (int)page;
            [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
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
            [self.segmentedControl setSelectedSegmentIndex:huaHMSegmentedControl animated:YES];
        }
        //     NSLog(@"456=%d",huaHMSegmentedControl);
        
        //     NSLog(@"page is :%d,scrollView.contentOffset.x is %f, pageWidth is %f",page,scrollView.contentOffset.x , pageWidth);
        
    }
}
#pragma mark --
#pragma mark --点击事件

/**弹出房间列表显示设置*/
-(void)changeAction:(id)sender
{
    [_PopupSView setHidden:NO];
}

-(void)goToSettingAction:(id)sender
{
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
//    reg.title = @"";
}

/**显示机构选择列表*/
-(void)changeRoomAction:(id)sender
{
    
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

}



@end
