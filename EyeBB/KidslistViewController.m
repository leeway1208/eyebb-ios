//
//  KidslistViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "KidslistViewController.h"
#import "ChildInformationMatchingViewController.h"

#import "KidMessageViewController.h"


@interface KidslistViewController ()<UITableViewDataSource,UITableViewDelegate>
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
//@property (strong,nonatomic)  AddGuardianViewController *addGuardian;
@property (strong,nonatomic)  KidMessageViewController * km;
//-------------------视图变量--------------------
@property NSInteger cellHeight;

/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
@end

@implementation KidslistViewController
@synthesize  childrenArray;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    // Do any additional setup after loading the view.
     [self getRequest:GET_CHILDREN_INFO_LIST delegate:self RequestDictionary:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    [self iv];
    [self lc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    self.BindingArray=[[NSMutableArray alloc]init];
    
    self.unBindingArray=[[NSMutableArray alloc]init];
    
    self.grantedArray=[[NSMutableArray alloc]init];
    
        _cellHeight=44;
    
     _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *加载控件
 */
-(void)lc
{
    
    _KindlistTView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _KindlistTView.dataSource = self;
    _KindlistTView.delegate = self;
    //设置table是否可以滑动
    _KindlistTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    _KindlistTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_KindlistTView];
    
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
            
            //儿童图标
            UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
            if (i>0&&i%5==0) {
                sNum++;
            }
            kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
            [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
            [kindBtn.layer setMasksToBounds:YES];
            [kindBtn.layer setBorderWidth:2];
            
            [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
            NSLog(@"tempArray si %@",tempArray);
            if (tempArray.count>0&&![[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]] isEqualToString:@""]) {
                NSString* pathOne =[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]];
                
                NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
                NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."] copy];
                
                
                
                if ([self loadImage:[array2 objectAtIndex:0] ofType:[[array2 objectAtIndex:1] copy ]inDirectory:_documentsDirectoryPath]!=nil) {
                    
                    [kindBtn setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath] forState:UIControlStateNormal];
                }
                else
                {
                    NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
                    NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
                    [kindBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
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
                [kindBtn setImage:[UIImage imageNamed:@"logo_en"] forState:UIControlStateNormal];
            }

//            [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
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
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        if (tempArray.count>0&&![[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]] isEqualToString:@""]) {
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[tempArray objectAtIndex:i]objectForKey:@"icon" ]];
            
            NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
            NSArray  * array2= [[[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."] copy];
            
            
            
            if ([self loadImage:[array2 objectAtIndex:0] ofType:[[array2 objectAtIndex:1] copy ]inDirectory:_documentsDirectoryPath]!=nil) {
                
                [kindBtn setImage:[self loadImage:[[array2 objectAtIndex:0]copy] ofType:[[array2 objectAtIndex:1]copy] inDirectory:_documentsDirectoryPath] forState:UIControlStateNormal];
            }
            else
            {
                NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
                NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
                [kindBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
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
            [kindBtn setImage:[UIImage imageNamed:@"logo_en"] forState:UIControlStateNormal];
        }

        
//                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowKidMessageAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=102+i;
                [bindView addSubview:kindBtn];
                
            }
        
         sNum=0;
    return cell;
}

-(void)ShowKidMessageAction:(id)sender
{
    int num = (int)[(UIButton *)sender tag];
    _km =[[KidMessageViewController alloc]init];
    _km.major=[[childrenArray objectAtIndex:num] objectForKey:@"major"];
    _km.minor=[[childrenArray objectAtIndex:num] objectForKey:@"minor"];
    [self.navigationController pushViewController:_km animated:YES];
    _km.title = @"";

}
#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
        NSString *responseString = [request responseString];
    //请求房间列表
    if ([tag isEqualToString:GET_CHILDREN_INFO_LIST]) {
        NSData *responseData = [request responseData];
        childrenArray=[[responseData mutableObjectFromJSONData] objectForKey:@"childrenInfo"];
        for(int i=0;i<childrenArray.count; i++)
        {
            NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
            
            [tempDictionary setObject:[[[[childrenArray objectAtIndex:i]objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] forKey:@"icon"];
            
            [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] forKey:@"child_id"];
            
            [tempDictionary setObject:[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] forKey:@"name"];
            
            [tempDictionary setObject:[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]forKey:@"relation_with_user"];
            if (![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqual:[NSNull null]]) {
                [tempDictionary setObject:[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] forKey:@"mac_address"];
                
                
                if (![[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
                    [self.BindingArray addObject:[tempDictionary copy]];
                }
                
                if ([[[childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
                    [self.unBindingArray addObject:[tempDictionary copy]];
                }

            }
            
           
            
            if (![[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"P"]) {
                [self.grantedArray addObject:[tempDictionary copy]];
            }
            
            [tempDictionary removeAllObjects];
            tempDictionary=nil;
        }

    }
    [_KindlistTView reloadData];
}


//-(void)addAction
//{
//    _addGuardian =[[AddGuardianViewController alloc]init];
//    [self.navigationController pushViewController:_addGuardian animated:YES];
////    ChildInformationMatchingViewController *cfm=[[ChildInformationMatchingViewController alloc]init];
////    [self.navigationController pushViewController:cfm animated:YES];
////    [_KindlistTView reloadData];
//}

@end
