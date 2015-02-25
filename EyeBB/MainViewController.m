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
    listSetBtn.tag=105;
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
    RoomShowBtn.tag=106;
    [RoomShowView addSubview:RoomShowBtn];
    
    [_MainInfoScrollView addSubview:RoomShowView];

    
    
    
    
    //初始化房间信息
    _RoomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame)-88)];
    
     _RoomTableView.dataSource = self;
    _RoomTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    _RoomTableView.tag=102;
    //隐藏table自带的cell下划线
    _RoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_MainInfoScrollView addSubview:_RoomTableView];
    
    
    //初始化雷达
    _RadarTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    
    _RadarTableView.dataSource = self;
    _RadarTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    _RadarTableView.tag=103;
    [_MainInfoScrollView addSubview:_RadarTableView];
    
    
    //初始化简报
    _NewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*2, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    
    _NewsTableView.dataSource = self;
    _NewsTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    _NewsTableView.tag=104;
    [_MainInfoScrollView addSubview:_NewsTableView];

    //初始化个人信息
    _PersonageTableView= [[UITableView alloc]initWithFrame:CGRectMake(Drive_Wdith*3, 0, CGRectGetWidth(_MainInfoScrollView.frame), CGRectGetHeight(_MainInfoScrollView.frame))];
    _PersonageTableView.dataSource = self;
    _PersonageTableView.delegate = self;
    //    [self.positionDetailsTableView setBounces:NO];
    _PersonageTableView.tag=104;
    [_MainInfoScrollView addSubview:_PersonageTableView];
    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    
    
    
}


#pragma mark -
#pragma mark-------------Tableview delegate--------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //公司信息
    if(tableView == self.self.RoomTableView){
        
        return 160;
    }
    
    if(tableView == self.self.RadarTableView){
        
        return 70;
    }
    
    else if(tableView == self.NewsTableView){
    
                return 110;
        
        
    }
    else if(tableView == self.PersonageTableView){
        return 70;
    }
    
    
    
    return 140;
    
    
    
    
}
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
    else{
        return  0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    int row=indexPath.row;
    NSString *CellIdentifier;
    if(tableView == self.RoomTableView){
        static NSString *detailIndicated = @"tableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
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
//
//    //公司产品
//    else if(tableView == self.comShowTableView){
//        
//        
//        NSDate *date;
//        if ([self.productArray count]>0) {
//            entproductDictionary=[self.productArray objectAtIndex:indexPath.row];
//            date = [NSDate dateWithTimeIntervalSince1970:([[entproductDictionary objectForKey:@"publishDate"] doubleValue] / 1000)];
//        }
//        
//        
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
//        
//        NSDate *now = [NSDate date];
//        NSString *dateNow = [dateFormatter stringFromDate:now];
//        if ([[dateFormatter stringFromDate:date] isEqualToString:dateNow]) {
//            [dateFormatter setDateFormat:@"今天"];
//        }
//        else {
//            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//        }
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            
//            
//            UIView  *cellview=[[UIView alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.width-20, 150)];
//            [cellview.layer setBorderWidth:1.0];   //边框宽度
//            cellview.tag=100;
//            cellview.backgroundColor=[UIColor whiteColor];
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            
//            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.725, 0.725, 0.725, 1 });
//            [cellview.layer setBorderColor:colorref];//边框颜色
//            [cell addSubview:cellview];
//            
//            
//            UILabel * productNamelabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 20, cell.frame.size.width-110, 15)];
//            productNamelabel.font=[UIFont fontWithName:@"Helvetica" size:14];
//            productNamelabel.backgroundColor=[UIColor clearColor];
//            productNamelabel.tag=10100;
//            productNamelabel.textColor=[UIColor blackColor];
//            productNamelabel.text = [entproductDictionary objectForKey:@"title"]==nil?@"":[entproductDictionary objectForKey:@"title"];
//            [cell addSubview:productNamelabel];
//            
//            
//            UILabel * Datelabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-98, 20, 100, 15)];
//            Datelabel.font=[UIFont fontWithName:@"Helvetica" size:14];
//            Datelabel.backgroundColor=[UIColor clearColor];
//            Datelabel.tag=20100;
//            Datelabel.textColor=[UIColor blackColor];
//            Datelabel.text = [dateFormatter stringFromDate:date];
//            [cell addSubview:Datelabel];
//            
//            
//            
//            UIImageView *productImg=[[UIImageView alloc]initWithFrame:CGRectMake(11, 45, cell.frame.size.width-22, 80)];
//            
//            NSString* pathOne =[NSString stringWithFormat: @"%@",[[entproductDictionary objectForKey:@"titleImg"]objectForKey:@"medium"]];
//            NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//            NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
//            productImg.image  = [UIImage imageWithData:data];
//            productImg.tag=30100;
//            [cell addSubview: productImg];
//            
//            
//            
//            
//            
//            UILabel * contentlabel=[[UILabel alloc]init];
//            contentlabel.font=[UIFont fontWithName:@"Helvetica" size:14];
//            contentlabel.backgroundColor=[UIColor clearColor];
//            contentlabel.tag=40100;
//            contentlabel.lineBreakMode = UILineBreakModeTailTruncation;
//            contentlabel.numberOfLines = 2;
//            contentlabel.textColor=[UIColor colorWithRed:0.710 green:0.710 blue:0.710 alpha:1];
//            contentlabel.frame=CGRectMake(14, 122, cell.frame.size.width-28, 35);
//            contentlabel.text = [entproductDictionary objectForKey:@"desc"];
//            [cell addSubview:contentlabel];
//            
//            
//        }
//        
//        
//        
//        if ([self.productArray count]>0) {
//            UILabel * productNamelabel=(UILabel *)[cell viewWithTag:10100];
//            productNamelabel.text = [entproductDictionary objectForKey:@"title"]==nil?@"":[entproductDictionary objectForKey:@"title"];;
//            
//            
//            
//            
//            UILabel * Datelabel=(UILabel *)[cell viewWithTag:20100];
//            Datelabel.text = [dateFormatter stringFromDate:date];
//            
//            
//            UIImageView * productImg=(UIImageView *)[cell viewWithTag:30100];
//            NSString* pathOne =[NSString stringWithFormat: @"%@",[[entproductDictionary objectForKey:@"titleImg"]objectForKey:@"medium"]];
//            NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//            NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
//            productImg.image  = [UIImage imageWithData:data];
//            
//            
//            
//            UILabel * contentlabel=(UILabel *)[cell viewWithTag:40100];
//            contentlabel.text = [entproductDictionary objectForKey:@"desc"];
//            
//        }
//        
//        cell.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
//        cell.accessoryType=UITableViewCellAccessoryNone;
//        
//        
//        
//        //        }
//        //        else{
//        //            studylabel.text = @"无";
//        //
//        
//        
//        
//        //        }
//        
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        
//    }
//    
//    //公司评价
//    else if(tableView == self.comCommentTableView){
//        
//        
//        if ([self.CommentArray count]>0) {
//            entCommentDictionary=[self.CommentArray objectAtIndex:indexPath.row];
//        }
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            
//            
//            UIView  *cellview=[[UIView alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width-20, 65)];
//            [cellview.layer setBorderWidth:1.0];   //边框宽度
//            cellview.tag=1100;
//            cellview.backgroundColor=[UIColor whiteColor];
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            
//            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.725, 0.725, 0.725, 1 });
//            [cellview.layer setBorderColor:colorref];//边框颜色
//            [cell addSubview:cellview];
//            
//            UIImageView *productImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 54, 54)];
//            
//            NSString* pathOne =[NSString stringWithFormat: @"%@",[[entCommentDictionary objectForKey:@"headPortrait"]objectForKey:@"medium"]];
//            NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//            NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
//            //实名
//            if([[entCommentDictionary objectForKey:@"isNickName"]intValue]==0){
//                //有头像
//                if([entCommentDictionary objectForKey:@"headPortrait"]!=nil){
//                    productImg.image  = [UIImage imageWithData:data];
//                    UILabel *photoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, productImg.frame.size.width, productImg.frame.size.height-5)];
//                    photoLab.tag = 900001;
//                    photoLab.textAlignment = UITextAlignmentCenter;
//                    photoLab.textColor = [UIColor whiteColor];
//                    photoLab.backgroundColor = [UIColor clearColor];
//                    [productImg addSubview:photoLab];
//                }
//                //没头像
//                else{
//                    productImg.image = [UIImage imageNamed:@""];
//                    //男gender ＝ 1 女gender = 0
//                    if([[entCommentDictionary objectForKey:@"gender"]intValue]==1){
//                        productImg.backgroundColor =[UIColor colorWithRed:0.314 green:0.561 blue:0.800 alpha:1];
//                        
//                    }else{
//                        productImg.backgroundColor =[UIColor colorWithRed:0.996 green:0.455 blue:0.678 alpha:1];
//                    }
//                    
//                    if([entCommentDictionary objectForKey:@"userName"]!=nil){
//                        NSString *userName =[entCommentDictionary objectForKey:@"userName"];
//                        
//                        if(userName.length >=2){
//                            //最后一个字
//                            NSString *lastName = [userName substringFromIndex:[userName length]-1];
//                            //倒数第二个字
//                            NSString *lastTwoName = [userName substringToIndex:[userName length]-1];
//                            NSString *lastTwoNamea  = [lastTwoName substringFromIndex:[lastTwoName length]-1];
//                            NSLog(@"lastTwoNamea,lastName %@%@",lastTwoNamea,lastName);
//                            
//                            
//                            UILabel *photoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, productImg.frame.size.width, productImg.frame.size.height-5)];
//                            photoLab.tag = 900001;
//                            photoLab.textAlignment = UITextAlignmentCenter;
//                            photoLab.font = [UIFont systemFontOfSize:16];
//                            photoLab.textColor = [UIColor whiteColor];
//                            photoLab.backgroundColor = [UIColor clearColor];
//                            photoLab.text = [NSString stringWithFormat:@"%@ %@",lastTwoNamea,lastName];
//                            [productImg addSubview:photoLab];
//                            
//                            
//                        }
//                        
//                    }
//                }
//            }
//            //匿名评论
//            else{
//                
//                //男gender ＝ 1 女gender = 0
//                productImg.backgroundColor =[UIColor colorWithRed:0.133 green:0.404 blue:0.333 alpha:1];
//                
//                UILabel *photoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, productImg.frame.size.width, productImg.frame.size.height-5)];
//                photoLab.textAlignment = UITextAlignmentCenter;
//                photoLab.font = [UIFont systemFontOfSize:16];
//                photoLab.tag = 900001;
//                photoLab.textColor = [UIColor whiteColor];
//                photoLab.backgroundColor = [UIColor clearColor];
//                photoLab.text = @"匿 名";
//                [productImg addSubview:photoLab];
//                
//            }
//            
//            
//            
//            productImg.tag=110100;
//            [cell addSubview: productImg];
//            
//            
//            UILabel * contentlabel=[[UILabel alloc]init];
//            contentlabel.font=[UIFont fontWithName:@"Helvetica" size:14];
//            contentlabel.backgroundColor=[UIColor clearColor];
//            contentlabel.tag=120100;
//            contentlabel.lineBreakMode = UILineBreakModeTailTruncation;
//            contentlabel.numberOfLines = 2;
//            contentlabel.textColor=[UIColor colorWithRed:0.710 green:0.710 blue:0.710 alpha:1];
//            
//            contentlabel.frame=CGRectMake(75, 36, cell.frame.size.width-85, 35);
//            contentlabel.text = [entCommentDictionary objectForKey:@"commContent"]==nil?@"":[entCommentDictionary objectForKey:@"commContent"];
//            [cell addSubview:contentlabel];
//            
//            NSArray * tempArray=[[NSArray alloc]init];
//            if ([entCommentDictionary objectForKey:@"tagList"]!=nil) {
//                tempArray=[entCommentDictionary objectForKey:@"tagList"];
//            }
//            
//            if ([tempArray count]>0) {
//                //评价标签
//                
//                NSMutableDictionary *CommentTagDictionary=nil;
//                CommentTagDictionary=[tempArray objectAtIndex:0];
//                UILabel *welfareLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(76, 10, 90,25)];
//                //                welfareLabelOne.text = [self.walfatesArray objectAtIndex:0];
//                welfareLabelOne.tag =500001;
//                welfareLabelOne.text = [CommentTagDictionary objectForKey:@"tagName"];
//                welfareLabelOne.font=[UIFont fontWithName:@"Helvetica" size:14];
//                welfareLabelOne.textColor=[UIColor colorWithRed:0.302 green:0.408 blue:0.600 alpha:1];
//                welfareLabelOne.textAlignment = UITextAlignmentCenter;
//                welfareLabelOne.textColor = [UIColor colorWithRed:0.086 green:0.306 blue:0.553 alpha:1];
//                welfareLabelOne.layer.borderColor = [UIColor colorWithRed:0.902 green:0.933 blue:0.949 alpha:1].CGColor ;
//                welfareLabelOne.backgroundColor = [UIColor clearColor];
//                welfareLabelOne.layer.borderWidth = 1;
//                welfareLabelOne.textAlignment = UITextAlignmentCenter;
//                welfareLabelOne.layer.cornerRadius = 5;
//                
//                [cell addSubview:welfareLabelOne];
//                
//            }
//            
//            if ([tempArray count]>1) {
//                
//                NSMutableDictionary *CommentTagDictionary=nil;
//                CommentTagDictionary=[tempArray objectAtIndex:1];
//                UILabel *welfareLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(172, 10, 90,25)];
//                //                welfareLabelTwo.text = [self.walfatesArray objectAtIndex:1];
//                welfareLabelTwo.tag =500002;
//                welfareLabelTwo.text = [CommentTagDictionary objectForKey:@"tagName"];
//                welfareLabelTwo.font=[UIFont fontWithName:@"Helvetica" size:14];
//                
//                welfareLabelTwo.textColor = [UIColor colorWithRed:0.086 green:0.306 blue:0.553 alpha:1];
//                welfareLabelTwo.layer.borderColor = [UIColor colorWithRed:0.902 green:0.933 blue:0.949 alpha:1].CGColor ;
//                welfareLabelTwo.backgroundColor = [UIColor clearColor];
//                welfareLabelTwo.layer.borderWidth = 1;
//                welfareLabelTwo.textAlignment = UITextAlignmentCenter;
//                welfareLabelTwo.layer.cornerRadius = 5;
//                [welfareLabelTwo.layer setMasksToBounds:YES];
//                
//                [cell addSubview:welfareLabelTwo];
//                
//            }
//            
//        }
//        
//        cell.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
//        
//        UIImageView * productImg=(UIImageView *)[cell viewWithTag:110100];
//        
//        NSString* pathOne =[NSString stringWithFormat: @"%@",[[entCommentDictionary objectForKey:@"headPortrait"]objectForKey:@"medium"]];
//        NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//        NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
//        //实名
//        if([[entCommentDictionary objectForKey:@"isNickName"]intValue]==0){
//            //有头像
//            if([entCommentDictionary objectForKey:@"headPortrait"]!=nil){
//                productImg.image  = [UIImage imageWithData:data];
//                UILabel *labelTemp = (UILabel *)[cell viewWithTag:900001];
//                labelTemp.text = @"";
//            }
//            //没头像
//            else{
//                
//                //男gender ＝ 1 女gender = 0
//                if([[entCommentDictionary objectForKey:@"gender"]intValue]==1){
//                    productImg.backgroundColor =[UIColor colorWithRed:0.314 green:0.561 blue:0.800 alpha:1];
//                    
//                }else{
//                    productImg.backgroundColor =[UIColor colorWithRed:0.996 green:0.455 blue:0.678 alpha:1];
//                }
//                
//                if([entCommentDictionary objectForKey:@"userName"]!=nil){
//                    NSString *userName =[entCommentDictionary objectForKey:@"userName"];
//                    
//                    if(userName.length >=2){
//                        //最后一个字
//                        NSString *lastName = [userName substringFromIndex:[userName length]-1];
//                        //倒数第二个字
//                        NSString *lastTwoName = [userName substringToIndex:[userName length]-1];
//                        NSString *lastTwoNamea  = [lastTwoName substringFromIndex:[lastTwoName length]-1];
//                        NSLog(@"lastTwoNamea,lastName %@%@",lastTwoNamea,lastName);
//                        
//                        UILabel *labelTemp = (UILabel *)[cell viewWithTag:900001];
//                        
//                        labelTemp.text = [NSString stringWithFormat:@"%@ %@",lastTwoNamea,lastName];
//                        
//                    }
//                    
//                }
//            }
//        }
//        //匿名评论
//        else{
//            
//            //男gender ＝ 1 女gender = 0
//            
//            productImg.backgroundColor =[UIColor colorWithRed:0.133 green:0.404 blue:0.333 alpha:1];
//            
//            
//            productImg.image = [UIImage imageNamed:@""];
//            UILabel *labelTemp = (UILabel *)[cell viewWithTag:900001];
//            labelTemp.text = @"匿 名";
//            
//        }
//        
//        
//        
//        UILabel * contentlabel=(UILabel *)[cell viewWithTag:120100];
//        contentlabel.text = [entCommentDictionary objectForKey:@"commContent"]==nil?@"":[entCommentDictionary objectForKey:@"commContent"];
//        
//        NSArray * tempArray=[[NSArray alloc]init];
//        if ([entCommentDictionary objectForKey:@"tagList"]!=nil) {
//            tempArray=[entCommentDictionary objectForKey:@"tagList"];
//        }
//        
//        if ([tempArray count]>0) {
//            //评价标签
//            
//            NSMutableDictionary *CommentTagDictionary=nil;
//            CommentTagDictionary=[tempArray objectAtIndex:0];
//            
//            UILabel *temp = (UILabel *)[cell viewWithTag:500001];
//            temp.text = [CommentTagDictionary objectForKey:@"tagName"];
//            
//        }
//        
//        if ([tempArray count]>1) {
//            
//            NSMutableDictionary *CommentTagDictionary=nil;
//            CommentTagDictionary=[tempArray objectAtIndex:1];
//            
//            UILabel *temp = (UILabel *)[cell viewWithTag:500002];
//            temp.text = [CommentTagDictionary objectForKey:@"tagName"];
//            
//        }
//        cell.accessoryType=UITableViewCellAccessoryNone;
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
//    //公司招聘
//    else if(tableView == self.comRecruitmentTableView){
//        
//        
//        comRecruitmentDictionary=[self.otherMorePositionArray objectAtIndex:indexPath.row];
//        NSString * degree= ([comRecruitmentDictionary objectForKey:@"degree"]==nil?@"":[comRecruitmentDictionary objectForKey:@"degree"]);
//        NSString * postAddress= ([comRecruitmentDictionary objectForKey:@"areaName"]==nil?@"":[comRecruitmentDictionary objectForKey:@"areaName"]);
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([[comRecruitmentDictionary objectForKey:@"publishDate"] doubleValue] / 1000)];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
//        
//        NSDate *now = [NSDate date];
//        NSString *dateNow = [dateFormatter stringFromDate:now];
//        
//        if ([[dateFormatter stringFromDate:date] isEqualToString:dateNow]) {
//            [dateFormatter setDateFormat:@"今天"];
//        }
//        else {
//            [dateFormatter setDateFormat:@"MM-dd"];
//        }
//        NSArray * templabelArray=[comRecruitmentDictionary objectForKey:@"tagNames"];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            
//            UILabel * entLabel=[[UILabel alloc]init];
//            entLabel.frame = CGRectMake(10, 5,  225, 20);
//            entLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
//            entLabel.text=([comRecruitmentDictionary objectForKey:@"postAliases"]==nil?@"":[comRecruitmentDictionary objectForKey:@"postAliases"]);
//            entLabel.tag=101;
//            entLabel.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
//            entLabel.backgroundColor=[UIColor clearColor];
//            entLabel.textAlignment = UITextAlignmentLeft;
//            [cell addSubview:entLabel];
//            
//            //地区学历
//            UILabel * areaAndAcademicLabel=[[UILabel alloc]init];
//            areaAndAcademicLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
//            areaAndAcademicLabel.frame = CGRectMake(10, 25, 120, 20);
//            areaAndAcademicLabel.tag=102;
//            if (![degree isEqualToString:@""]&&![postAddress isEqualToString:@""]) {
//                areaAndAcademicLabel.text= [NSString stringWithFormat:@"%@/%@",degree,postAddress];
//            }
//            else if ([degree isEqualToString:@""]&&![postAddress isEqualToString:@""])
//            {
//                areaAndAcademicLabel.text= postAddress;
//            }
//            else if (![degree isEqualToString:@""]&&[postAddress isEqualToString:@""])
//            {
//                areaAndAcademicLabel.text= degree;
//            }
//            areaAndAcademicLabel.textColor=[UIColor colorWithRed:0.400 green:0.400 blue:0.400 alpha:1];
//            areaAndAcademicLabel.backgroundColor=[UIColor clearColor];
//            areaAndAcademicLabel.textAlignment = UITextAlignmentLeft;
//            [cell addSubview:areaAndAcademicLabel];
//            
//            
//            
//            //发布时间
//            UILabel * timeLabel=[[UILabel alloc]init];
//            //    entLabel.lineBreakMode = UILineBreakModeWordWrap;
//            //    entLabel.numberOfLines = 1;
//            timeLabel.tag=103;
//            timeLabel.frame = CGRectMake(270, 5,  40, 20);
//            timeLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
//            timeLabel.text=[dateFormatter stringFromDate:date];
//            
//            timeLabel.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
//            timeLabel.backgroundColor=[UIColor clearColor];
//            timeLabel.textAlignment = UITextAlignmentRight;
//            [cell addSubview:timeLabel];
//            
//            //工资
//            UILabel * salaryLabel=[[UILabel alloc]init];
//            salaryLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
//            //    postLabel.numberOfLines = 1;
//            salaryLabel.tag=104;
//            salaryLabel.frame = CGRectMake(230, 25, 80, 20);
//            salaryLabel.text=([comRecruitmentDictionary objectForKey:@"salary"]==nil?@"":[comRecruitmentDictionary objectForKey:@"salary"]);
//            salaryLabel.textColor=[UIColor colorWithRed:0.820 green:0.275 blue:0.275 alpha:1];
//            salaryLabel.backgroundColor=[UIColor clearColor];
//            salaryLabel.textAlignment = UITextAlignmentRight;
//            [cell addSubview:salaryLabel];
//            
//            
//            //福利标签
//            if([templabelArray count] >0){
//                UILabel *welfareLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(235, 45, 65,20)];
//                welfareLabelOne.text = [templabelArray objectAtIndex:0];
//                welfareLabelOne.font=[UIFont fontWithName:@"Helvetica" size:14];
//                welfareLabelOne.textColor=[UIColor colorWithRed:0.302 green:0.408 blue:0.600 alpha:1];
//                welfareLabelOne.textAlignment = UITextAlignmentCenter;
//                welfareLabelOne.layer.borderColor = [UIColor colorWithRed:0.827 green:0.890 blue:0.910 alpha:1].CGColor;
//                welfareLabelOne.backgroundColor =[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
//                welfareLabelOne.layer.borderWidth = 1;
//                welfareLabelOne.tag=105;
//                [cell addSubview:welfareLabelOne];
//                UIImageView *welimage = [[UIImageView alloc]initWithFrame:CGRectMake(298, 45, 15, 20)];
//                welimage.image = [UIImage imageNamed:@"label"];
//                welimage.tag=106;
//                [cell addSubview:welimage];
//            }
//            
//            
//            if([templabelArray count] >1){
//                
//                UILabel *welfareLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(152, 45, 65,20)];
//                welfareLabelTwo.text = [templabelArray objectAtIndex:1];
//                welfareLabelTwo.font=[UIFont fontWithName:@"Helvetica" size:14];
//                welfareLabelTwo.textColor=[UIColor colorWithRed:0.302 green:0.408 blue:0.600 alpha:1];
//                welfareLabelTwo.backgroundColor =[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
//                welfareLabelTwo.textAlignment = UITextAlignmentCenter;
//                welfareLabelTwo.layer.borderColor = [UIColor colorWithRed:0.827 green:0.890 blue:0.910 alpha:1].CGColor;;
//                welfareLabelTwo.layer.borderWidth = 1;
//                welfareLabelTwo.tag=107;
//                [cell addSubview:welfareLabelTwo];
//                
//                UIImageView *welimage = [[UIImageView alloc]initWithFrame:CGRectMake(215, 45, 15, 20)];
//                welimage.image = [UIImage imageNamed:@"label"];
//                welimage.tag=108;
//                [cell addSubview:welimage];
//            }
//            
//            if([templabelArray count] >2){
//                UILabel *welfareLabelThree = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, 65,20)];
//                welfareLabelThree.text = [templabelArray objectAtIndex:2];
//                welfareLabelThree.font=[UIFont fontWithName:@"Helvetica" size:14];
//                welfareLabelThree.textColor=[UIColor colorWithRed:0.302 green:0.408 blue:0.600 alpha:1];
//                welfareLabelThree.backgroundColor =[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
//                welfareLabelThree.textAlignment = UITextAlignmentCenter;
//                welfareLabelThree.layer.borderColor = [UIColor colorWithRed:0.827 green:0.890 blue:0.910 alpha:1].CGColor;;
//                welfareLabelThree.layer.borderWidth = 1;
//                welfareLabelThree.tag=109;
//                [cell addSubview:welfareLabelThree];
//                
//                UIImageView *welimage = [[UIImageView alloc]initWithFrame:CGRectMake(133, 45, 15, 20)];
//                welimage.image = [UIImage imageNamed:@"label"];
//                welimage.tag=110;
//                [cell addSubview:welimage];
//            }
//        }
//        
//        
//        cell.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
//        
//        
//        
//        //职位名称
//        UILabel * entLabel=(UILabel *)[cell viewWithTag:101];
//        entLabel.text=([comRecruitmentDictionary objectForKey:@"postAliases"]==nil?@"":[comRecruitmentDictionary objectForKey:@"postAliases"]);
//        
//        //地区学历
//        UILabel * areaAndAcademicLabel=(UILabel *)[cell viewWithTag:102];
//        
//        if (![degree isEqualToString:@""]&&![postAddress isEqualToString:@""]) {
//            areaAndAcademicLabel.text= [NSString stringWithFormat:@"%@/%@",degree,postAddress];
//        }
//        else if ([degree isEqualToString:@""]&&![postAddress isEqualToString:@""])
//        {
//            areaAndAcademicLabel.text= postAddress;
//        }
//        else if (![degree isEqualToString:@""]&&[postAddress isEqualToString:@""])
//        {
//            areaAndAcademicLabel.text= degree;
//        }
//        
//        
//        
//        //发布时间
//        UILabel * timeLabel=(UILabel *)[cell viewWithTag:103];
//        timeLabel.text=[dateFormatter stringFromDate:date];
//        
//        //工资
//        UILabel * salaryLabel=(UILabel *)[cell viewWithTag:104];
//        salaryLabel.text=([comRecruitmentDictionary objectForKey:@"salary"]==nil?@"":[comRecruitmentDictionary objectForKey:@"salary"]);
//        
//        
//        UILabel *welfareLabelOne =(UILabel *)[cell viewWithTag:105];
//        UIImageView *welimageOne =(UIImageView *)[cell viewWithTag:106];
//        
//        UILabel *welfareLabelTwo =(UILabel *)[cell viewWithTag:107];
//        UIImageView *welimageTwo =(UIImageView *)[cell viewWithTag:108];
//        
//        UILabel *welfareLabelThree =(UILabel *)[cell viewWithTag:109];
//        UIImageView *welimageThree =(UIImageView *)[cell viewWithTag:110];
//        
//        //福利标签
//        if([templabelArray count]<1){
//            welfareLabelOne.hidden=YES;
//            welimageOne.hidden=YES;
//            
//            welfareLabelTwo.hidden=YES;
//            welimageTwo.hidden=YES;
//            
//            welfareLabelThree.hidden=YES;
//            welimageThree.hidden=YES;
//        }
//        
//        if([templabelArray count]>0&&[templabelArray count]<2){
//            welfareLabelOne.text = [templabelArray objectAtIndex:0];
//            welimageOne.image = [UIImage imageNamed:@"label"];
//            welfareLabelOne.hidden=NO;
//            welimageOne.hidden=NO;
//            welfareLabelTwo.hidden=YES;
//            welimageTwo.hidden=YES;
//            welfareLabelThree.hidden=YES;
//            welimageThree.hidden=YES;
//            
//        }
//        
//        
//        if([templabelArray count] >1&&[templabelArray count]<3){
//            welfareLabelOne.text = [templabelArray objectAtIndex:0];
//            welimageOne.image = [UIImage imageNamed:@"label"];
//            welfareLabelTwo.text = [templabelArray objectAtIndex:1];
//            welimageTwo.image = [UIImage imageNamed:@"label"];
//            welfareLabelOne.hidden=NO;
//            welimageOne.hidden=NO;
//            welfareLabelTwo.hidden=NO;
//            welimageTwo.hidden=NO;
//            welfareLabelThree.hidden=YES;
//            welimageThree.hidden=YES;
//        }
//        
//        if([templabelArray count] >2){
//            welfareLabelOne.text = [templabelArray objectAtIndex:0];
//            welimageOne.image = [UIImage imageNamed:@"label"];
//            welfareLabelTwo.text = [templabelArray objectAtIndex:1];
//            welimageTwo.image = [UIImage imageNamed:@"label"];
//            welfareLabelThree.text = [templabelArray objectAtIndex:2];
//            welimageThree.image = [UIImage imageNamed:@"label"];
//            welfareLabelOne.hidden=NO;
//            welimageOne.hidden=NO;
//            welfareLabelTwo.hidden=NO;
//            welimageTwo.hidden=NO;
//            welfareLabelThree.hidden=NO;
//            welimageThree.hidden=NO;
//            
//        }
//        
//        
//        cell.accessoryType = UITableViewCellEditingStyleNone;
//        
//    }
//    
//    
//    
//    
//    
//    
    
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
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
    
}

-(void)changeRoomAction:(id)sender
{
    
}


@end
