//
//  MainViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-24.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "MainViewController.h"
#import "HMSegmentedControl.h"
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
    
}

/**
 *加载控件
 */
-(void)lc
{
    
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"职位详情", @"公司详情",@"所有招聘",@"所有招聘2"]];
    
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
    //    __block int shuaHMSegmentedControl=huaHMSegmentedControl;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        //        huaHMSegmentedControl = index;
        if(index!=1)
        {
            huaHMSegmentedControl = index;
        }
        else
        {
            
        }
        [weakSelf1.self.MainInfoScrollView scrollRectToVisible:CGRectMake(Drive_Wdith * index, 0, Drive_Wdith, Drive_Height-44) animated:YES];
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
    UIView *titelView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    titelView.backgroundColor=[UIColor colorWithRed:0.835 green:0.835 blue:0.835 alpha:1];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, Drive_Wdith-200, 44.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    labelTitle.text = @"室内定位";
    
    [titelView addSubview:labelTitle];
    
    //室内定位条件刷选
    UIButton * listSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-54, 0, 44, 44)];
    
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
    UIView *RoomShowView =[[UIView alloc]initWithFrame:CGRectMake(0, 44, Drive_Wdith, 44)];
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
    
    
    
    
    
    //初始化房间信息
    _RoomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame)-88)];
    
    _RoomTableView.dataSource = self;
    _RoomTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    //隐藏table自带的cell下划线
    _RoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        return 1;
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
    if(tableView == self.RoomTableView){
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            NSLog(@"cell.frame.size.height is %f",cell.frame.size.height);
            UIButton * RoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, cell.frame.size.height-10)];
            
            //设置按钮背景颜色
            [RoomBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
            //设置按钮响应事件
            [RoomBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
            //设置按钮是否圆角
            [RoomBtn.layer setMasksToBounds:YES];
            //圆角像素化
            [RoomBtn.layer setCornerRadius:4.0];
            RoomBtn.tag=107;
            [cell addSubview:RoomBtn];
            
            
            
        }
        
        
    }
    else if(tableView == self.listTypeTableView)
    {
        //        static NSString *detailIndicated = @"tableCell";
        //
        //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
            
            
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
    if(huaHMSegmentedControl==0){
        
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 101) {
        //   NSLog(@"segmentedControl3.selectedSegmentIndex is :%d",self.segmentedControl.selectedSegmentIndex);
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        huaHMSegmentedControl = page;
        //     NSLog(@"456=%d",huaHMSegmentedControl);
        
        //     NSLog(@"page is :%d,scrollView.contentOffset.x is %f, pageWidth is %f",page,scrollView.contentOffset.x , pageWidth);
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}
#pragma mark --
#pragma mark --点击事件

-(void)changeAction:(id)sender
{
    [_PopupSView setHidden:NO];
}

-(void)changeRoomAction:(id)sender
{
    
}

-(void)SaveAction:(id)sender
{
    [_PopupSView setHidden:YES];
}



@end
