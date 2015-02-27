//
//  SettingsViewController.m
//  EyeBB
//
//  Created by liwei wang on 26/2/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * optionsTable;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWidget];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated{
    [_optionsTable removeFromSuperview];
    [self.view removeFromSuperview];
    [self setOptionsTable:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}

-(void)loadWidget{
    NSLog(@"*** %f,---%F",self.view.bounds.size.height,Drive_Height);
    _optionsTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    _optionsTable.dataSource = self;
    _optionsTable.delegate = self;
    //设置table是否可以滑动
    _optionsTable.scrollEnabled = NO;
    //隐藏table自带的cell下划线
    _optionsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_optionsTable];

}

//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 40.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1];
    if (section == 0) {
        
        labelTitle.text = @"用户信息";
        
    }
    else
    {
        labelTitle.text = @"联系信息";
    }
    [v addSubview:labelTitle];
    return v;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==1) {
        return 65;
    }
    else
    {
        return 40;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=3;
    if (section==0) {
        num=3;
    }
    else
    {
        num=2;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        
        
    }
    
 
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
