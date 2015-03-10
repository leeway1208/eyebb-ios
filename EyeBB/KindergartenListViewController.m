//
//  KindergartenListViewController.m
//  EyeBB
//
//  Created by liwei wang on 6/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "KindergartenListViewController.h"
#import "JSONKit.h"

#import "ChildInformationMatchingViewController.h"

@interface KindergartenListViewController ()<UITableViewDataSource,UITableViewDelegate>

/** all kindergarten items */
@property (nonatomic,strong) UITableView * kindergartenTable;
/** use to keep json information */
@property (nonatomic,strong) NSArray * allLocationAreasInfoAr;
/** use to keep json information */
@property (nonatomic,strong) UIImageView * cellLeftImg;
@end



@implementation KindergartenListViewController


#pragma mark - load views

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    // Do any additional setup after loading the view.
    
    self.title = LOCALIZATION(@"text_select_kid_kindergarten");
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(KindergartenListViewControllerLeftAction:)];
    
    [self requestServer];
    [self loadWidget];
    [self loadParameter];
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


- (void)viewDidDisappear:(BOOL)animated{
    [_kindergartenTable removeFromSuperview];
    
    
    [self.view removeFromSuperview];
    [self setKindergartenTable:nil];
    
    [self setView:nil];
    [super viewDidDisappear:animated];
}

-(void)loadParameter{
    
    _allLocationAreasInfoAr = [[NSArray alloc]init];
}


-(void)loadWidget{
    NSLog(@"*** %f,---%F",self.view.bounds.size.height,Drive_Height);
    _kindergartenTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    _kindergartenTable.backgroundColor = [UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    self.kindergartenTable.tableFooterView = [[UIView alloc] init];
    _kindergartenTable.dataSource = self;
    _kindergartenTable.delegate = self;
    //设置table是否可以滑动
    _kindergartenTable.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    //_kindergartenTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_kindergartenTable];
    
}

#pragma mark - request server
-(void)requestServer{
    
    [self getRequest:GET_KINDERGARTEN_LIST delegate:self];
    
}

#pragma mark - server return

-(void) requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    if ([tag isEqualToString:GET_KINDERGARTEN_LIST]){
        NSData *responseData = [request responseData];
        //                NSString *aString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString * registrationId = [[responseData mutableObjectFromJSONData] objectForKey:KindergartenListViewController_json_key_size];
        _allLocationAreasInfoAr = [[[responseData mutableObjectFromJSONData] objectForKey:KindergartenListViewController_json_key_allLocationAreasInfo] copy];
        
        //NSLog(@"sadasdsadsafff--->%@ ",[_allLocationAreasInfoAr objectAtIndex:4]);
        
        [_kindergartenTable reloadData];
        
    }
}




#pragma mark - table view

//set sections in table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return 1;
}

//set setions height in table view
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    
    return 0;
}

// set cells height
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 70;
}


//set the number of cells in one section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _allLocationAreasInfoAr.count;
}


// set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    
    if(tableView == self.kindergartenTable)
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            //        cell.tag = indexPath.row;
        }
        //ui label
        UILabel * messageLbl =[[UILabel alloc]initWithFrame:CGRectMake(85, 24, CGRectGetWidth(cell.frame)-100, 20)];
        [messageLbl setText:[[_allLocationAreasInfoAr objectAtIndex:indexPath.row]objectForKey:KindergartenListViewController_json_key_nameTc]];
        //            [messageLbl setAlpha:0.6];
        [messageLbl setFont:[UIFont systemFontOfSize: 15.0]];
        [messageLbl setTextColor:[UIColor blackColor]];
        
        [cell addSubview:messageLbl];
        
        
        /*save image */
        //get image path
        NSString* pathOne =[NSString stringWithFormat: @"%@",[[_allLocationAreasInfoAr objectAtIndex:indexPath.row] objectForKey:KindergartenListViewController_json_key_icon]];
        NSLog(@"pathOne----%@",pathOne);
        if(pathOne.length > 1){
            //NSLog(@"SADSADSSSSSS----%@",pathOne);
            NSArray  * array= [pathOne componentsSeparatedByString:@"/"];
            //NSLog(@"SADSADS----%@",array);
            
            
            NSArray  * arrayForImage = [[array objectAtIndex:([array count]-1)]componentsSeparatedByString:@"."];
            
            NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            //ui image
            UIImageView * kindergartenImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
            [kindergartenImgView.layer setCornerRadius:CGRectGetHeight([kindergartenImgView bounds]) / 2];
            [kindergartenImgView.layer setMasksToBounds:YES];
            [kindergartenImgView.layer setBorderWidth:2];
            
            [kindergartenImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
            [cell addSubview:kindergartenImgView];
            
            
            
            
            // fill in the image
            if ([self loadImage:[arrayForImage objectAtIndex:0] ofType:[arrayForImage objectAtIndex:1] inDirectory:documentsDirectoryPath]!=nil){
                [kindergartenImgView setImage:[self loadImage:[arrayForImage objectAtIndex:0] ofType:[arrayForImage objectAtIndex:1] inDirectory:documentsDirectoryPath]];
            }else{
                NSURL* urlOne = [NSURL URLWithString:[pathOne stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
                NSData* data = [NSData dataWithContentsOfURL:urlOne];//获取网咯图片数据
                [kindergartenImgView setImage:[UIImage imageWithData:data]];
                //Get Image From URL
                UIImage * imageFromURL  = nil;
                imageFromURL=[UIImage imageWithData:data];
                //Save Image to Directory
                [self saveImage:imageFromURL withFileName:[arrayForImage objectAtIndex:0] ofType:[arrayForImage objectAtIndex:1] inDirectory:documentsDirectoryPath];
            }
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.kindergartenTable){
        
        ChildInformationMatchingViewController *cimmvc = [[ChildInformationMatchingViewController alloc] init];
        cimmvc.kindergartenName = [[_allLocationAreasInfoAr objectAtIndex:indexPath.row ]objectForKey:KindergartenListViewController_json_key_nameTc];
        cimmvc.kindergartenId = [[_allLocationAreasInfoAr objectAtIndex:indexPath.row ]objectForKey:KindergartenListViewController_json_key_areaId];
        [self.navigationController pushViewController:cimmvc animated:YES];
        
    }
    
    
}

#pragma mark - button action
-(void)KindergartenListViewControllerLeftAction:(id) sender{
    [[self navigationController] pushViewController:nil animated:YES];
}



@end
