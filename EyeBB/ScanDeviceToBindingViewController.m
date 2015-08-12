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
#import "ChildInformationMatchingViewController.h"


#define BROADCAST_GUARDIAN_ID @"guardian_id_kids_listview"

@interface ScanDeviceToBindingViewController (){
    NSString* guardian_id;
}
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
/**  device major  */
@property (strong,nonatomic) NSString * deviceMajor;
/**  device minor  */
@property (strong,nonatomic) NSString * deviceMinor;
/**  select Target Peripheral */
@property (strong,nonatomic) CBPeripheral *didSelectTargetPeripheral;
/**  select Target advertisementData */
@property (strong,nonatomic) NSDictionary *didSelectTargetAdvertisementData;
/**  select Target AdvertisementData */
@property (strong,nonatomic) NSMutableArray *SOSDiscoveredAdvertisementData;
/* get sos device table */
@property (strong,nonatomic) NSMutableArray *SOSDiscoveredRSSI;

/** beep pop */
@property (strong,nonatomic) UIScrollView * PopupBeepView;
/** beep pop   */
@property (strong,nonatomic) UIView * BeepView;
/** beep pop    */
@property (nonatomic,strong) UILabel *beepLbl;
@end

@implementation ScanDeviceToBindingViewController
#pragma mark - view load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"navi_btn_back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(scanDeviceViewLeftAction:)];
    [newBackButton setBackgroundImage:[UIImage
                                       imageNamed: @"navi_btn_back.png"]forState:UIControlStateSelected  barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.title = LOCALIZATION(@"text_search_your_device");

    
    [self loadParameter];
    [self loadWidget];
    
    
     //reg broad cast
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
    
    
    
    
    //------------------change name------遮盖层------------------------
    
    //弹出遮盖层
    _PopupBeepView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height)];
    _PopupBeepView.backgroundColor=[UIColor colorWithRed:0.137 green:0.055 blue:0.078 alpha:0.3];
    
    [self.view addSubview:_PopupBeepView];
    [_PopupBeepView setHidden:YES];
    
    
    //unbind view
    _BeepView =[[UIView alloc]initWithFrame:CGRectMake(5, (Drive_Height+20)/2-138, Drive_Wdith-10, 100)];
    [_BeepView setBackgroundColor:[UIColor whiteColor] ];
    //设置列表是否圆角
    [_BeepView.layer setMasksToBounds:YES];
    //圆角像素化
    [_BeepView.layer setCornerRadius:4.0];
    [_PopupBeepView addSubview:_BeepView];
    
    
    // LABEL
    _beepLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,5 , CGRectGetWidth(_PopupBeepView.frame) - 20, 50)];
    _beepLbl.text = @"";
    [_beepLbl setFont:[UIFont systemFontOfSize:10]];
    _beepLbl.numberOfLines = 3;
    [_BeepView addSubview:_beepLbl];
    
    
    //取消按钮
    UIButton * CencelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 62,  CGRectGetWidth(_BeepView.frame)/2, 38)];
    //设置按显示文字
    [CencelBtn setTitle:LOCALIZATION(@"btn_cancel") forState:UIControlStateNormal];
    [CencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CencelBtn setImage:[UIImage imageNamed:@"cross2"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [CencelBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [CencelBtn addTarget:self action:@selector(beepCancelAction) forControlEvents:UIControlEventTouchUpInside];
    //                //CencelBtn按钮是否圆角
    //                [CencelBtn.layer setMasksToBounds:YES];
    //                //圆角像素化
    //                [CencelBtn.layer setCornerRadius:4.0];
    [CencelBtn.layer setBorderWidth:0.5]; //边框宽度
    [CencelBtn.layer setBorderColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1].CGColor];//边框颜色
    
    [_BeepView addSubview:CencelBtn];
    
    //确定按钮
    UIButton * OkBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_BeepView.frame)/2,62, CGRectGetWidth(_BeepView.frame)/2, 38)];
    //设置按显示文字
    [OkBtn setTitle:LOCALIZATION(@"btn_ok") forState:UIControlStateNormal];
    [OkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OkBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    //设置按钮背景颜色
    [OkBtn setBackgroundColor:[UIColor clearColor]];
    //设置按钮响应事件
    [OkBtn addTarget:self action:@selector(beepConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    //                //CencelBtn按钮是否圆角
    //                [CencelBtn.layer setMasksToBounds:YES];
    //                //圆角像素化
    //                [CencelBtn.layer setCornerRadius:4.0];
    [OkBtn.layer setBorderWidth:0.5]; //边框宽度
    [OkBtn.layer setBorderColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1].CGColor];//边框颜色
    
    [_BeepView addSubview:OkBtn];

    
}


-(void)loadParameter{
 
    
    
    _deviceTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _deviceTableView.frame = CGRectMake(0, 110, Drive_Wdith, Drive_Height - 160);
    self.deviceTableView.tableFooterView = [[UIView alloc] init];
    _deviceTableView.dataSource = self;
    _deviceTableView.delegate = self;
    //设置table是否可以滑动
    _deviceTableView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    //_deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_deviceTableView];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_SOS_DEVICE_PERIPHERAL_BROADCAST_NAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_SOS_DEVICE_ADVERTISEMENT_DATA_BROADCAST_NAME object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_SOS_DEVICE_RSSI_BROADCAST_NAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_WRITE_BEEP_SUCCESS_BROADCAST_NAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BROADCAST_GUARDIAN_ID object:nil];
    
    _SOSDiscoveredPeripherals = nil;
    [_introLabel removeFromSuperview];
    [_deviceTableView removeFromSuperview];
    [_tableTitleLabel removeFromSuperview];
    [_tableCenterLabel removeFromSuperview];
    [_PopupBeepView removeFromSuperview];
    [_BeepView removeFromSuperview];
    [_beepLbl removeFromSuperview];
    [self.view removeFromSuperview];
    
    [self setTableTitleLabel:nil];
    [self setTableCenterLabel:nil];
    [self setIntroLabel:nil];
    [self setDeviceTableView:nil];
    [self setPopupBeepView:nil];
    [self setBeepView:nil];
    [self setBeepLbl:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}

#pragma mark - broadcast

//- (void) getId:(NSNotification *)notification{
//    if ([[notification name] isEqualToString:BROADCAST_GUARDIAN_ID]) {
//        
//        guardian_id = (NSString *)[notification object];
//        
//        
//        
//        
//    }
//}

- (void) getSosDevice:(NSNotification *)notification{

    
    if ([[notification name] isEqualToString:BLUETOOTH_GET_SOS_DEVICE_PERIPHERAL_BROADCAST_NAME]) {
        
        
        _SOSDiscoveredPeripherals = [(NSMutableArray *)[notification object]mutableCopy];
        
        NSLog(@"GET AD --- > %lu",(unsigned long)_SOSDiscoveredPeripherals.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_deviceTableView reloadData];
            
        });
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_GET_SOS_DEVICE_ADVERTISEMENT_DATA_BROADCAST_NAME]){
        
        _SOSDiscoveredAdvertisementData = [(NSDictionary *)[notification object]mutableCopy];
        
         NSLog(@"GET AD ad --- > %lu",(unsigned long)_SOSDiscoveredAdvertisementData.count);
        
    }else if ([[notification name] isEqualToString:BLUETOOTH_GET_SOS_DEVICE_RSSI_BROADCAST_NAME]){
     
        _SOSDiscoveredRSSI = [(NSMutableArray *)[notification object]mutableCopy];
        
        
    }
    
    
    else if([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME]){
        
        
        NSMutableArray *result = (NSMutableArray *)[notification object];
        
        
        NSLog(@"BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME");
//        if (guardian_id != nil) {
//            self.guardianId = guardian_id;
//        }
        NSLog(@"guardian_id  - > %@", guardian_id);
        NSLog(@"----> child:%@    mac addresss:%@      major:%@      minor:%@    guardian id: %@   ",self.childId,self.macAddress,_deviceMajor,_deviceMinor,self.guardianId);
        
      
        
        NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:self.childId, ScanDeviceToBindingViewController_KEY_childId, self.macAddress,ScanDeviceToBindingViewController_KEY_macAddress,_deviceMajor,ScanDeviceToBindingViewController_KEY_majors,_deviceMinor,ScanDeviceToBindingViewController_KEY_minor,self.guardianId,ScanDeviceToBindingViewController_KEY_guardianId,nil];
        // NSLog(@"%@ --- %@",userAccount,[CommonUtils getSha256String:hashUserPassword].uppercaseString);
        
  
        [self postRequest:DEVICE_TO_CHILD RequestDictionary:tempDoct delegate:self];
        tempDoct = nil;
    }else if ([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME]){
        NSLog(@"BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME");
         [HUD hide:YES afterDelay:0];
        
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_update_server_data_fail")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
        
        
    }else if([[notification name] isEqualToString:BLUETOOTH_BINDING_TIME_OUT]){
        [HUD hide:YES afterDelay:0];
        [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                    message:LOCALIZATION(@"text_update_server_data_fail")
                                   delegate:self
                          cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                          otherButtonTitles:nil] show];
        
        
    } else if([[notification name] isEqualToString:BLUETOOTH_GET_WRITE_BEEP_SUCCESS_BROADCAST_NAME]){
        
        
        
        
        
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
            [HUD hide:YES afterDelay:0];
            [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                        message:LOCALIZATION(@"text_update_server_data_fail")
                                       delegate:self
                              cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                              otherButtonTitles:nil] show];
            

            for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
            {
                if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[ChildInformationMatchingViewController class]]){
                    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
                }
            }

        }
        
    }else if ([tag isEqualToString:CHECK_BEACON]){
    
        NSData *responseData = [request responseData];
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"CHECK_BEACON ----> %@ ",responseString);
        
        
        if (responseString.length > 0) {
        
            if ([responseString isEqualToString:SERVER_RETURN_NC]) {
                [HUD hide:YES afterDelay:0];
                return;
            }else if([responseString isEqualToString:SERVER_RETURN_USED] || [responseString isEqualToString:SERVER_RETURN_WG]){
                [HUD hide:YES afterDelay:0];
                [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                            message:LOCALIZATION(@"text_device_already_binded")
                                           delegate:self
                                  cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                                  otherButtonTitles:nil] show];
            }else if(responseString.length > 100){
                return;
            }else{
                NSRange range = [responseString rangeOfString:@":"];
                NSLog(@"CHECK_BEACON ----> %lu  ",(unsigned long)range.location);
                _deviceMajor = [responseString substringWithRange:NSMakeRange(0,range.location)];
                _deviceMinor = [responseString substringWithRange:NSMakeRange(range.location + 1,responseString.length - range.location - 1)];
                NSLog(@"CHECK_BEACON ----> %@  --- %@ ",[self getMajor:self.deviceMajor],[self getMinor:self.deviceMinor]);
                
                
                [self writeMajorAndMinorThenMajor:_didSelectTargetPeripheral.identifier.UUIDString writeMajor:[self getMajor:_deviceMajor] writeMinor:[self getMinor:_deviceMinor]];
                self.targetPeripheral = _didSelectTargetPeripheral.identifier.UUIDString;
            }
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
-(void)beepCancelAction{
    _PopupBeepView.hidden = YES;
    [self findSOSDevice];
}

-(void)beepConfirmAction{
 
    NSLog(@"DATA -- > %@",_didSelectTargetAdvertisementData);
    NSString *toStringFromData = NSDataToHex([ _didSelectTargetAdvertisementData objectForKey:@"kCBAdvDataManufacturerData"]) ;
    
    NSString *getMinor = [toStringFromData substringWithRange:NSMakeRange(0,4)];
    NSString *getMajor = [toStringFromData substringWithRange:NSMakeRange(4,4)];
    
    NSLog(@"write major:%@ and minor:%@ ",getMajor,getMinor);
    NSDictionary *checkBeaconDoct = [NSDictionary dictionaryWithObjectsAndKeys:self.childId, ScanDeviceToBindingViewController_KEY_childId, self.macAddress,ScanDeviceToBindingViewController_KEY_macAddress,getMajor,ScanDeviceToBindingViewController_KEY_majors,getMinor,ScanDeviceToBindingViewController_KEY_minor,nil];
    
    [self postRequest:CHECK_BEACON RequestDictionary:checkBeaconDoct delegate:self];

    
    [HUD show:YES];
}

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
    
    [self sortPeripheralByRssi:_SOSDiscoveredPeripherals SOSDiscoveredAdvertisementData:_SOSDiscoveredAdvertisementData SOSDiscoveredRSSI:_SOSDiscoveredRSSI];
    
    
    
    CBPeripheral *peripheral=(CBPeripheral *)_SOSDiscoveredPeripherals[indexPath.row];
   _didSelectTargetAdvertisementData = (NSDictionary *)_SOSDiscoveredAdvertisementData[indexPath.row];

    

    
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
           //beacon rssi
        UILabel *RSSLlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, CGRectGetHeight(cell.frame) / 2 , 30, 30)];
        
        RSSLlabel.text = [NSString stringWithFormat:@"%@",[_SOSDiscoveredRSSI objectAtIndex:indexPath.row]];
        RSSLlabel.tag = 200;
        [RSSLlabel setTextColor:[UIColor blueColor]];
        [RSSLlabel setFont:[UIFont systemFontOfSize: 12.0]];
        [RSSLlabel setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:RSSLlabel];
        
    }
    
    //beacon name

    _tableTitleLabel.text = peripheral.name;
  
 //beacon id
    _tableCenterLabel.text = peripheral.identifier.UUIDString;
    
    
     //beacon rssi
     UILabel *RSSLlabel = (UILabel *)[cell viewWithTag:200];
     RSSLlabel.text = [NSString stringWithFormat:@"%@",[_SOSDiscoveredRSSI objectAtIndex:indexPath.row]];
    
    
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
    
    

        [self stopfindSOSDevice];
    
    
   
    
    _didSelectTargetAdvertisementData = (NSDictionary *)_SOSDiscoveredAdvertisementData[indexPath.row];
    _didSelectTargetPeripheral=(CBPeripheral *)_SOSDiscoveredPeripherals[indexPath.row];

    _beepLbl.text = [NSString stringWithFormat:@"%@ %@",_didSelectTargetPeripheral.identifier.UUIDString,LOCALIZATION(@"text_start_beep")];
    _PopupBeepView.hidden = NO;
    NSString *toStringFromData = NSDataToHex([ _didSelectTargetAdvertisementData objectForKey:@"kCBAdvDataManufacturerData"]) ;
    
    NSString *getMinor = [toStringFromData substringWithRange:NSMakeRange(0,4)];
    NSString *getMajor = [toStringFromData substringWithRange:NSMakeRange(4,4)];
    
      NSLog(@"write major:%@ and minor:%@ ",getMajor,getMinor);
    [self writeBeepMajor:getMajor minor:getMinor writeValue:@"01"];
    //if the device is right
   // if (![self.targetPeripheral isEqualToString:_didSelectTargetPeripheral.identifier.UUIDString]) {
        
              
       
        [tableView reloadData];
        
   // }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - sort

-(void)sortPeripheralByRssi:(NSMutableArray *)SOSDiscoveredPeripherals SOSDiscoveredAdvertisementData:(NSMutableArray *)SOSDiscoveredAdvertisementData SOSDiscoveredRSSI :(NSMutableArray *)SOSDiscoveredRSSI{
    int i , j;
    id  tempPeripherals,tempRSSI,tempAdvertisementData;
    NSInteger length = SOSDiscoveredPeripherals.count;
    
    for (j = 0; j < length - 1; j ++) {
        
        for (i = 0; i  < length - 1 - j; i ++) {
            
            if([SOSDiscoveredRSSI objectAtIndex:i] < [SOSDiscoveredRSSI objectAtIndex:i + 1]){
                
                // rssi
                tempRSSI = [SOSDiscoveredRSSI objectAtIndex:i];
//                [SOSDiscoveredRSSI objectAtIndex:i] = [SOSDiscoveredRSSI objectAtIndex:i + 1];

                [SOSDiscoveredRSSI replaceObjectAtIndex:i  withObject:[SOSDiscoveredRSSI objectAtIndex:i + 1]];
             //   [SOSDiscoveredRSSI objectAtIndex:i + 1] = tempRSSI;
              
                [SOSDiscoveredRSSI replaceObjectAtIndex:i + 1 withObject:tempRSSI];
                
                
                //Peripherals
                tempPeripherals = [SOSDiscoveredPeripherals objectAtIndex:i];
                [SOSDiscoveredPeripherals replaceObjectAtIndex:i  withObject:[SOSDiscoveredPeripherals objectAtIndex:i + 1]];
                [SOSDiscoveredPeripherals replaceObjectAtIndex:i + 1 withObject:tempPeripherals];
                
                
                //AdvertisementData
                tempAdvertisementData = [SOSDiscoveredAdvertisementData objectAtIndex:i];
                [SOSDiscoveredAdvertisementData replaceObjectAtIndex:i  withObject:[SOSDiscoveredAdvertisementData objectAtIndex:i + 1]];
                [SOSDiscoveredAdvertisementData replaceObjectAtIndex:i + 1 withObject:tempAdvertisementData];
                
                
            }
            
        }
        
        
    }
    
    
}

@end
