//
//  ChildrenListViewController.m
//  EyeBB
//
//  Created by Evan on 15/3/11.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "ChildrenListViewController.h"
#import "IIILocalizedIndex.h"
#import "EGOImageView.h"

@interface ChildrenListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>

{
    //数据源数组
    NSMutableArray*_childrenArray;
    //数据源数组
    NSMutableArray*_dataArray;
    //搜索结果数组
    NSMutableArray*_resultArray;
    UITableView*_tableView;
    UISearchBar*_searchBar;
    
    
}
/**图片本地存储地址*/
@property (nonatomic,strong)NSString * documentsDirectoryPath;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *keys;
@end

@implementation ChildrenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self iv];
    [self lc];
//    初始化背景图
//    [self initBackGroundView];
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
    _resultArray=[[NSMutableArray alloc]init];
    _childrenArray=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    _documentsDirectoryPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *加载控件
 */
-(void)lc
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,320,416) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
//    _tableView.sectionIndexBackgroundColor =[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
//    _tableView.sectionIndexColor = [UIColor blueColor];
//    _tableView.sectionHeaderHeight=108.0f;
    [self.view addSubview:_tableView];
    

    _childrenArray=[self allChildren];
    for (int i=0; i<_childrenArray.count; i++) {
        [_dataArray addObject:[[_childrenArray objectAtIndex:i] objectForKey:@"name"]];

    }
    
    self.data = [IIILocalizedIndex indexed:_dataArray];
    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
   
//    _dataArray=[self allChildren];
    
    //搜索条
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    //把搜索条加到headerView上，其实不是很好，可以加到view上更好
    _tableView.tableHeaderView=_searchBar;
//    [_searchBar release];
    //搜索控制器
    UISearchDisplayController*sdc=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    //设置代理(不需要遵循协议)
    sdc.searchResultsDataSource=self;
    sdc.searchResultsDelegate=self;

}


#pragma -mark -searchbar
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}
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
        //先清空数组里的内容。每次搜索显示的不能一样吧。
        [_resultArray removeAllObjects];
        //把输入的内容与原有数据源比较，有相似的就加到_resultArray数组里
        for(NSMutableArray*mArray in _dataArray)
        {
            for(NSString*str in mArray)
            {
                NSRange range=[str rangeOfString:_searchBar.text];
                if(range.location!=NSNotFound){
                    [_resultArray addObject:str];
                }
            }
            
        }
        
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
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        
        //儿童图标
        EGOImageView * KidsImgView=[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"logo_en"]];
        KidsImgView.frame=CGRectMake(10, 2.5, 55, 55);
        [KidsImgView.layer setCornerRadius:CGRectGetHeight([KidsImgView bounds]) / 2];
        [KidsImgView.layer setMasksToBounds:YES];
        [KidsImgView.layer setBorderWidth:2];
        
        [KidsImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[_childrenArray objectAtIndex:row] objectForKey:@"icon"]];
        KidsImgView.imageURL = [NSURL URLWithString:pathOne];
        
        pathOne=nil;
        
        KidsImgView.tag=101;
        [cell addSubview:KidsImgView];
        if(tableView!=_tableView){
            cell.textLabel.text=[_resultArray objectAtIndex:indexPath.row];
        }else{
           
            
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

        }
    }
    EGOImageView * KidsImgView=(EGOImageView *)[cell viewWithTag:101];
    
    NSString* pathOne =[NSString stringWithFormat: @"%@",[[_childrenArray objectAtIndex:indexPath.row] objectForKey:@"icon"]];

    KidsImgView.imageURL = [NSURL URLWithString:pathOne];

    pathOne=nil;
    

    if(tableView!=_tableView){
        cell.textLabel.text=[_resultArray objectAtIndex:indexPath.row];
    }else{
        
        //儿童名称
        UILabel * KidsLbl =(UILabel *)[cell viewWithTag:102];
        if (arr.count>0) {
            
            [KidsLbl setText:[arr objectAtIndex:row]];
        }
        else
        {
            [KidsLbl setText:@"*****"];
        }
        
        
        
    }
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

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

@end
