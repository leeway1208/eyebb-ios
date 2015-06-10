//
//  AddGuestViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AddGuestViewController.h"
#import "GuardianKidsViewController.h"//授权儿童列表
#import <Social/Social.h>//share
@interface AddGuestViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    //记录搜索结果数组
    NSArray*_resultArray;
    UITableView*_tableView;
    
    NSString * guestId;
}
/**授权人搜索输入框*/
@property (nonatomic,strong) UITextField *gusetTxt;


/**搜索按钮*/
@property (strong,nonatomic) UIButton * searchBtn;

///**邀请好友按钮*/
//@property (strong,nonatomic) UIButton * shareBtn;

@property (strong,nonatomic) GuardianKidsViewController *guardianKids;
/**是否是查询*/
@property BOOL isSearch;
@end

@implementation AddGuestViewController
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    [self iv];
    [self lc];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (_guardianKids!=nil) {
        _guardianKids=nil;
        
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
    //实例化数组
    _resultArray=[[NSArray alloc]init];
    _isSearch=NO;
}

/**
 *加载控件
 */
-(void)lc
{
    self.gusetTxt=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, Drive_Wdith-10, 40)];
    self.gusetTxt.placeholder=LOCALIZATION(@"text_user_name");
    UIImageView* imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_name"]];
    imgV.frame=CGRectMake(0, 0, 19, 21) ;
    self.gusetTxt.leftView=imgV;//设置输入框内左边的图标
    self.gusetTxt.clearButtonMode=UITextFieldViewModeWhileEditing;//右侧删除按钮
    self.gusetTxt.leftViewMode=UITextFieldViewModeAlways;
    self.gusetTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    self.gusetTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    self.gusetTxt.delegate=self;//设置委托
    //    self.gusetTxt.tag=101;
    [self.view addSubview:self.gusetTxt];
    
    UILabel *lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(4, 45, Drive_Wdith-8, 1)];
    lineLbl.backgroundColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    [self.view addSubview:lineLbl];
    
    self.searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith/4 , 60 ,Drive_Wdith / 2, 40)];
    //设置按显示文字
    [self.searchBtn setTitle:LOCALIZATION(@"btn_search_new_guest") forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [self.searchBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
    //设置按钮是否圆角
    [self.searchBtn.layer setMasksToBounds:YES];
    //圆角像素化
    [self.searchBtn.layer setCornerRadius:4.0];
    //设置按钮响应事件
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    
    
//    self.shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(0 , 120 ,Drive_Wdith, 46)];
//    //设置按显示文字
////    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@ \n (%@%@)",LOCALIZATION(@"text_search_guest_null"),LOCALIZATION(@"text_click_to_share"),self.gusetTxt.text]  forState:UIControlStateNormal];
//    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //设置按钮背景颜色
//    [self.shareBtn setBackgroundColor:[UIColor clearColor]];
//    //设置按钮是否圆角
//   
//    //设置按钮响应事件
//    [self.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.shareBtn];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,105,Drive_Wdith,Drive_Height-141) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
    
    _tableView.backgroundColor=[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    _tableView.sectionIndexColor = [UIColor blueColor];
    //隐藏table自带的cell下划线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.sectionHeaderHeight=108.0f;
    [self.view addSubview:_tableView];
    
    
    
}

/**
 *	@brief	设置隐藏键盘
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.gusetTxt) {
        [theTextField resignFirstResponder];
    }
    return YES;
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.gusetTxt resignFirstResponder];

    
}


#pragma mark --
#pragma mark - table view



// set cells height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


//set the number of cells in one section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=0;
    if (_isSearch==YES&&_resultArray.count<1) {
        _isSearch=NO;
        num=1;
    }
    else if (_resultArray.count>0)
    {
        num=_resultArray.count;
    }
    else
    {
        num=0;
    }
    return num;
}


// set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    //临时装置信息
    
    NSDictionary *tempDictionary=[NSDictionary dictionary];
    if(_resultArray.count>0)
    {
    tempDictionary=[[_resultArray objectAtIndex:indexPath.row]copy];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        
        
        UIView * gusetView=[[UIView alloc]initWithFrame:CGRectMake(10, 4, CGRectGetWidth(cell.frame)-20, 52)];
        
        [gusetView setBackgroundColor:[UIColor whiteColor]];
        //设置按钮是否圆角bu
        [gusetView.layer setMasksToBounds:YES];
        //圆角像素化
        [gusetView.layer setCornerRadius:4.0];
        gusetView.tag=101;
        [cell addSubview:gusetView];
        
        //授权人名字
        UILabel * nameLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 16, CGRectGetWidth(cell.bounds)-150, 20)];
        [nameLbl setText:[[tempDictionary objectForKey:@"name"]copy]];
        [nameLbl setFont:[UIFont systemFontOfSize: 18.0]];
        [nameLbl setTextColor:[UIColor blackColor]];
        [nameLbl setTextAlignment:NSTextAlignmentLeft];
        nameLbl.tag=102;
        [gusetView addSubview:nameLbl];
        
        //授权人电话按钮
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.bounds)-145, 10, 120, 32)];
        if(_resultArray.count>0)
        {
        //设置按显示文字
        [phoneBtn setTitle:[[tempDictionary objectForKey:@"phoneNumber"]copy] forState:UIControlStateNormal];
        }
        [phoneBtn.titleLabel setFont:[UIFont fontWithName:@"sans-serif-light" size:15.0]];
        [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 34, 0, 0)];
        //设置按钮背景颜色
        [phoneBtn setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
        //设置按钮响应事件
//        [phoneBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
        //设置按钮是否圆角
        [phoneBtn.layer setMasksToBounds:YES];
        //圆角像素化
        [phoneBtn.layer setCornerRadius:4.0];
        phoneBtn.tag=103;
        [gusetView addSubview:phoneBtn];
        
        UIImageView *phoneImg=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 32, 32)];
        if(_resultArray.count>0)
        {
        [phoneImg setImage:[UIImage imageNamed:@"login_phone"]];
        }
        [phoneBtn addSubview:phoneImg];
        
        //邀请朋友按钮底边线
        UILabel *lineLbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 58, CGRectGetWidth(cell.bounds), 1)];
        lineLbl.backgroundColor=[UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];
        lineLbl.tag=104;
        [cell addSubview:lineLbl];
    }
    cell.backgroundColor=[UIColor clearColor];
    UIView * gusetView=(UIView *)[cell viewWithTag:101];
     UILabel *lineLbl=(UILabel *)[cell viewWithTag:104];
    //判断服务器是否有值，如果没有就是没有找到授权人，显示邀请信息
    if(_resultArray.count>0)
    {
        gusetView.hidden=NO;
    lineLbl.hidden=YES;
   
    UILabel * nameLbl =(UILabel *)[gusetView viewWithTag:102];
     UIButton * phoneBtn =(UIButton *)[gusetView viewWithTag:103];
    
    [nameLbl setText:[[tempDictionary objectForKey:@"name"]copy]];
    [phoneBtn setTitle:[[tempDictionary objectForKey:@"phoneNumber"]copy] forState:UIControlStateNormal];
    tempDictionary=nil;
    }
    else
    {
        lineLbl.hidden=NO;
        gusetView.hidden=YES;
        cell.textLabel.numberOfLines=2;
        cell.textLabel.text=[NSString stringWithFormat:@"%@ \n %@%@)",LOCALIZATION(@"text_search_guest_null"),LOCALIZATION(@"text_click_to_share"),self.gusetTxt.text];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    //设置选中背景颜色为无色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_resultArray.count<1)
    {
        NSArray *activityItems;
        
        //    if (self.sharingImage != nil) {
        //        activityItems = @[self.sharingText, self.sharingImage];
        //    } else {
        activityItems = @[LOCALIZATION(@"text_search_guset_activity_share_msg")];
        //    }
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:nil];
        
        [self presentViewController:activityController
                           animated:YES completion:nil];
    }
    else
    {
//    if (_guardianKids==nil) {
//        _guardianKids=[[GuardianKidsViewController alloc]init];
//        
//    }
//    self.guardianKids._childrenArray=[[_authorizedArray objectAtIndex:(guardianbtn.tag-105)] objectForKey:@"chilrenByGuardian"];
    //self.guardianKids.SelectedchildrenArray=[_resultArray objectAtIndex:indexPath.row];
   // self.guardianKids.guestId=[[_resultArray objectAtIndex:indexPath.row] objectForKey:@"guardianId"];
    //self.guardianKids.guestOrMaster = 1;

        NSLog(@"_resultArray is %@",[_resultArray objectAtIndex:indexPath.row]);
        
        NSMutableDictionary * tempDictionary=[NSMutableDictionary dictionary];
        [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[_resultArray objectAtIndex:indexPath.row] objectForKey:@"guardianId"]] forKey:@"guestId"];
        
        guestId =  [NSString stringWithFormat:@"%@",[[_resultArray objectAtIndex:indexPath.row] objectForKey:@"guardianId"]];
        
        
        [self postRequest:GUEST_CHILDREN RequestDictionary:tempDictionary delegate:nil];
    //[self.navigationController pushViewController:_guardianKids animated:YES];
    }
}

#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
 
    NSLog(@"resSEARCH_GUEST %@",responseString);
    if ([tag isEqualToString:SEARCH_GUEST]) {

            NSData *responseData = [request responseData];
            if(_resultArray!=nil)
            {
                _resultArray=nil;
                _resultArray=[NSMutableArray array];
            }

        
        _resultArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        
            
            responseData=nil;
        _isSearch=YES;
       
            [_tableView reloadData];
        
    }else if([tag isEqualToString:GUEST_CHILDREN]){
        NSString *responseString = [request responseString];
         NSData *responseData = [request responseData];
        NSLog(@"resGUEST_CHILDREN %@",[[responseData mutableObjectFromJSONData] objectForKey:@"childrenQuota"]);
        
        if (_guardianKids==nil) {
            _guardianKids=[[GuardianKidsViewController alloc]init];
        
        }
        NSArray * childAy = [[responseData mutableObjectFromJSONData] objectForKey:@"childrenQuota"];
        NSMutableArray *selectChildAy =[NSMutableArray new];
        
        for (int i = 0; i < childAy.count ; i ++ ) {
            NSDictionary *temodc = [childAy objectAtIndex:i];
            
            if ([[NSString stringWithFormat:@"%@",[temodc objectForKey:@"withAccess"] ] isEqualToString:@"1"]) {
                
                [selectChildAy addObject:[temodc objectForKey:@"child" ]];
                
                
            }
            
        }
        
        NSLog(@"selectChildAy -> %@",selectChildAy);
     
        self.guardianKids._childrenArray= [childAy copy];

        self.guardianKids.SelectedchildrenArray=[selectChildAy mutableCopy];
        self.guardianKids.guestId= guestId;
        self.guardianKids.guestOrMaster = 1;
        
        
        [self.navigationController pushViewController:_guardianKids animated:YES];
    }
        
    
}


#pragma mark --
#pragma mark --点击事件
//查询
-(void)searchAction:(id)sender
{
    [self.gusetTxt resignFirstResponder];
    NSMutableDictionary * tempDictionary=[NSMutableDictionary dictionary];
    [tempDictionary setObject:self.gusetTxt.text forKey:@"guestName"];
    [self getRequest:SEARCH_GUEST delegate:self RequestDictionary:[tempDictionary copy]];
    tempDictionary=nil;
}
@end
