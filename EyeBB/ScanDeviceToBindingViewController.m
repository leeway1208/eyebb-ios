//
//  ScanDeviceToBindingViewController.m
//  EyeBB
//
//  Created by liwei wang on 25/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "ScanDeviceToBindingViewController.h"
#import "RootViewController.h"
#import "WelcomeViewController.h"

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
/* targetPeripheral  uuid */
@property (nonatomic,strong) NSString * targetPeripheral;
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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSosDevice:) name:nil object:nil ];
    
    [self findSOSDevice];
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
        
    }else if([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME]){
        
        
        NSLog(@"BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME");
       
        NSLog(@"----> child:%@    mac addresss:%@      major:%@      minor:%@    guardian id: %@   ",self.childId,self.macAddress,self.devicMajor,self.devicMinor,[self.guardianId isEqualToString:@"1L"] ? @"":self.guardianId);
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:self.childId, ScanDeviceToBindingViewController_KEY_childId, self.macAddress,ScanDeviceToBindingViewController_KEY_macAddress,self.devicMajor,ScanDeviceToBindingViewController_KEY_majors,self.devicMinor,ScanDeviceToBindingViewController_KEY_minor,[self.guardianId isEqualToString:@"1L"] ? @"":self.guardianId,ScanDeviceToBindingViewController_KEY_guardianId,nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
        NSLog(@"----> child:%@    mac addresss:%@      major:%@      minor:%@    guardian id: %@   ",self.childId,self.macAddress,self.devicMajor,self.devicMinor,[self.guardianId isEqualToString:@"1L"] ? @"":self.guardianId);
        [self postRequest:DEVICE_TO_CHILD RequestDictionary:tempDoct delegate:self];
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME]){
        NSLog(@"BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME");
         [HUD hide:YES afterDelay:0];
        
        
        
        
    }
}

#pragma mark - server return

-(void) requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    if ([tag isEqualToString:DEVICE_TO_CHILD]){
        NSData *responseData = [request responseData];
        NSString *aString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"DEVICE_TO_CHILD  ---> %@",aString);
        //        NSString * registrationId = [[responseData mutableObjectFromJSONData] objectForKey:KindergartenListViewController_json_key_size];
        [HUD hide:YES afterDelay:0];
        //[HUD hide:YES];
        if ([aString isEqualToString:SERVER_RETURN_T]) {
            //login to main
            
            WelcomeViewController *wvc= [[WelcomeViewController alloc]init];
            wvc.autoLogin = YES;
            [self.navigationController pushViewController:wvc animated:YES];

            
        }else{
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_update_server_data_fail")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
        }
        
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag{
    
    if ([tag isEqualToString:GET_KINDERGARTEN_LIST]){
        //NSString *message = NULL;
        
        NSError *error = [request error];
        switch ([error code])
        {
            case ASIRequestTimedOutErrorType:
                [HUD hide:YES afterDelay:0];
                self.title = LOCALIZATION(@"text_connect_error");
                
                break;
            case ASIConnectionFailureErrorType:
                [HUD hide:YES afterDelay:0];
                self.title = LOCALIZATION(@"text_connect_error");
                
                break;
                
        }
        
        //NSLog(@"------> %@",message);
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
    
    CBPeripheral *peripheral=(CBPeripheral *)_SOSDiscoveredPeripherals[indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        
        //beacon name
        _tableTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 20)];
        _tableTitleLabel.text = peripheral.name;
        [cell addSubview:_tableTitleLabel];
        //beacon id
        _tableCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, self.view.frame.size.width-40, 60)];
        _tableCenterLabel.numberOfLines = 2;
        _tableCenterLabel.text = peripheral.identifier.UUIDString;
        [cell addSubview:_tableCenterLabel];
        
    }
    
    if ([peripheral.identifier.UUIDString isEqualToString:self.targetPeripheral]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIColor *color = [[UIColor alloc]initWithRed:0.353 green:0.357 blue:0.373 alpha:1];
        //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellart.png"]] ;
        cell.backgroundColor = color;
//        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
//        [cell.textLabel setTextColor:[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
    }
    
 
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self stopScan];
    [HUD show:YES];
    
    CBPeripheral *targetPeripheral=(CBPeripheral *)_SOSDiscoveredPeripherals[indexPath.row];
    NSLog(@"write major:%@ and minor:%@ ",_devicMajor,_devicMinor);
    
    if (![self.targetPeripheral isEqualToString:targetPeripheral.identifier.UUIDString]) {
        [self writeMajorAndMinorThenMajor:targetPeripheral.identifier.UUIDString writeMajor:_devicMajor writeMinor:_devicMinor];
        self.targetPeripheral = targetPeripheral.identifier.UUIDString;
        [tableView reloadData];
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
