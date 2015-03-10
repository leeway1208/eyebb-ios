//
//  SettingsViewController.m
//  EyeBB
//
//  Created by liwei wang on 26/2/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "SettingsViewController.h"

#import "ASIDownloadCache.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/** all items */
@property (nonatomic,strong) UITableView * optionsTable;
/**右按钮*/
@property(nonatomic, retain) UIBarButtonItem *rightBtnItem;
@end

@implementation SettingsViewController
@synthesize  rightBtnItem;

#pragma mark - load views

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = self.rightBtnItem;
   
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(settingsSelectLeftAction:)];
   
    
    //    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:236.0f/255.0f green:66.0f/255.0f  blue:53.0f/255.0f alpha:1.0f];
    [self loadWidget];
    // Do any additional setup after loading the view.
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
    _optionsTable.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    //_optionsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_optionsTable];
    
}
/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-100, 6, 80, 32)];
        [button setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
        [button setTitle:LOCALIZATION(@"btn_logout") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1.0];
        //设置按钮是否圆角
        [button.layer setMasksToBounds:YES];
        //圆角像素化
        [button.layer setCornerRadius:4.0];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];

        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;

    }
    return rightBtnItem;
}

#pragma mark - table view
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionTopView = nil;
    sectionTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    [sectionTopView setBackgroundColor:[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0]];
    
    //label
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 30.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor=[UIColor blackColor];
    
    if (section == 0) {
        labelTitle.text = LOCALIZATION(@"text_settings_app_function");
        
    }
    else if(section == 1){
        labelTitle.text = LOCALIZATION(@"text_device");
        
    }else if(section == 2){
        labelTitle.text = LOCALIZATION(@"text_language");
        
    }else if(section == 3){
        labelTitle.text = LOCALIZATION(@"text_setting_user_account");
        
    }else if(section == 4){
        labelTitle.text = LOCALIZATION(@"text_others");
        
    }
    
    
    
    
    [sectionTopView addSubview:labelTitle];
    return sectionTopView;
}

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section==1&&indexPath.row==1) {
    //        return 60;
    //    }
    //    else
    //    {
    //        return 60;
    //    }
    return 45;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else if(section == 3){
        return 2;
    }else if(section == 4){
        return 3;
    }
    
    return 0;
    
}


-(UILabel *) settingLable: (NSString *)textName{
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 0.0f, Drive_Wdith-34, 44)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor=[UIColor blackColor];
    label.text = LOCALIZATION(textName);
    
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        //        cell.tag = indexPath.row;
        //section is 5.
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                
                [cell addSubview:[self settingLable:@"text_auto_refresh"]];
            }else if(indexPath.row == 1){
                
                [cell addSubview:[self settingLable:@"text_enableSound"]];
            }else if(indexPath.row == 2){
                
                [cell addSubview:[self settingLable:@"text_enableVibration"]];
            }
        }else if(indexPath.section == 1){
            if(indexPath.row == 0){
                
                [cell addSubview:[self settingLable:@"btn_children_list"]];
                
            }else if(indexPath.row == 1){
                
                [cell addSubview:[self settingLable:@"btn_auth_list"]];
                
            }
        }else if(indexPath.section == 2){
            if(indexPath.row == 0){
                
                [cell addSubview:[self settingLable:@"text_english"]];
                
            }else if(indexPath.row == 1){
                
                [cell addSubview:[self settingLable:@"text_chinese"]];
                
                
            }else if(indexPath.row == 2){
                
                [cell addSubview:[self settingLable:@"text_simplified_chinese"]];
                
            }
        }else if(indexPath.section == 3){
            if(indexPath.row == 0){
                
                [cell addSubview:[self settingLable:@"text_update_password"]];
                
            }else if(indexPath.row == 1){
                
                [cell addSubview:[self settingLable:@"text_update_nickname"]];
                
            }
        }else if(indexPath.section == 4){
            if(indexPath.row == 0){
                [cell addSubview:[self settingLable:@"text_about"]];
                
            }else if(indexPath.row == 1){
                
                [cell addSubview:[self settingLable:@"text_TermsOfService"]];
                
            }else if(indexPath.row == 2){
                [cell addSubview:[self settingLable:@"text_privacyPolicy"]];
                
            }
        }
        
        
    }
    
    
    
    
    
    return cell;
}

#pragma mark - button action
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)settingsSelectLeftAction:(id)sender
{
    [[self navigationController] pushViewController:nil animated:YES];
}

-(void)exitAction:(id)sender
{
    
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [ASIHTTPRequest clearSession];
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
