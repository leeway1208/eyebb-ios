//
//  ScanDeviceToBindingViewController.m
//  EyeBB
//
//  Created by liwei wang on 25/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "ScanDeviceToBindingViewController.h"
#import "RootViewController.h"

@interface ScanDeviceToBindingViewController ()
/**introdaction label*/
@property (nonatomic,strong) UILabel* introLabel;
/* device table */
@property (nonatomic,strong) UITableView * deviceTableView;
/* get sos device table */
@property (strong,nonatomic) NSMutableArray *SOSDiscoveredPeripherals;
/* device  name */
@property (nonatomic,strong) UILabel * tableTitleLabel;
/* device  uuid */
@property (nonatomic,strong) UILabel * tableCenterLabel;
@end

@implementation ScanDeviceToBindingViewController
#pragma mark - view load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"navi_btn_back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(scanDeviceViewLeftAction:)];
    
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.title = LOCALIZATION(@"text_search_your_device");
    
    
    
    
    [self loadParameter];
    [self loadWidget];
    
    
    [self findSOSDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSosDevice:) name:BLUETOOTH_GET_SOS_DEVICE_BROADCAST_NAME object:nil ];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

// gesture to cancel swipe (use for ios 8)
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]){
        return  NO;
        
    }else{
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWidget{
    
    _introLabel = [[UILabel alloc]init];
    _introLabel.frame = CGRectMake(10,10, Drive_Wdith - 20, 90);
    _introLabel.text = LOCALIZATION(@"text_press_the_button_on_the_device");
    _introLabel.textAlignment = NSTextAlignmentCenter;
    _introLabel.layer.borderColor = [[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]CGColor];
    _introLabel.layer.borderWidth = 2;
    _introLabel.numberOfLines = 4;
    [self.view addSubview:_introLabel];
    
}


-(void)loadParameter{
   
    _deviceTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _deviceTableView.frame = CGRectMake(0, 110, Drive_Wdith, Drive_Height);
    self.deviceTableView.tableFooterView = [[UIView alloc] init];
    _deviceTableView.dataSource = self;
    _deviceTableView.delegate = self;
    //设置table是否可以滑动
    _deviceTableView.scrollEnabled = NO;
    //隐藏table自带的cell下划线
    //_deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_deviceTableView];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_SOS_DEVICE_BROADCAST_NAME object:nil];
    
    _SOSDiscoveredPeripherals = nil;
    [_introLabel removeFromSuperview];
    [_deviceTableView removeFromSuperview];
    [_tableTitleLabel removeFromSuperview];
    [_tableCenterLabel removeFromSuperview];
    [self.view removeFromSuperview];
    
    [self setTableTitleLabel:nil];
    [self setTableCenterLabel:nil];
    [self setIntroLabel:nil];
    [self setDeviceTableView:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}

#pragma mark - broadcast
- (void) getSosDevice:(NSNotification *)notification{
    if ([[notification name] isEqualToString:BLUETOOTH_GET_SOS_DEVICE_BROADCAST_NAME]) {
        
        
        _SOSDiscoveredPeripherals = [(NSMutableArray *)[notification object]copy];
        
        NSLog(@"GET AD --- > %lu",(unsigned long)_SOSDiscoveredPeripherals.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.deviceTableView reloadData];
     
        });
        
    }
}


#pragma mark - button aciton
-(void)scanDeviceViewLeftAction:(id)sender
{
    
    for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
    {
        if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[RootViewController class]]){
            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
            
        }
    }
    
    
    
}


#pragma mark - table methods
//set sections in table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


// set cells height
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


//set the number of cells in one section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _SOSDiscoveredPeripherals.count;
}


// set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    CBPeripheral *peripheral=(CBPeripheral *)self.SOSDiscoveredPeripherals[indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        
        //beacon name
        _tableTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 20)];
        _tableTitleLabel.text = peripheral.name;
        [cell addSubview:_tableTitleLabel];
        //beacon id
        _tableCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, self.view.frame.size.width-30, 60)];
        _tableCenterLabel.numberOfLines = 2;
        _tableCenterLabel.text = peripheral.identifier.UUIDString;
        [cell addSubview:_tableCenterLabel];
        
    }
    
    
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
