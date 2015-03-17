//
//  KidslistViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "KidslistViewController.h"

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

//-------------------视图变量--------------------
@property NSInteger cellHeight;
@end

@implementation KidslistViewController
@synthesize  _childrenArray;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    // Do any additional setup after loading the view.
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
    
    for(int i=0;i<_childrenArray.count; i++)
    {
        NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
        
        [tempDictionary setObject:[[[[_childrenArray objectAtIndex:i]objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] forKey:@"icon"];

        [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] forKey:@"child_id"];
        
        [tempDictionary setObject:[[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] forKey:@"name"];
        
        [tempDictionary setObject:[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]forKey:@"relation_with_user"];
        
        [tempDictionary setObject:[[_childrenArray objectAtIndex:i] objectForKey:@"macAddress"] forKey:@"mac_address"];
        
        
        if (![[[_childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
            [self.BindingArray addObject:tempDictionary];
        }
        
        if ([[[_childrenArray objectAtIndex:i] objectForKey:@"macAddress"] isEqualToString:@""]) {
            [self.unBindingArray addObject:tempDictionary];
        }
        
        if (![[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ] isEqualToString:@"P"]) {
            [self.grantedArray addObject:tempDictionary];
        }
        
        [tempDictionary removeAllObjects];
        tempDictionary=nil;
    }
//    _cellHeight=120;
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
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//section （标签）标题显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _cellHeight;
    
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
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        
        
    }
    cell.backgroundColor=[UIColor blackColor];
    if (indexPath.row==0) {
        if ([cell viewWithTag:101]==nil) {
            
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
            int sNum=0;
            for (int i=0; i<10; i++) {
                
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=102+i;
                [bindView addSubview:kindBtn];
            }
        }
        else
        {
            int sNum=0;
            UIView * bindView=(UIView *)[cell viewWithTag:101];
            
            
            for (UIView *view in [bindView subviews])
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_bind_child")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            [bindView addSubview:bindLbl];
            
            for (int i=0; i<4; i++) {
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=102+i;
                [bindView addSubview:kindBtn];
                
            }
        }
        
        
    }
    else if(indexPath.row==1)
    {
        if ([cell viewWithTag:1000001]==nil) {
            UIView * bindView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, _cellHeight-10)];
            
            [bindView setBackgroundColor:[UIColor colorWithRed:0.282 green:0.800 blue:0.925 alpha:1]];
            //设置按钮是否圆角
            [bindView.layer setMasksToBounds:YES];
            //圆角像素化
            [bindView.layer setCornerRadius:4.0];
            bindView.tag=1000001;
            [cell addSubview:bindView];
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_unbind_child")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            [bindView addSubview:bindLbl];
            int sNum=0;
            for (int i=0; i<10; i++) {
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000002+i;
                [bindView addSubview:kindBtn];
                
            }
        }
        else
        {
            UIView * bindView=(UIView *)[cell viewWithTag:1000001];
            
            for (UIView *view in [bindView subviews])
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_unbind_child")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            [bindView addSubview:bindLbl];
            
            int sNum=0;
            for (int i=0; i<10; i++) {
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=1000002+i;
                [bindView addSubview:kindBtn];
                
            }            }
        
        
    }
    else if(indexPath.row==2)
    {
        if ([cell viewWithTag:2000001]==nil) {
            UIView * bindView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame)-10, _cellHeight-10)];
       
            //设置按钮是否圆角
            [bindView.layer setMasksToBounds:YES];
            //圆角像素化
            [bindView.layer setCornerRadius:4.0];
            bindView.tag=2000001;
            [cell addSubview:bindView];
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_granted_child")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            [bindView addSubview:bindLbl];
            
            int sNum=0;
            for (int i=0; i<10; i++) {
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=2000002+i;
                [bindView addSubview:kindBtn];
                
            }
        }
        else
        {
            UIView * bindView=(UIView *)[cell viewWithTag:2000001];
            
            for (UIView *view in [bindView subviews])
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    [view removeFromSuperview];
                }
            }
            
            //绑定栏目title
            UILabel * bindLbl =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
            [bindLbl setText:LOCALIZATION(@"text_granted_child")];
            [bindLbl setFont:[UIFont systemFontOfSize: 15.0]];
            [bindLbl setTextColor:[UIColor whiteColor]];
            [bindLbl setTextAlignment:NSTextAlignmentLeft];
            [bindView addSubview:bindLbl];
            
            int sNum=0;
            for (int i=0; i<10; i++) {
                //房间图标
                UIButton * kindBtn=[[UIButton alloc] initWithFrame:CGRectZero];
                if (i>0&&i%5==0) {
                    sNum++;
                }
                kindBtn.frame=CGRectMake(10+((CGRectGetWidth(bindView.frame)-100)/5+20)*(i%5),25+((CGRectGetWidth(bindView.frame)-100)/5+10)*sNum , (CGRectGetWidth(bindView.frame)-100)/5, (CGRectGetWidth(bindView.frame)-100)/5);
                [kindBtn.layer setCornerRadius:CGRectGetHeight([kindBtn bounds]) / 2];
                [kindBtn.layer setMasksToBounds:YES];
                [kindBtn.layer setBorderWidth:2];
                
                [kindBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
                [kindBtn setImage:[UIImage imageNamed:@"20150207105906"] forState:UIControlStateNormal];
                //设置按钮响应事件
                [kindBtn addTarget:self action:@selector(ShowRoomAction:) forControlEvents:UIControlEventTouchUpInside];
                kindBtn.tag=2000002+i;
                [bindView addSubview:kindBtn];
                
            }
        }
    }
    
    
    return cell;
}


-(void)addAction
{
    [_KindlistTView reloadData];
}

@end
