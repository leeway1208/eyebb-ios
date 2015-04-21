//
//  KidViewController.m
//  EyeBB
//
//  Created by Evan on 15/4/10.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


// first page bottom button
#import "KidViewController.h"
#import "IIILocalizedIndex.h"
#import "DBImageView.h"
#import "AppDelegate.h"
@interface KidViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    
    //数据源数组
    NSMutableArray*_dataArray;
    NSMutableArray*_SortingArray;
    //数据源数组
    //    NSMutableArray*_dataArray;
    //记录未搜索结果数组
    NSArray*_resultArray;
    UITableView*_NametableView;
    UISearchBar*_searchBar;
    AppDelegate *myDelegate;
    //区域/姓名排序
    int Sorting;
    
}
/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *keys;

//@property (strong,nonatomic) UITableView *SortingTView;

/**时间格式*/
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
/**右按钮*/
@property(nonatomic, strong) UIBarButtonItem *rightBtnItem;

/**弹出框*/
@property (strong,nonatomic) UIScrollView * PopupSView;
/**列表显示模式容器*/
@property (strong,nonatomic) UIView * listTypeView;
/**列表显示模式列表*/
@property (strong,nonatomic) UITableView * listTypeTableView;
/**列表显示模式改变按钮*/
@property (strong,nonatomic) UIButton * listTypeChangeBtn;

@property (strong,nonatomic) UIImageView * NameImgView;

@property (strong,nonatomic) UIImageView * SortingImgView;
//单击空白处关闭遮盖层
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

/**按姓名/区域排序*/
@property (nonatomic) BOOL isName;

@end

@implementation KidViewController
@synthesize childrenArray=_childrenArray;
@synthesize kidsRoomArray=_kidsRoomArray;
@synthesize  rightBtnItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    [self iv];
    [self lc];
    
    //    初始化背景图
    //    [self initBackGroundView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
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
    //实例化数组
    _resultArray=[[NSArray alloc]init];
    _SortingArray=[[NSMutableArray alloc]init];
    //    _childrenArray=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Sorting=0;
    _isName=YES;
    for (int i=0; i<_childrenArray.count; i++) {
        [_dataArray addObject:[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
        
    }
    for (int i=0; i<_kidsRoomArray.count; i++) {
        for (int j=0; j<_childrenArray.count; j++) {
            if(![[[_kidsRoomArray objectAtIndex:i] objectForKey:@"locationId"] isEqual:[NSNull null]]&&![[[_childrenArray objectAtIndex:j] objectForKey:@"locId"] isEqual:[NSNull null]])
            {
            if ([[[_kidsRoomArray objectAtIndex:i] objectForKey:@"locationId"]longLongValue]==[[[_childrenArray objectAtIndex:j] objectForKey:@"locId"]longLongValue]) {
                [_SortingArray addObject:[[[[_childrenArray  objectAtIndex:j] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
            }
            }
            
        }
    }
    _resultArray=(NSArray *)_dataArray;
    self.data = [IIILocalizedIndex indexed:_dataArray];
    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

/**
 *加载控件
 */
-(void)lc
{
    _NametableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44,Drive_Wdith,Drive_Height-88) style:UITableViewStylePlain];
    _NametableView.dataSource=self;
    _NametableView.delegate=self;
    _NametableView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
    _NametableView.backgroundColor=[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:1];
    _NametableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _NametableView.sectionIndexColor = [UIColor blueColor];
    //    _tableView.sectionHeaderHeight=108.0f;
    [self.view addSubview:_NametableView];
    
//    _SortingTView=[[UITableView alloc]initWithFrame:CGRectMake(0,44,Drive_Wdith,Drive_Height-84) style:UITableViewStylePlain];
//    _SortingTView.dataSource=self;
//    _SortingTView.delegate=self;
//    _SortingTView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
//    _SortingTView.sectionIndexColor = [UIColor blueColor];
//    _SortingTView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //    _tableView.sectionHeaderHeight=108.0f;
//    [self.view addSubview:_SortingTView];
//    _SortingTView.hidden=YES;
    
    
    //    _childrenArray=[self allChildren];
  
    
    //    _dataArray=[self allChildren];
    
    //    //搜索条
    //    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    //搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = LOCALIZATION(@"btn_search");
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    [self.view addSubview:_searchBar];
    
    //------------------------遮盖层------------------------
    
    //弹出遮盖层
    _PopupSView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupSView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupSView];
    [_PopupSView setHidden:YES];
    
    //单击空白处关闭遮盖层
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    
    [_PopupSView addGestureRecognizer:self.singleTap];
    
    //列表设置列表
    _listTypeView=[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-138, Drive_Wdith-10, 176)];
    [_listTypeView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_listTypeView.layer setMasksToBounds:YES];
    //圆角像素化
    [_listTypeView.layer setCornerRadius:4.0];
    [_PopupSView addSubview:_listTypeView];
    
    //设定title
    UILabel *listtitleLal=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_listTypeView.frame), 44)];
    [listtitleLal setText:LOCALIZATION(@"text_sort_by")];
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
    [_listTypeChangeBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [_listTypeChangeBtn setTitleColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [_listTypeChangeBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [_listTypeChangeBtn addTarget:self action:@selector(SaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_listTypeView addSubview:_listTypeChangeBtn];
    
    
}

/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-70, 0, 70, 70)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:@"funcbar_list"]  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        [button addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
        
    }
    return rightBtnItem;
}

#pragma mark -
#pragma mark 模糊搜索/search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText is %@",searchText);
    if ([searchText isEqualToString:@""]) {
        if (Sorting==0) {
            _dataArray = (NSMutableArray *)_resultArray;
            self.data = [IIILocalizedIndex indexed:_dataArray];
        }
        else
        {
        _SortingArray = (NSMutableArray *)_resultArray;
        self.data = [IIILocalizedIndex indexed:_SortingArray];
        }
        self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
        [_NametableView reloadData];
        return;
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
    NSLog(@"predicate:%@",predicate);
    NSArray *results = [_resultArray filteredArrayUsingPredicate:predicate];
    if (Sorting==0) {
    _dataArray = (NSMutableArray *)results;
    self.data = [IIILocalizedIndex indexed:_dataArray];
    }
    else
    {
        _SortingArray = (NSMutableArray *)_resultArray;
        self.data = [IIILocalizedIndex indexed:_SortingArray];
    }
    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
    [_NametableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark --
#pragma mark - 表单设置

/**tableViewCell的高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.listTypeTableView) {
        return 44;
    }
    return  110.0;
}

#pragma -mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        if(tableView!=_NametableView)
        {
            return 1;
        }
//        else
//    if(tableView==_SortingTView&&Sorting==1)
//    {
//        return _kidsRoomArray.count;
//    }
    else if(tableView==_NametableView)
    {
    if (_isName==YES) {
        return self.keys.count;
    }
    else
    {
        return 1;
    }
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(tableView!=_NametableView&&tableView!=_SortingTView)
//    {
        //        //先清空数组里的内容。每次搜索显示的不能一样吧。
        //        [_resultArray removeAllObjects];
        //        //把输入的内容与原有数据源比较，有相似的就加到_resultArray数组里
        //        for(NSMutableArray*mArray in _dataArray)
        //        {
        //            for(NSString*str in mArray)
        //            {
        //                NSRange range=[str rangeOfString:_searchBar.text];
        //                if(range.location!=NSNotFound){
        //                    [_resultArray addObject:str];
        //                }
        //            }
        //
        //        }
        //
    if(tableView!=_NametableView&&tableView!=self.listTypeTableView)
    {
        return [_resultArray count];
    }
//    }
    else if(tableView==_NametableView)
    {
        if (_isName==YES) {
            NSString *key = [self.keys objectAtIndex:section];
            NSArray *arr = [self.data objectForKey:key];
            return arr.count;
        }
       else
       {
           return _SortingArray.count;
       }
    }
    else if(tableView!=_NametableView)
    {
         return 2;
    }
//    else if(tableView==_SortingTView&&Sorting==1)
//    {
//        NSString *key = [self.keys objectAtIndex:section];
//        NSArray *arr = [self.data objectForKey:key];
//        return arr.count;
//    }
    return 0;
}
//Cell的相关设置
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    static NSString*cellName=@"cell";
    NSDictionary *tempChildDictionary=[NSDictionary dictionary];
    if(_dateFormatter==nil)
    {
        _dateFormatter=[[NSDateFormatter alloc] init];
    }
    [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];

    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //列表显示/刷新设置
    if(tableView == self.listTypeTableView)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            //        cell.tag = indexPath.row;
        }
        
               if (indexPath.row==0) {
            if([cell viewWithTag:104]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:LOCALIZATION(@"text_name")];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:104];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:104];
                [refreshLbl setText:LOCALIZATION(@"text_name")];
            }
            if([cell viewWithTag:105]==nil)
            {
                _NameImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                if (_isName==YES) {
                    [_NameImgView setImage:[UIImage imageNamed:@"selected"]];
                }
                else
                {
                    [_NameImgView setImage:[UIImage imageNamed:@"selected_off"]];
                }
                
                [_NameImgView setTag:105];
                [cell addSubview:_NameImgView];
                
            }
            else
            {
                
                if (_isName==YES) {
                    [_NameImgView setImage:[UIImage imageNamed:@"selected"]];
                }
                else
                {
                    [_NameImgView setImage:[UIImage imageNamed:@"selected_off"]];
                }
                
                
            }
            
            
        }
        else if(indexPath.row==1)
        {
            if([cell viewWithTag:106]==nil)
            {
                UILabel * refreshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame)-60, 44)];
                [refreshLbl setBackgroundColor:[UIColor clearColor]];
                [refreshLbl setText:LOCALIZATION(@"text_location")];
                [refreshLbl setTextColor:[UIColor blackColor]];
                [refreshLbl setTextAlignment:NSTextAlignmentLeft];
                [refreshLbl setTag:106];
                [cell addSubview:refreshLbl];
                
            }
            else
            {
                UILabel * refreshLbl=(UILabel *)[cell viewWithTag:106];
                [refreshLbl setText:LOCALIZATION(@"text_location")];
            }
            
            if([cell viewWithTag:107]==nil)
            {
                _SortingImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cell.frame)-50, 7, 30, 30)];
                
                if (_isName==YES) {
                    [_SortingImgView setImage:[UIImage imageNamed:@"selected_off"]];
                }
                else
                {
                    [_SortingImgView setImage:[UIImage imageNamed:@"selected"]];
                }
                [_SortingImgView setTag:107];
                [cell addSubview:_SortingImgView];
                
            }
            else
            {
                if (_isName==YES) {
                    [_SortingImgView setImage:[UIImage imageNamed:@"selected_off"]];
                }
                else
                {
                    [_SortingImgView setImage:[UIImage imageNamed:@"selected"]];
                }
            }
        }
        else
        {
            
        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
else if (tableView == _NametableView) {
    NSString  *RoomNameStr=@"";
     NSArray *arr = [self.data objectForKey:[self.keys objectAtIndex:section]];
    if (_isName==YES) {
        for (int i=0; i<_childrenArray.count; i++) {
            if ([[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] isEqualToString:[arr objectAtIndex:row]]) {
                tempChildDictionary=[_childrenArray  objectAtIndex:i];
                
                break;
            }
        }
    }
    else
    {
        for (int i=0; i<_childrenArray.count; i++) {
            if ([[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] isEqualToString:[_SortingArray objectAtIndex:row]]) {
                tempChildDictionary=[_childrenArray  objectAtIndex:i];
                //                NSLog(@"tempChildDictionary is%@",tempChildDictionary);
                //                NSLog(@"tempChildDictionary message is%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]);
                
                break;
            }
        }
    }
                NSDate *lastAppearTime=[[NSDate alloc]initWithTimeIntervalSince1970:[[tempChildDictionary objectForKey:@"lastAppearTime"] longLongValue]/1000.0];

        if (_kidsRoomArray.count>0) {
            for (int i=0; i<_kidsRoomArray.count; i++) {
                if ([[[_kidsRoomArray objectAtIndex:i] objectForKey:@"locationId"]longLongValue]==[[tempChildDictionary objectForKey:@"locId"]longLongValue]) {
                    switch (myDelegate.applanguage) {
                        case 0:
                            RoomNameStr=[NSString stringWithFormat:@"@ %@",[[_kidsRoomArray objectAtIndex:i] objectForKey:@"nameSc"]];
                            break;
                        case 1:
                             RoomNameStr=[NSString stringWithFormat:@"@ %@",[[_kidsRoomArray objectAtIndex:i] objectForKey:@"nameTc"]];
                            break;
                        case 2:
                            RoomNameStr=[NSString stringWithFormat:@"@ %@",[[_kidsRoomArray objectAtIndex:i] objectForKey:@"locationName"]];
                            break;
                            
                        default:
                            break;
                    }
                
                    break;
                }
            }
        }
   
       
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
            cell.backgroundColor=[UIColor clearColor];
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, CGRectGetWidth(cell.frame)-20, 100)];
            bgView.backgroundColor=[UIColor whiteColor];
            //设置按钮是否圆角
            [bgView.layer setMasksToBounds:YES];
            //圆角像素化
            [bgView.layer setCornerRadius:4.0];
            bgView.tag=101;
            [cell addSubview:bgView];
            
            //儿童图标
            DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 15, 70, 70)];
            [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
            [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
            [KidsImgView.layer setMasksToBounds:YES];
            [KidsImgView.layer setBorderWidth:2];
            
            [KidsImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            
            NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
            
            [KidsImgView setImageWithPath:[pathOne copy]];
            pathOne=nil;
            
            KidsImgView.tag=102;
            [bgView addSubview:KidsImgView];
            
            UILabel * kidNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 20, CGRectGetWidth(bgView.frame)-95, 20)];
            [kidNameLbl setText:@"***"];
            //            [messageLbl setAlpha:0.6];
            [kidNameLbl setFont:[UIFont systemFontOfSize: 10.0]];
            [kidNameLbl setTextColor:[UIColor blackColor]];
            [kidNameLbl setTextAlignment:NSTextAlignmentLeft];
            kidNameLbl.tag=103;
            [bgView addSubview:kidNameLbl];
            
            UILabel * roomNameLbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 45, CGRectGetWidth(bgView.frame)-95, 20)];
            
           
            [roomNameLbl setText:[NSString stringWithFormat:@"%@ %@",RoomNameStr,[_dateFormatter stringFromDate:lastAppearTime]]];
            
            //            [messageLbl setAlpha:0.6];
            [roomNameLbl setFont:[UIFont systemFontOfSize: 10.0]];
            [roomNameLbl setTextColor:[UIColor blackColor]];
            [roomNameLbl setTextAlignment:NSTextAlignmentLeft];
            roomNameLbl.tag=104;
            [bgView addSubview:roomNameLbl];
            
            
            if(tableView!=_NametableView){
                kidNameLbl.text=[_resultArray objectAtIndex:indexPath.row];
            }else{
                if (_isName==YES) {
                    if (arr.count>0) {
                        
                        [kidNameLbl setText:[arr objectAtIndex:row]];
                    }
                    else
                    {
                        [kidNameLbl setText:@"*****"];
                    }
                }
               else
               {
                    [kidNameLbl setText:[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
               }
                
                
            }
        }
        UIView *bgView=(UIView *)[cell viewWithTag:101];
        DBImageView * KidsImgView=(DBImageView *)[bgView viewWithTag:102];
        UILabel * kidNameLbl =(UILabel *)[bgView viewWithTag:103];
        UILabel * roomNameLbl =(UILabel *)[bgView viewWithTag:104];
         [roomNameLbl setText:[NSString stringWithFormat:@"%@ %@",RoomNameStr,[_dateFormatter stringFromDate:lastAppearTime]]];
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
        
        [KidsImgView setImageWithPath:[pathOne copy]];
        
        pathOne=nil;
        
        
        if(tableView!=_NametableView){
            kidNameLbl.text=[_resultArray objectAtIndex:indexPath.row];
            
        }else{
            
            if (_isName==YES) {
                if (arr.count>0) {
                    
                    [kidNameLbl setText:[arr objectAtIndex:row]];
                }
                else
                {
                    [kidNameLbl setText:@"*****"];
                }
            }
            else
            {
                [kidNameLbl setText:[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
            }

            
            
            
        }
    }
//    else if(Sorting==1)
//    {
//        
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
////设置索引条
//-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.keys;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

//设置索引条对应关系
//如果不加放大镜。这个方法就不需要。
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index==0)
    {
        //index是索引条的序号。从0开始，所以第0 个是放大镜。如果是放大镜坐标就移动到搜索框处
        [tableView scrollRectToVisible:_searchBar.frame animated:NO];
        return -1;
    }else{
        //因为返回的值是section的值。所以减1就是与section对应的值了
        return index-1;
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView!=_NametableView){
        return @"搜索结果";
    }
    else
        return [self.keys objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(tableView!=_NametableView){
//        
//    }
    //房间列表设置
    if(tableView == self.listTypeTableView)
    {
            if (_isName==YES) {
                [_NameImgView setImage:[UIImage imageNamed:@"selected_off"]];
                _isName=NO;
                [_SortingImgView setImage:[UIImage imageNamed:@"selected"]];

                _resultArray=(NSArray *)_SortingArray;
            }
            else
            {
                [_NameImgView setImage:[UIImage imageNamed:@"selected"]];
                _isName=YES;

                [_SortingImgView setImage:[UIImage imageNamed:@"selected_off"]];
                _resultArray=(NSArray *)_dataArray;
            }
               [_NametableView reloadData];
    }

//    else  if(tableView == _NametableView)
//    {
//        //        if (myDelegate.childDictionary==nil) {
//        //            myDelegate.childDictionary=[[NSDictionary alloc]init];
//        //        }
//        //        myDelegate.childDictionary=[_childrenArray objectAtIndex:indexPath.row];
//        
//        
//        if(myDelegate.childDictionary !=nil)
//        {
//            myDelegate.childDictionary=nil;
//            
//            myDelegate.childDictionary=[[NSDictionary alloc]init];
//        }
//        if(myDelegate.childDictionary ==nil)
//        {
//            
//            
//            myDelegate.childDictionary=[[NSDictionary alloc]init];
//        }
//        
//        NSMutableDictionary *tempDictionary=[[NSMutableDictionary alloc]init];
//        
//        [tempDictionary setObject:[[[[_childrenArray objectAtIndex:indexPath.row]objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] forKey:@"icon"];
//        
//        
//        
//        
//        [tempDictionary setObject:[NSString stringWithFormat:@"%@",[[[[_childrenArray objectAtIndex:indexPath.row] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] forKey:@"child_id"];
//        
//        [tempDictionary setObject:[[[[_childrenArray objectAtIndex:indexPath.row] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] forKey:@"name"];
//        
//        [tempDictionary setObject:[[[_childrenArray objectAtIndex:indexPath.row] objectForKey:@"childRel"]objectForKey:@"relation" ]forKey:@"relation_with_user"];
//        
//        [tempDictionary setObject:[[_childrenArray objectAtIndex:indexPath.row] objectForKey:@"macAddress"] forKey:@"mac_address"];
//        
//        myDelegate.childDictionary=(NSDictionary *)[tempDictionary copy];
//        [tempDictionary removeAllObjects];
//        tempDictionary=nil;
//        
//        [self.navigationController popViewControllerAnimated:YES];
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

//重写UIGestureRecognizerDelegate,解决UITapGestureRecognizer与didSelectRowAtIndexPath冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

#pragma mark --
#pragma mark - Handle Gestures

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    [_PopupSView setHidden:YES];
}
#pragma mark - 点击事件
/**切换列表显示模式*/
-(void)typeAction:(id)sender
{
    [_PopupSView setHidden:NO];

}
/**保存房间列表显示设置*/
-(void)SaveAction:(id)sender
{
    [_PopupSView setHidden:YES];
    
}
@end
