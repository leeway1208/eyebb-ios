//
//  GuardianKidsViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "GuardianKidsViewController.h"
#import "IIILocalizedIndex.h"
#import "DBImageView.h"
#import "AppDelegate.h"
#import "AccreditViewController.h"

@interface GuardianKidsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    //数据源数组
    NSMutableArray*_dataArray;
    //记录搜索结果数组
    NSArray*_resultArray;
    UITableView*_tableView;
    //    UISearchBar*_searchBar;
     AppDelegate * myDelegate;

}
/**右按钮*/
@property(nonatomic, retain) UIBarButtonItem *rightBtnItem;
/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *keys;

/**已选中儿童ID列表*/
@property (nonatomic,strong) NSMutableArray*SelectedchildrenIDArray;

/* get local child informaton */
@property (nonatomic,strong) NSMutableArray *localChildInfo;

@end

@implementation GuardianKidsViewController
@synthesize  rightBtnItem;
@synthesize _childrenArray,guestId,SelectedchildrenArray;
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_guestOrMaster == 1) {
        self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    }
    
    [self iv];
    [self lc];
    
    NSLog(@"SelectedchildrenArray -> %@",SelectedchildrenArray );
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
    _localChildInfo = [self allChildren];
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //实例化数组
    _resultArray=[[NSArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    self.SelectedchildrenIDArray=[NSMutableArray array];
    if (_guestOrMaster == 1) {
         _childrenArray= (NSMutableArray *)myDelegate.allKidsBeanArray;
        
        
        for (int j=0; j<_childrenArray.count; j++) {
            NSLog(@"%@,%@",[[[_childrenArray objectAtIndex:j] objectForKey:@"childRel"]objectForKey:@"child" ],[NSNumber numberWithLong:(long)[self.guestId longLongValue]]);
            for(int i=0; i<SelectedchildrenArray.count; i++)
            {
                if ([[[[[_childrenArray objectAtIndex:j] objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]isEqualToNumber:[[SelectedchildrenArray objectAtIndex:i] objectForKey:@"childId"]]) {
                    [self.SelectedchildrenIDArray addObject: [[[[_childrenArray objectAtIndex:j] objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]] ;
                }
            }
            
        }

        for (int i=0; i<_childrenArray.count; i++) {
            [_dataArray addObject:[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
            
        }

    }else if(_guestOrMaster == 2){
        
        for (int i=0; i<_childrenArray.count; i++) {
            [_dataArray addObject:[[_childrenArray  objectAtIndex:i]objectForKey:@"name" ]];
            
        }

    }

    NSLog(@"_childrenArray--> %@",_childrenArray);
//    _childrenArray=[NSMutableArray array];
    
       _resultArray=(NSArray *)_dataArray;
    self.data = [IIILocalizedIndex indexed:_dataArray];
    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
}

/**
 *加载控件
 */
-(void)lc
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,Drive_Wdith,Drive_Height-45) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
    _tableView.sectionIndexColor = [UIColor blueColor];
    //    _tableView.sectionHeaderHeight=108.0f;
    [self.view addSubview:_tableView];
    
    
    //    _childrenArray=[self allChildren];
    
    
    //    //搜索框
    //    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, 44)];
    //    _searchBar.delegate = self;
    //    _searchBar.placeholder = LOCALIZATION(@"btn_search");
    //    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    //    [self.view addSubview:_searchBar];
}

/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-80, 6, 80, 32)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:LOCALIZATION(@"btn_confirm") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button addTarget:self action:@selector(Ok) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
        
    }
    return rightBtnItem;
}
//#pragma mark -
//#pragma mark 模糊搜索/search bar delegate
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}
//
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    return YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    NSLog(@"searchText is %@",searchText);
//    if ([searchText isEqualToString:@""]) {
//        _dataArray = (NSMutableArray *)_resultArray;
//        self.data = [IIILocalizedIndex indexed:_dataArray];
//        self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
//        [_tableView reloadData];
//        return;
//    }
//
//    /**< 模糊查找*/
//    //    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@",keyName, searchText];
//    /**< 精确查找*/
//    //  NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K == %@", keyName, searchText];
//    //    NSLog(@"predicateString:%@",predicateString);
//    //    NSLog(@"_resultArray:%@",_resultArray);
//    //    NSMutableArray  *filteredArray = (NSMutableArray *)[_resultArray filteredArrayUsingPredicate:predicateString];
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
//    NSLog(@"predicate:%@",predicate);
//    NSArray *results = [_resultArray filteredArrayUsingPredicate:predicate];
//    _dataArray = (NSMutableArray *)results;
//    self.data = [IIILocalizedIndex indexed:_dataArray];
//    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
//    [_tableView reloadData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [_searchBar resignFirstResponder];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_searchBar resignFirstResponder];
//}

#pragma mark --
#pragma mark - 表单设置

/**tableViewCell的高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}

#pragma -mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView!=_tableView)
        return 1;
    return self.keys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView!=_tableView)
    {
        
        return [_resultArray count];
    }
    else
    {
        NSString *key = [self.keys objectAtIndex:section];
        NSArray *arr = [self.data objectForKey:key];
        return arr.count;
    }
}
//Cell的相关设置
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    static NSString*cellName=@"cell";
    NSArray *arr = [self.data objectForKey:[self.keys objectAtIndex:section]];
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    NSDictionary *tempChildDictionary=[NSDictionary dictionary];
    if (_guestOrMaster == 1) {
        for (int i=0; i<_childrenArray.count; i++) {
            if ([[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] isEqualToString:[arr objectAtIndex:row]]) {
                tempChildDictionary=[_childrenArray  objectAtIndex:i];
                NSLog(@"tempChildDictionary is%@",tempChildDictionary);
                NSLog(@"tempChildDictionary message is%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]);
                break;
            }
        }

    }else if (_guestOrMaster == 2){
        for (int i=0; i<_childrenArray.count; i++) {
            if ([[[_childrenArray  objectAtIndex:i] objectForKey:@"name" ] isEqualToString:[arr objectAtIndex:row]]) {
                tempChildDictionary=[_childrenArray  objectAtIndex:i];
                NSLog(@"tempChildDictionary is%@",tempChildDictionary);
                NSLog(@"tempChildDictionary message is%@",[tempChildDictionary objectForKey:@"icon" ]);
                break;
            }
        }

    }
    
    
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        
        //儿童图标
        DBImageView * KidsImgView=[[DBImageView alloc] initWithFrame:CGRectMake(10, 2.5, 55, 55)];
         [KidsImgView setPlaceHolder:[UIImage imageNamed:@"logo_en"]];
        [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
        [KidsImgView.layer setMasksToBounds:YES];
        [KidsImgView.layer setBorderWidth:2];
        
        [KidsImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
        NSString* pathOne;
        if(_guestOrMaster == 1){
              pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
        }else if (_guestOrMaster == 2 ){
              pathOne =[NSString stringWithFormat: @"%@",[tempChildDictionary objectForKey:@"icon" ]];
        }
      
        NSLog(@"pathOne -- > %@",tempChildDictionary);
        
        
        
        [KidsImgView setImageWithPath:[pathOne copy]];
        
        pathOne=nil;
        
        KidsImgView.tag=101;
        [cell addSubview:KidsImgView];
        //        if(tableView!=_tableView){
        //            cell.textLabel.text=[_resultArray objectAtIndex:indexPath.row];
        //        }else{
        
        
        //儿童名称
        UILabel * KidsLbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 20, CGRectGetWidth(cell.frame)-80, 20)];
        
        
        if (arr.count>0) {
            
            [KidsLbl setText:[arr objectAtIndex:row]];
        }
        else
        {
            [KidsLbl setText:@"*****"];
        }
        [KidsLbl setFont:[UIFont systemFontOfSize: 18.0]];
        [KidsLbl setTextColor:[UIColor blackColor]];
        [KidsLbl setTextAlignment:NSTextAlignmentLeft];
        KidsLbl.tag=102;
        [cell addSubview:KidsLbl];
        
        //        }
        
        
        //选中/取消图标
        UIImageView *SelecteImgView=[[UIImageView alloc]initWithFrame:CGRectMake(Drive_Wdith-42, 20, 20, 20)];
        
        SelecteImgView.tag=103;
        [cell addSubview:SelecteImgView];
        
    
                BOOL isExistence=NO;
                for (int i=0; i<self.SelectedchildrenIDArray.count; i++) {
                    if ([[[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"] copy] isEqualToNumber:[self.SelectedchildrenIDArray objectAtIndex:i]] ) {
                        isExistence=YES;
                        [SelecteImgView setImage:[UIImage imageNamed:@"selected"]];
                        break;
                    }
                    else
                    {
                        isExistence=NO;
                    }
                }
                if (isExistence==NO) {
  
                    [SelecteImgView setImage:[UIImage imageNamed:@"selected_off"]];
                }
       
        
        
        
        
        
    }
    DBImageView * KidsImgView=(DBImageView *)[cell viewWithTag:101];
    NSString* pathOne;
    if (_guestOrMaster == 1) {
         pathOne =[NSString stringWithFormat: @"%@",[[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ] copy]];
       
    } else if (_guestOrMaster == 2){
        pathOne =[NSString stringWithFormat: @"%@",[[tempChildDictionary objectForKey:@"icon" ] copy]];

    }
 
    
    [KidsImgView setImageWithPath:[pathOne copy]];
    
    pathOne=nil;
    
    
    //    if(tableView!=_tableView){
    //        cell.textLabel.text=[_resultArray objectAtIndex:indexPath.row];
    //    }else{
    //
    //儿童名称
    UILabel * KidsLbl =(UILabel *)[cell viewWithTag:102];
    if (arr.count>0) {
        
        [KidsLbl setText:[arr objectAtIndex:row]];
    }
    else
    {
        [KidsLbl setText:@"*****"];
    }
    
    
    for (int y =0 ; y < _localChildInfo.count;  y++) {
        NSDictionary *tempdic = [_localChildInfo objectAtIndex:y];
        if ([[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId" ]] isEqualToString:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]]) {
            if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_icon"]].length > 0) {
                
                
                
                NSData *imageData = loadImageData([self localImgPath], [self localImgName:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"child_id"]]] );
                UIImage *image = [UIImage imageWithData:imageData];
                [KidsImgView setImage:image];
                
                //  NSLog(@"resourcePath  %@",path);
                
            }else{
                
                
                NSString* pathOne =[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"icon" ]];
                
                [KidsImgView setImageWithPath:[pathOne copy]];
            }
            
            
            if ([NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]].length > 0) {
                
                
                
                [KidsLbl setText:[NSString stringWithFormat:@"%@",[tempdic objectForKey:@"local_name"]]];
            }else{
                
                
                [KidsLbl setText:[NSString stringWithFormat: @"%@",[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"name" ]]];
                
            }
            
            
        }
        
    }

    
    //    }
    
    UIImageView *SelecteImgView=(UIImageView *)[cell viewWithTag:103];
    [SelecteImgView setImage:[UIImage imageNamed:@"selected_off"]];
    
    if (_guestOrMaster == 1) {
        SelecteImgView.hidden = NO;
    }else if(_guestOrMaster == 2){
        SelecteImgView.hidden = YES;
        _tableView.userInteractionEnabled = NO;
    }
    //    if ([[[[_childrenArray objectAtIndex:row] objectForKey:@"parents"]objectForKey:@"guardianId" ] isEqualToNumber:[NSNumber numberWithLong:(long)[self.guestId longLongValue]]]) {
    //        [SelecteImgView setImage:[UIImage imageNamed:@"selected"]];
    //
    //    }
    BOOL isExistence=NO;
    for (int i=0; i<self.SelectedchildrenIDArray.count; i++) {
        if ([[[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]copy] isEqualToNumber:[self.SelectedchildrenIDArray objectAtIndex:i]] ) {
            isExistence=YES;
            NSLog(@"row=%D,%@,%@",row,[[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]copy],[self.SelectedchildrenIDArray objectAtIndex:i]);
            [SelecteImgView setImage:[UIImage imageNamed:@"selected"]];
            break;
        }
        else
        {
            isExistence=NO;
        }
    }
    if (isExistence==NO) {
        
        [SelecteImgView setImage:[UIImage imageNamed:@"selected_off"]];
    }
    
    tempChildDictionary=nil;
    
    return cell;
}
//设置索引条
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

////设置索引条对应关系
////如果不加放大镜。这个方法就不需要。
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if(index==0)
//    {
//        //index是索引条的序号。从0开始，所以第0 个是放大镜。如果是放大镜坐标就移动到搜索框处
//        [tableView scrollRectToVisible:_searchBar.frame animated:NO];
//        return -1;
//    }else{
//        //因为返回的值是section的值。所以减1就是与section对应的值了
//        return index-1;
//    }
//}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView!=_tableView){
        return @"搜索结果";
    }
    else
        return [self.keys objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    int row = indexPath.row;
    if(tableView!=_tableView){
        
    }
    else
    {

        NSArray *arr = [self.data objectForKey:[self.keys objectAtIndex:section]];
        NSDictionary *tempChildDictionary=[NSDictionary dictionary];

        for (int i=0; i<_childrenArray.count; i++) {
            if ([[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ] isEqualToString:[arr objectAtIndex:row]]) {
                tempChildDictionary=[_childrenArray  objectAtIndex:i];
                break;
            }
        }
        
        
        BOOL isExistence=NO;
        for (int i=0; i<self.SelectedchildrenIDArray.count; i++) {
            if ([[[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"
                  ]copy] isEqualToNumber:[self.SelectedchildrenIDArray objectAtIndex:i]] ) {
                isExistence=YES;
                [self.SelectedchildrenIDArray removeObjectAtIndex:i];

                break;
                //                        self.SelectedchildrenArray
                
            }
            else
            {
                isExistence=NO;
            }
            
        }
        if (isExistence==NO) {
            [self.SelectedchildrenIDArray addObject: [[[[tempChildDictionary objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]copy]] ;

        }
        [_tableView reloadData];
        tempChildDictionary=nil;
    }
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

#pragma mark --
#pragma mark --服务器返回信息
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    if ([tag isEqualToString:GRANT_GUESTS]) {
        NSData *responseData = [request responseData];
        //关闭加载
        NSString * resGRANT_GUESTS = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"GRANT_GUESTS %@",resGRANT_GUESTS);
        
        [HUD hide:YES afterDelay:0];
        
        if ([resGRANT_GUESTS isEqualToString:SERVER_RETURN_T]) {
            for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
            {
                if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[AccreditViewController class]]){
                    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
                }
            }

        }else{
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_network_error")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
        
        
//        if (_childrenArray.count>0) {
//            _childrenArray =nil;
//            _childrenArray=[NSArray array];
//        }
//        _childrenArray=[[[responseData mutableObjectFromJSONData] objectForKey:@"childrenInfo"] copy];
////        tempDictionary=nil;
//        responseData=nil;
//        
//        
//        for (int j=0; j<_childrenArray.count; j++) {
//            NSLog(@"%@,%@",[[[_childrenArray objectAtIndex:j] objectForKey:@"parents"]objectForKey:@"guardianId" ],[NSNumber numberWithLong:(long)[self.guestId longLongValue]]);
//            if ([[[[_childrenArray objectAtIndex:j] objectForKey:@"parents"]objectForKey:@"guardianId" ] isEqualToNumber:[NSNumber numberWithLong:(long)[self.guestId longLongValue]]]) {
//                    [self.SelectedchildrenIDArray addObject: [[[[_childrenArray objectAtIndex:j] objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]] ;
//        }
//    }
//        
//        for (int i=0; i<_childrenArray.count; i++) {
//            [_dataArray addObject:[[[[_childrenArray  objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]];
//            
//        }
//        _resultArray=(NSArray *)_dataArray;
//        self.data = [IIILocalizedIndex indexed:_dataArray];
//        self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
//        [_tableView reloadData];
    }
}
#pragma mark --
#pragma mark - 点击事件
/**提交表单*/
-(void)Ok
{
    //开启加载
    [HUD show:YES];
    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=0; i<_childrenArray.count; i++) {
        for(int j=0;j<_SelectedchildrenIDArray.count;j++)
        {
            if(![[NSString stringWithFormat:@"%@",[_SelectedchildrenIDArray objectAtIndex:j]] isEqualToString:[NSString stringWithFormat:@"%@",[[[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]copy]] ])
            {
                [tempArray addObject:[[[[[_childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ] objectForKey:@"childId"]copy]];
                break;
            }
        }
    }
    
    [tempArray removeObjectsInArray:_SelectedchildrenIDArray];
    NSString *_str = [_SelectedchildrenIDArray componentsJoinedByString:@","];
    NSString *_str2 = [tempArray componentsJoinedByString:@","];
      NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:self.guestId, @"guestId", _str,@"accessChildIds",_str2,@"noAccessChildIds",nil];
    
    NSLog(@"_str (%@)  _str2(%@) ",_SelectedchildrenIDArray,_str2);
    
    [self postRequest:GRANT_GUESTS RequestDictionary:[tempDoct copy] delegate:self];
    tempDoct=nil;
}
@end
