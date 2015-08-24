//
//  KidslistViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


// setting view children list
#import "KidslistViewController.h"
#import "ChildInformationMatchingViewController.h"
#import "SettingsViewController.h"
#import "KidMessageViewController.h"
#import "DBImageView.h"//图片加载



@interface KidslistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int index;
}
//-------------------视图控件--------------------
/**兒童列表*/
@property (strong,nonatomic) UITableView * KindlistTView;

/**Binding 绑定数据源*/
@property (strong,nonatomic) NSMutableArray * BindingArray;

/**unBinding 未绑定数据源*/
@property (strong,nonatomic) NSMutableArray * unBindingArray;

/**granted 已授权数据源*/
@property (strong,nonatomic) NSMutableArray * grantedArray;
/**数据源数组*/
@property (nonatomic,strong) NSMutableArray*childrenArray;

/**重排后的儿童*/
@property (nonatomic,strong) NSMutableDictionary * SelectChildrenDictionary;
//@property (strong,nonatomic)  AddGuardianViewController *addGuardian;
@property (strong,nonatomic)  KidMessageViewController * km;
/* get local child informaton */
@property (nonatomic,strong) NSMutableArray *localChildInfo;
//-------------------视图变量--------------------
@property NSInteger cellHeight;
//
///**图片本地存储地址*/
//@property (nonatomic,strong)NSString * documentsDirectoryPath;



/* next view */
@property (nonatomic,strong) ChildInformationMatchingViewController * childView;
@end

@implementation KidslistViewController
@synthesize  childrenArray;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"navi_btn_back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [newBackButton setBackgroundImage:[UIImage
                                       imageNamed: @"navi_btn_back.png"]forState:UIControlStateSelected  barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = newBackButton;

    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    // Do any additional setup after loading the view.
    [self getRequest:GET_CHILDREN_INFO_LIST delegate:self RequestDictionary:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"btn_add") style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    [self iv];
    [self lc];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (_childView != nil) {
        _childView = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated{
    //       [[NSNotificationCenter defaultCenter] removeObserver:self name:UNBIND_DEVICE_BROADCAST object:nil];
}

#pragma mark --
#pragma mark - 初始化页面元素

/**
 *初始化参数
 */
-(void)iv
{
    
    _localChildInfo = [self allChildren];
    
    self.BindingArray=[[NSMutableArray alloc]init];
    
    self.unBindingArray=[[NSMutableArray alloc]init];
    
    self.grantedArray=[[NSMutableArray alloc]init];
    _SelectChildrenDictionary=[NSMutableDictionary dictionary];
    _cellHeight=44;
    
    //     _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    index=0;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIcon) name:CHANGE_ICON_BROADCAST object:nil ];
    
    
    
    
    
    
    
}

/**
 *加载控件
 */
-(void)lc
{
    
    _KindlistTView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height - 80)];
    _KindlistTView.dataSource = self;
    _KindlistTView.delegate = self;
    //设置table是否可以滑动
    _KindlistTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    _KindlistTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_KindlistTView];
    
}


#pragma mark - broadcast
- (void) changeIcon{
    
    [_KindlistTView reloadData];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_ICON_BROADCAST object:nil];
    
}


#pragma mark - btn action

-(void)backAction{
        for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
        {
            if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[SettingsViewController class]]){
    
    
                [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
            }
        }
}



#pragma mark --
#pragma mark - 表单设置


// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    int row=0;
    
    switch (indexPath.row) {
        case 0:
            row=_BindingArray.count%5>0?_BindingArray.count/5+1:_BindingArray.count/5;
            break;
        case 1:
            row=_unBindingArray.count%5>0?_unBindingArray.count/5+1:_unBindingArray.count/5;
            break;
        case 2:
            row=_grantedArray.count%5>0?_grantedArray.count/5+1:_grantedArray.count/5;
            break;
        default:
            break;
    }
    if (row<1) {
        row=1;
    }
    NSLog(@"_cellHeight is %ld row is %zi",(long)_cellHeight,indexPath.row);
    return (35+((CGRectGetWidth(cell.frame)-100)/5+10)*row);
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    int num=3;
    //    if (section==0) {
    //        num=4;
    //    }
    //    else
    //    {
    //        num=2;
    //    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    int sNum=0;
    //儿童头像行数
    int kidsLogoListrow=0;
    switch (indexPath.row) {
        case 0:
            kidsLogoListrow=_BindingArray.count%5>0?_BindingArray.count/5+1:_BindingArray.count/5;
            break;
        case 1:
            kidsLogoListrow=_unBindingArray.count%5>0?_unBindingArray.count/5+1:_unBindingArray.count/5;
            break;
        case 2:
            kidsLogoListrow=_grantedArray.count%5>0?_grantedArray.count/5+1:_grantedArray.count/5;
            break;
        default:
            break;
    }
    if (kidsLogoListrow<1) {
        kidsLogoListrow=1;
    }
    _cellHeight= 35+((CGRectGetWidth(self.view.frame)-100)/5+10)*kidsLogoListrow;
    NSArray *tempArray=[[NSArray alloc]init];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * bindView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, _cellHeight-10)];
        
        [bindView setBackgroundColor:[UIColor colorWithRed:0.467 green:0.843 blue:0.639 alpha:1]];
        //设置按钮是否圆角bu
        [bindView.layer setMasksToBounds:YES];
        //圆角像素化
        [bindView.layer setCornerRadius:4.0];
        bindView.tag=101;
        [cell addSubview:bindView];
        
        //绑定栏目title
        UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
        [bindLbl setText:LOCALIZATION(@"text_bind_child")];
        [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [bindLbl setTextColor:[UIColor whiteColor]];
        [bindLbl setTextAlignment:NSTextAlignmentLeft];
        [bindView addSubview:bindLbl];
        
        switch (indexPath.row) {
            case 0:
                tempArray=[_BindingArray copy];
                
                break;
            case 1:
                tempArray=[_unBindingArray copy];
                
                break;
            case 2:
                tempArray=[_grantedArray copy];
                
                break;
                
            default:
                break;
        }
        
        for (int i=0; i<tempArray.count; i++) {
            
            
            if (i>0&&i%5==0) {
                sNum++;
            }
            DBImageView * kindImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5)];
            [kindImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            
            
            [kindImgView.layer setCornerRadius:CGRectGetHeight([kindImgView bounds]) / 2];
            [kindImgView.layer setMasksToBounds:YES];
            [kindImgView.layer setBorderWidth:2];
            
            [kindImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]];
            //            for (int i =0 ; i < _localChildInfo.count; i ++) {
            //                NSDictionary *tempdic = [_localChildInfo objectAtIndex:i];
            //                if ([[NSString stringWithFormat:@"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]]isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
            //                    if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
            //
            //
            //
            //                        NSData *imageData = loadImageData([self localImgPath], [NSString stringWithFormat:@"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]]);
            //                        UIImage *image = [UIImage imageWithData:imageData];
            //                        [kindImgView setImage:image];
            //
            //                        //  NSLog(@"resourcePath  %@",path);
            //
            //                    }else{
            //
            //
            //                         [kindImgView setImageWithPath:[pathOne copy]];
            //                    }
            //
            //                }
            //
            //            }
            
            [kindImgView setImageWithPath:[pathOne copy]];
            [bindView addSubview:kindImgView];
            
            //儿童图标
            UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
            kindBtn.frame=kindImgView.frame;
            kindBtn.backgroundColor=[UIColor clearColor];
            
            
            //设置按钮响应事件
            [kindBtn addTarget:self action:@selector(ShowKidMessageAction:) forControlEvents:UIControlEventTouchUpInside];
            kindBtn.tag=102+i;
            [bindView addSubview:kindBtn];
        }
        sNum=0;
    }
    //    cell.backgroundColor=[UIColor blackColor];
    NSLog(@"_cellHeight  is %ld and indexPath.row si %zi height is %f",(long)_cellHeight,indexPath.row, cell.frame.size.height);
    
    
    
    UIView * bindView=(UIView *)[cell viewWithTag:101];
    bindView.frame=CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, _cellHeight-10);
    switch (indexPath.row) {
        case 0:
            [bindView setBackgroundColor:[UIColor colorWithRed:0.467 green:0.843 blue:0.639 alpha:1]];
            break;
        case 1:
            [bindView setBackgroundColor:[UIColor colorWithRed:0.282 green:0.800 blue:0.925 alpha:1]];
            break;
        case 2:
            [bindView setBackgroundColor:[UIColor yellowColor]];
            break;
        default:
            break;
    }
    
    
    for (UIView *view in [bindView subviews])
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    //绑定栏目title
    UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
    switch (indexPath.row) {
        case 0:
            [bindLbl setText:LOCALIZATION(@"text_bind_child")];
            break;
        case 1:
            [bindLbl setText:LOCALIZATION(@"text_unbind_child")];
            break;
        case 2:
            [bindLbl setText:LOCALIZATION(@"text_granted_child")];
            break;
        default:
            break;
    }
    
    
    [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
    [bindLbl setTextColor:[UIColor whiteColor]];
    [bindLbl setTextAlignment:NSTextAlignmentLeft];
    [bindView addSubview:bindLbl];
    
    switch (indexPath.row) {
        case 0:
            tempArray=[_BindingArray copy];
            break;
        case 1:
            tempArray=[_unBindingArray copy];
            break;
        case 2:
            tempArray=[_grantedArray copy];
            break;
            
        default:
            break;
    }
    
    for (int i=0; i<tempArray.count; i++) {
        
        //NSLog(@"tempArray -- %@",tempArray);
        if (i>0&&i%5==0) {
            sNum++;
        }
        DBImageView * kindImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5)];
        [kindImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
        
        
        [kindImgView.layer setCornerRadius:CGRectGetHeight([kindImgView bounds]) / 2];
        [kindImgView.layer setMasksToBounds:YES];
        [kindImgView.layer setBorderWidth:2];
        
        [kindImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]];
        [kindImgView setImageWithPath:[pathOne copy]];
        for (int y =0 ; y < _localChildInfo.count;  y++) {
            NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
            if ([[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"child_id" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
                if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                    
                    
                    
                    NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"child_id" ]]] );
                    UIImage *image = [UIImage imageWithData:imageData];
                    [kindImgView setImage:image];
                    
                    //  NSLog(@"resourcePath  %@",path);
                    
                }else{
                    
                    
                    [kindImgView setImageWithPath:[pathOne copy]];
                }
                
            }
            
        }
        
        // [kindImgView setImageWithPath:[pathOne copy]];
        [bindView addSubview:kindImgView];
        
        //儿童图标
        UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        kindBtn.frame=kindImgView.frame;
        kindBtn.backgroundColor=[UIColor clearColor];
        
        //                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
        //设置按钮响应事件
        [kindBtn addTarget:self action:@selector(ShowKidMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_SelectChildrenDictionary setObject:[tempArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d",102+index]];
        kindBtn.tag=102+index;
        index++;
        [bindView addSubview:kindBtn];
        
    }
    
    sNum=0;
    return cell;
}

-(void)ShowKidMessageAction:(id)sender
{
    
    int num = (int)[(UIButton *)sender tag];
    _km =[[KidMessageViewController alloc]init];
    NSLog(@"childrenArray is %@",childrenArray);
    //    _km.childrenDictionary=[_SelectChildrenDictionary objectForKey:[NSString stringWithFormat:@"%d",num]];
    
    NSDictionary *tempDictionary=[_SelectChildrenDictionary objectForKey:[NSString stringWithFormat:@"%d",num]];
    for (int i=0; childrenArray.count; i++) {
        if ([[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] isEqualToString:[tempDictionary objectForKey:@"name"]]) {
            _km.childrenDictionary=[childrenArray objectAtIndex:i];
            break;
        }
    }
    tempDictionary=nil;
    //    _km.major=[[childrenArray objectAtIndex:num] objectForKey:@"major"];
    //    _km.minor=[[childrenArray objectAtIndex:num] objectForKey:@"minor"];
    [self.navigationController pushViewController:_km animated:YES];
    _km.title = @"";
    
}
#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    NSLog(@"responseString -> %@" ,responseString);
    //请求房间列表
    if ([tag isEqualToString:GET_CHILDREN_INFO_LIST]) {
        NSData *responseData = [request responseData];
        childrenArray=[[responseData mutableObjectFromJSONData] objectForKey:@"childrenInfo"];
        if ([childrenArray isKindOfClass:[NSNull class]]) {
            childrenArray = nil;
        }
        
        for(int i=0;i<childrenArray.count; i++)
        {
            NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
            
            [tempDictionary setObject:[[[[childrenArray objectAtIndex:i]objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] forKey:@"icon"];
            
            [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] forKey:@"child_id"];
            
            [tempDictionary setObject:[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] forKey:@"name"];
            
            [tempDictionary setObject:[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]forKey:@"relation_with_user"];
            if (![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqual:[NSNull null]]) {
                [tempDictionary setObject:[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] forKey:@"mac_address"];
                
                
                if ([[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"P"] && ![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isKindOfClass:[NSNull class]]) {
                    [self.BindingArray addObject:[tempDictionary copy]];
                }else if([[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"T"] && ![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isKindOfClass:[NSNull class]]){
                    //[self.BindingArray addObject:[tempDictionary copy]];
                    [self.grantedArray addObject:[tempDictionary copy]];
                }
                
                //                if ([[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
                //                                    }
                
            }
            else
            {
                if([[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"T"]){
                    //[self.BindingArray addObject:[tempDictionary copy]];
                    NSLog(@"  RELATION --- %@",[NSString stringWithFormat:@"%@",[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]]);
                    [self.grantedArray addObject:[tempDictionary copy]];
                }else{
                    NSLog(@"  RELATION --- %@",[NSString stringWithFormat:@"%@",[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]]);
                    [self.unBindingArray addObject:[tempDictionary copy]];
                }
                
                
                
            }
            
            
            if (![[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"P"] && ![[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"T"]) {
                [self.grantedArray addObject:[tempDictionary copy]];
            }
            
            [tempDictionary removeAllObjects];
            tempDictionary=nil;
        }
        
    }
    [_KindlistTView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request  tag:(NSString *)tag
{
    //    [_progressView setHidden:YES];
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@" text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
    
}
-(void)addAction
{
    if (_childView == nil) {
        _childView = [[ChildInformationMatchingViewController alloc]init];
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_GUARDIAN_ID object:[userDefaultes objectForKey:LoginViewController_guardianId]];
    //
    //    NSLog(@" [userDefaultes objectForKey:LoginViewController_guardianId] -> %@",[userDefaultes objectForKey:LoginViewController_guardianId] );
    _childView.comeFrom = @"logined";
    _childView.guardianId = [userDefaultes objectForKey:LoginViewController_guardianId];
    [self.navigationController pushViewController:_childView animated:YES];
    
}

@end
