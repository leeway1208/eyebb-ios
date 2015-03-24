//
//  AccreditViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/19.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AccreditViewController.h"
//添加或改变授权儿童
#import "GuardianKidsViewController.h"
//添加授权人
#import "AddGuestViewController.h"
@interface AccreditViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
/**内容列表*/
@property (nonatomic,strong) UITableView *AccredTableView;
/**已授权的亲友数组*/
@property (nonatomic,strong)  NSArray *authorizedArray;
/**被哪些亲友授权数组*/
@property (nonatomic,strong)  NSArray *authorizationArray;
//添加或改变授权儿童
@property (nonatomic,strong)  GuardianKidsViewController * guardianKids;
//添加授权人
@property (nonatomic,strong)  AddGuestViewController * addguset;
/**右按钮*/
@property(nonatomic, retain) UIBarButtonItem *rightBtnItem;
@end

@implementation AccreditViewController
@synthesize  rightBtnItem;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self iv];
    [self lc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getRequest:AUTH_FIND_GUESTS delegate:self RequestDictionary:nil];
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
    self.authorizedArray=[NSArray array];
    self.authorizationArray=[NSArray array];
}

/**
 *加载控件
 */
-(void)lc
{
    _AccredTableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _AccredTableView.delegate=self;
    _AccredTableView.dataSource=self;
    [self.view addSubview:_AccredTableView];
}

/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-80, 6, 60, 32)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:LOCALIZATION(@"btn_add") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button addTarget:self action:@selector(addgusetAction) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
        
    }
    return rightBtnItem;
}
#pragma mark --
#pragma mark - table view



// set cells height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row=0;
    
    switch (indexPath.row) {
        case 0:
            row=_authorizedArray.count%2>0?_authorizedArray.count/2+1:_authorizedArray.count/2;
            break;
        case 1:
            row=_authorizationArray.count%2>0?_authorizationArray.count/2+1:_authorizationArray.count/2;
           

            break;
               default:
            break;
    }
    if (row<1) {
        row=1;
    }
    return (60+65*row);
}


//set the number of cells in one section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}


// set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    NSInteger cellHeight=0;
    int sNum=0;
    //标签行数
    int Listrow=0;

    NSString *str;
   

    
    switch (indexPath.row) {
        case 0:
            Listrow=_authorizedArray.count%2>0?_authorizedArray.count/2+1:_authorizedArray.count/2;
            str=[NSString stringWithFormat:@"%d",_authorizedArray.count];

            break;
        case 1:
            Listrow=_authorizationArray.count%2>0?_authorizationArray.count/2+1:_authorizationArray.count/2;
            str=[NSString stringWithFormat:@"%d",_authorizationArray.count];

            break;
        default:
            break;
    }
    //授权人位数
    NSInteger gusetNum=str.length>3?3:str.length;
    if (Listrow<1) {
        Listrow=1;
    }
    //临时装置信息
    
    NSArray *tempArray=[[NSArray alloc]init];
    switch (indexPath.row) {
        case 0:
            tempArray=[_authorizedArray copy];
           
            break;
        case 1:
            tempArray=[_authorizationArray copy];
           
            break;
        default:
            break;
    }

    
    cellHeight=(60+65*Listrow);
    
   
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
           
            
            UIView * bindView=[[UIView alloc]initWithFrame:CGRectMake(2.5, 20, CGRectGetWidth(cell.frame)-5, cellHeight-20)];
            
            [bindView setBackgroundColor:[UIColor colorWithRed:0.467 green:0.843 blue:0.639 alpha:1]];
            //设置按钮是否圆角bu
            [bindView.layer setMasksToBounds:YES];
            //圆角像素化
            [bindView.layer setCornerRadius:4.0];
            bindView.tag=101;
            [cell addSubview:bindView];
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_authorized_to_others")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            bindLbl.tag=102;
            [bindView addSubview:bindLbl];
            switch (indexPath.row) {
                case 0:
                    [bindLbl setText:LOCALIZATION(@"text_authorized_to_others")];
                    break;
                case 1:
                    [bindLbl setText:LOCALIZATION(@"text_authorization_from_others")];
                    break;
                default:
                    break;
            }
            
            //授权人数
            UIView * gusetNumView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(bindView.frame)-(35+(10*gusetNum)+10), 2, 35+(10*gusetNum), 20)];
            //设置按钮是否圆角
            [gusetNumView.layer setMasksToBounds:YES];
            //圆角像素化
            [gusetNumView.layer setCornerRadius:8.5];
            [gusetNumView setBackgroundColor:[UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:0.5]];
            gusetNumView.tag=103;
            [bindView addSubview:gusetNumView];
            
            UIImageView *numImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
            [numImgView setImage:[UIImage imageNamed:@"actbar_profileOn"]];
            //            [numImgView setAlpha:0.5];
            [gusetNumView addSubview:numImgView];
            
            
            //授权人数量
            UILabel * gusetNumLbl =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, CGRectGetWidth(gusetNumView.frame)-35, 20)];
            [gusetNumLbl setText:str];
            [gusetNumLbl setAlpha:0.6];
            [gusetNumLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [gusetNumLbl setTextColor:[UIColor whiteColor]];
            [gusetNumLbl setTextAlignment:NSTextAlignmentLeft];
            gusetNumLbl.tag=104;
            [gusetNumView addSubview:gusetNumLbl];
            
            for (int i=0; i<tempArray.count; i++) {
                
                //监护人按钮
                UIButton * guardianBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%2==0) {
                    sNum++;
                }
                guardianBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-25)/2+5)*(i%2),35+65*sNum , (CGRectGetWidth(bindView.frame)-25)/2, 50);
guardianBtn.backgroundColor=[UIColor whiteColor];
                //设置按钮是否圆角bu
                [guardianBtn.layer setMasksToBounds:YES];
                //圆角像素化
                [guardianBtn.layer setCornerRadius:4.0];
                //设置按钮响应事件
                [guardianBtn addTarget:self action:@selector(ShowGuardianBtnMessageAction:) forControlEvents:UIControlEventTouchUpInside];
                guardianBtn.tag=105+i;
                [bindView addSubview:guardianBtn];
                
                UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
                [logoImgView setImage:[UIImage imageNamed:@"20150207105906"]];
                [guardianBtn addSubview:logoImgView];
                
                UILabel * nameLbl =[[UILabel alloc]initWithFrame:CGRectMake(40, 0, CGRectGetWidth(guardianBtn.frame)-55, 24.5)];
                [nameLbl setText:[[[tempArray objectAtIndex:i] objectForKey:@"guardian"] objectForKey:@"name"]];

                [nameLbl setFont:[UIFont systemFontOfSize: 15.0]];
                [nameLbl setTextColor:[UIColor blackColor]];
                [guardianBtn addSubview:nameLbl];
                
                
                UILabel * phonenNumLbl =[[UILabel alloc]initWithFrame:CGRectMake(40, 25, CGRectGetWidth(guardianBtn.frame)-55, 25)];
                [phonenNumLbl setText:[[[tempArray objectAtIndex:i] objectForKey:@"guardian"] objectForKey:@"phoneNumber"]];
                
                [phonenNumLbl setFont:[UIFont systemFontOfSize: 15.0]];
                [phonenNumLbl setTextColor:[UIColor blackColor]];
                [guardianBtn addSubview:phonenNumLbl];
                
                
            }
            sNum=0;

            
        }
    UIView * bindView=(UIView *)[cell viewWithTag:101];
    bindView.frame=CGRectMake(2.5, 20, CGRectGetWidth(cell.frame)-5, cellHeight-20);
     UILabel * bindLbl =(UILabel *)[cell viewWithTag:102];
    switch (indexPath.row) {
        case 0:

            [bindLbl setText:LOCALIZATION(@"text_authorized_to_others")];
            break;
        case 1:

            [bindLbl setText:LOCALIZATION(@"text_authorization_from_others")];
            
            break;
        default:
            break;
    }
    switch (indexPath.row) {
        case 0:
            [bindView setBackgroundColor:[UIColor colorWithRed:0.467 green:0.843 blue:0.639 alpha:1]];
            [bindLbl setText:LOCALIZATION(@"text_authorized_to_others")];
            break;
        case 1:
            [bindView setBackgroundColor:[UIColor colorWithRed:0.282 green:0.800 blue:0.925 alpha:1]];
            [bindLbl setText:LOCALIZATION(@"text_authorization_from_others")];

            break;
                default:
            break;
    }
    UIView * gusetNumView=(UIView *)[bindView viewWithTag:103];
    gusetNumView.frame=CGRectMake(CGRectGetWidth(bindView.frame)-(35+(10*gusetNum)+10), 2, 35+(10*gusetNum), 20);
    UILabel * gusetNumLbl=(UILabel *)[bindView viewWithTag:104];
    gusetNumLbl.frame=CGRectMake(30, 0, CGRectGetWidth(gusetNumView.frame)-35, 20);
    [gusetNumLbl setText:str];

    for (UIView *view in [bindView subviews])
    {
        if ([view isKindOfClass:[UIView class]]&&view.tag>104)
        {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<tempArray.count; i++) {
        
        //监护人按钮
        UIButton * guardianBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        if (i>0&&i%2==0) {
            sNum++;
        }
        guardianBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-25)/2+5)*(i%2),35+65*sNum , (CGRectGetWidth(bindView.frame)-25)/2, 50);
        guardianBtn.backgroundColor=[UIColor whiteColor];
        //设置按钮是否圆角bu
        [guardianBtn.layer setMasksToBounds:YES];
        //圆角像素化
        [guardianBtn.layer setCornerRadius:4.0];
        //设置按钮响应事件
        [guardianBtn addTarget:self action:@selector(ShowGuardianBtnMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        guardianBtn.tag=105+i;
        [bindView addSubview:guardianBtn];
        
        UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
        [logoImgView setImage:[UIImage imageNamed:@"20150207105906"]];
        [guardianBtn addSubview:logoImgView];
        
        UILabel * nameLbl =[[UILabel alloc]initWithFrame:CGRectMake(40, 0, CGRectGetWidth(guardianBtn.frame)-55, 24.5)];
        [nameLbl setText:[[[tempArray objectAtIndex:i] objectForKey:@"guardian"] objectForKey:@"name"]];
        
        [nameLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [nameLbl setTextColor:[UIColor blackColor]];
        [guardianBtn addSubview:nameLbl];
        
        
        UILabel * phonenNumLbl =[[UILabel alloc]initWithFrame:CGRectMake(40, 25, CGRectGetWidth(guardianBtn.frame)-55, 25)];
        [phonenNumLbl setText:[[[tempArray objectAtIndex:i] objectForKey:@"guardian"] objectForKey:@"phoneNumber"]];
        
        [phonenNumLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [phonenNumLbl setTextColor:[UIColor blackColor]];
        [guardianBtn addSubview:phonenNumLbl];
        
        
    }
    sNum=0;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}
#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    //请求房间列表
    if ([tag isEqualToString:AUTH_FIND_GUESTS]) {
        NSData *responseData = [request responseData];
        if(_authorizedArray!=nil&&_authorizedArray.count>0)
        {
            _authorizedArray=nil;
            _authorizedArray=[NSArray array];
            //            [_organizationArray removeAllObjects];
            
        }
        if(_authorizationArray!=nil&&_authorizationArray.count>0)
        {
            _authorizationArray=nil;
            _authorizationArray=[NSArray array];
            
        }

        self.authorizedArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"guests"] copy];
        self.authorizationArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"masters"] copy];
        responseData=nil;
        [self.AccredTableView reloadData];
    }
    
}
#pragma mark --
#pragma mark --点击事件
//显示
-(void)ShowGuardianBtnMessageAction:(id)sender
{
    UIButton *guardianbtn=(UIButton *)sender;
    NSArray *tempArray=[[_authorizedArray objectAtIndex:(guardianbtn.tag-105)] objectForKey:@"chilrenByGuardian"];
    if (self.guardianKids==nil) {
        self.guardianKids=[[GuardianKidsViewController alloc]init];
        
    }
    self.guardianKids.SelectedchildrenArray=[tempArray copy];
    [self.navigationController pushViewController:self.guardianKids animated:YES];
    tempArray=nil;

    
//       [{"guardian":{"guardianId":54,"accName":"99999999","name":"9999","phoneNumber":"99999999","type":"P"},"chilrenByGuardian":[{"childId":19,"name":"C2014112801","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_C20141128_20150312041842.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":18,"name":"c20141127","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000003_20150312041748.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null}]},{"guardian":{"guardianId":17,"accName":"12341234","name":"qqq","phoneNumber":"12341234","type":"P"},"chilrenByGuardian":[{"childId":6,"name":"軒仔","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000015_20150312042828.png","dateOfBirth":"06/06/2013","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":18,"name":"c20141127","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000003_20150312041748.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":5,"name":"Haibo","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000007_20150312042305.png","dateOfBirth":"03/10/2011","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}},{"childId":2,"name":"Betty","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000002_20150312041644.png","dateOfBirth":"01/02/2010","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}},{"childId":3,"name":"Wanwan","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000012_20150312042716.png","dateOfBirth":"02/06/2010","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}},{"childId":19,"name":"C2014112801","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_C20141128_20150312041842.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null}]},{"guardian":{"guardianId":7,"accName":"terry","name":"terry","phoneNumber":"93706395","type":"P"},"chilrenByGuardian":[{"childId":9,"name":"français","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000005_20150312042214.png","dateOfBirth":"15/07/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":19,"name":"C2014112801","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_C20141128_20150312041842.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":18,"name":"c20141127","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000003_20150312041748.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":20,"name":"C2014112802","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_2014112802_20150312041907.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null}]},{"guardian":{"guardianId":18,"accName":"11223344","name":"test111410","phoneNumber":"11223344","type":"P"},"chilrenByGuardian":[{"childId":20,"name":"C2014112802","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_2014112802_20150312041907.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":2,"name":"Betty","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000002_20150312041644.png","dateOfBirth":"01/02/2010","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}},{"childId":18,"name":"c20141127","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000003_20150312041748.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":10,"name":"Español","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000004_20150312042040.png","dateOfBirth":"06/05/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}},{"childId":19,"name":"C2014112801","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_C20141128_20150312041842.png","dateOfBirth":"27/11/2014","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":null},{"childId":1,"name":"Peter","icon":"http://test.eyebb.com/twinly/share/images/childrenIcons/area_2/2_c201000010_20150312042547.png","dateOfBirth":"01/01/2010","kindergarten":{"areaId":2,"name":"Funful Kindergarten","nameTc":"方方樂趣幼稚園","nameSc":"方方乐趣幼稚园","icon":"http://test.eyebb.com/twinly/share/images/locationAreas/icons/2_area_icon_20150312041239.png"},"cls":{"classId":1,"name":"Class 1"}}]}]
}

-(void)addgusetAction
{
    if (self.addguset==nil) {
        self.addguset=[[AddGuestViewController alloc]init];
        
    }

    [self.navigationController pushViewController:self.addguset animated:YES];
}
@end
