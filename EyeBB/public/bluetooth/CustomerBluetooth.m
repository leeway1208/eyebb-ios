//
//  CustomerBluetooth.m
//  EyeBB
//
//  Created by liwei wang on 26/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "CustomerBluetooth.h"


@interface CustomerBluetooth()
@property (strong,nonatomic) CBCentralManager *central;
@property (copy,nonatomic) NSString *targetPeripheral;
@property (strong,nonatomic) NSMutableArray *discoveredPeripherals;
@property (strong,nonatomic) NSMutableArray *checkDiscoveredPeripherals;
@property (strong,nonatomic) NSMutableArray *SOSDiscoveredPeripherals;
@property (strong,nonatomic) NSMutableDictionary *discoveredPeripheralsDic;
@property (strong,nonatomic) NSMutableArray *discoveredPeripheralsRssi;
@property (strong,nonatomic) NSArray * noDuplicates;
/* timer to refresh the table view */
@property (strong,nonatomic) NSTimer *refreshTableTimer;
@property (strong,nonatomic) CBPeripheral *connectedPeripheral;
@property (strong,nonatomic) CBUUID *service2000;
@property (strong,nonatomic) CBUUID *service1000;
@property (strong,nonatomic) NSString *targetMajorAndMinorPeripheral;
@property (strong,nonatomic) NSString *targetUUIDPeripheral;
@property (strong,nonatomic) NSString *targetBatteryLifePeripheral;
@property (strong,nonatomic) NSString *writeValue1;
@property (strong,nonatomic) NSString *writeValue2;


@property(strong,nonatomic) NSMutableDictionary *clientDelegates;
@end

@implementation CustomerBluetooth

static CustomerBluetooth *instance;
@synthesize  clientDelegates;

double timerInterval = 5.0f;
NSInteger *tableNumberConut;
Boolean setPassword = false;
Boolean isBeep = false;
Boolean isReadBattery = false;
Boolean isMajor = false;
Boolean isMinor = false;
Boolean isSOSDevice = false;
Boolean startTimerOnce = true;

#pragma mark --- 处理业务逻辑委托
-(NSMutableDictionary *)clientDelegates{
    
    if(clientDelegates==nil){
        clientDelegates = [[NSMutableDictionary alloc] init];
    }
    
    return clientDelegates;
}

#pragma mark ---单例实现
+(CustomerBluetooth *)instance{
    
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        if(instance == nil){
            instance = [[self alloc] init];
        }
        
    });
    return instance;
}

#pragma mark - timer methods

- (NSTimer *) timer {
    if (!_refreshTableTimer) {
        _refreshTableTimer = [NSTimer timerWithTimeInterval:timerInterval target:self selector:@selector(timerRefreshTableSelector:) userInfo:nil repeats:YES];
    }
    return _refreshTableTimer;
}

-(void) startTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    NSLog(@"timer start...");
}


- (void) stopTimer{
    if (self.refreshTableTimer != nil){
        [self.refreshTableTimer invalidate];
        self.refreshTableTimer = nil;
        NSLog(@"timer stop...");
    }
}

- (void)timerRefreshTableSelector:(NSTimer*)timer{
    
    if(isSOSDevice){
        //post get sos device broadcast
        [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH_GET_SOS_DEVICE_BROADCAST_NAME object:self.SOSDiscoveredPeripherals];
        NSLog(@"timerRefreshTableSelector --- > %lu",(unsigned long)self.SOSDiscoveredPeripherals.count);

        
    }
  
}


#pragma mark - CBCentralManager Delegate methods
/*
 * Invoked whenever the central manager's state is updated.
 */
-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    // [[self clientDelegates] setObject:delegate forKey:@"0"];
    NSString * state = nil;
    
    switch (central.state) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"work";
            [self startScan];
            break;
        case CBCentralManagerStateUnknown:
            state = @"State Unknown";
            break;
        default:
            break;
            
            
    }
    
    NSLog(@"Central manager state: %@", state);
}

/**
 *  step two
 *
 *  @param central           <#central description#>
 *  @param peripheral        <#peripheral description#>
 *  @param advertisementData <#advertisementData description#>
 *  @param RSSI              <#RSSI description#>
 */

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    //    NSLog(@"Discovered peripheral %@ (%@) ---->RSSI : %@",peripheral.name,peripheral.identifier.UUIDString,RSSI);
    
    if(advertisementData != nil){
        NSString *toStringFromData = NSDataToHex([ advertisementData objectForKey:@"kCBAdvDataManufacturerData"]) ;
        if(toStringFromData.length > 0){
            NSString *getMajorAndMinor = [toStringFromData substringWithRange:NSMakeRange(0,8)];
            //NSLog(@"MAJOR AND MINOR ---> %@",toStringFromData);
            
            if (isSOSDevice) {
                self.targetBatteryLifePeripheral = [toStringFromData substringWithRange:NSMakeRange(10,2)];
                if(startTimerOnce){
                    [self startTimer];
                    startTimerOnce = false;
                }
               
                //NSLog(@"BATTERY LIFE ---> %@",self.targetBatteryLifePeripheral);
                if ([self.targetBatteryLifePeripheral isEqualToString:@"01"]) {
                    //[self stopScan];
                    //NSLog(@"BATTERY LIFE ---> %@",self.targetBatteryLifePeripheral);
                    
                    if(![self.SOSDiscoveredPeripherals containsObject:peripheral]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.SOSDiscoveredPeripherals addObject:peripheral];
                            
                           
                        });
                    }
                }
                
                
            }else if([getMajorAndMinor isEqualToString:self.targetMajorAndMinorPeripheral] || [peripheral.identifier.UUIDString isEqualToString:_targetUUIDPeripheral] ) {
                
                if (isReadBattery) {
                    //stop scan
                    [self stopScan];
                    //stop read battery life
                    isReadBattery = false;
                    
                    self.targetBatteryLifePeripheral = [toStringFromData substringWithRange:NSMakeRange(8,2)];
                    
                    //let hex string to integer
                    NSLog(@"BATTERY LIFE ---> %ld", strtol( [self.targetBatteryLifePeripheral UTF8String], NULL, 16) );
                    
                    
                    NSNumber *longNumber = [NSNumber numberWithLong: strtol( [self.targetBatteryLifePeripheral UTF8String], NULL, 16) ];
                    NSString * longToNsstring = [longNumber stringValue];
                    
                    //post battery life broadcast
                    [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME object:longToNsstring];
                    
                }else{
                    //connect to the peripheral device
                    if (isBeep||isMajor) {
                        [self.central connectPeripheral:peripheral options:nil];
                    }
                    
                    
                }
                
            }
        }
    }
    
    [self.discoveredPeripherals addObject:peripheral];
    [self.discoveredPeripheralsDic setObject:RSSI forKey:peripheral.identifier.UUIDString];
    
    //NSLog(@"Tick... %lu",(unsigned long)self.discoveredPeripherals.count);
    
    
}



/**
 *  when peripheral device already connect to the iphone
 *
 *  @param central    <#central description#>
 *  @param peripheral <#peripheral description#>
 */
-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.connectedPeripheral=peripheral;
    NSLog(@"Connected to %@(%@)",peripheral.name,peripheral.identifier.UUIDString);
    peripheral.delegate = self;
    
    [self stopScan];
    
    //[peripheral discoverServices:@[firstServiceUUID, secondServiceUUID]];
    //[peripheral discoverServices:@[self.service2000]];
    [peripheral discoverServices:nil];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Disconnected from peripheral");
    
    if(isMajor){
        [self.central connectPeripheral:_targetUUIDPeripheral options:nil];
    }
    
    if ([self.targetPeripheral isEqualToString:peripheral.identifier.UUIDString]) {
        NSLog(@"Retrying");
        [self.central connectPeripheral:peripheral options:nil];
    }
}

#pragma mark - CBPeripheralManager delegate methods
/**
 *  get the services from the beacon
 *
 *  @param peripheral <#peripheral description#>
 *  @param error      <#error description#>
 */
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        //NSLog(@"Discovered service %@",service.description);
        NSLog(@"Discovered service %@",service.UUID);
        //set device password
        if(!setPassword){
            if ([service.UUID isEqual:self.service2000]) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }else{
            if ([service.UUID isEqual:self.service1000]) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

/**
 *  when you find the services from beacon, you can do there.
 *
 *  @param peripheral <#peripheral description#>
 *  @param service    <#service description#>
 *  @param error      <#error description#>
 */
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    // when there occurs the error
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    
    for (CBCharacteristic *characteristic in service.characteristics ) {
        NSLog(@"Discovered characteristic %@(%@)",characteristic.description,characteristic.UUID.UUIDString);
        if(!setPassword){
            if ([characteristic.UUID.UUIDString isEqualToString:@"2005"]) {
                //[peripheral readValueForCharacteristic:characteristic];
                //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
                [peripheral writeValue:[self stringToByte:@"C3A60D00"]forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                
            }
        }else{
            if (isBeep) {
                if ([characteristic.UUID.UUIDString isEqualToString:@"1001"]) {
                    //[peripheral readValueForCharacteristic:characteristic];
                    //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral writeValue:[self stringToByte:self.writeValue1]forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }else if (isMajor){
                if ([characteristic.UUID.UUIDString isEqualToString:@"1008"]) {
                    //[peripheral readValueForCharacteristic:characteristic];
                    //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral writeValue:[self stringToByte:self.writeValue1]forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
                
            }else if(isMinor){
                if ([characteristic.UUID.UUIDString isEqualToString:@"1009"]) {
                    //[peripheral readValueForCharacteristic:characteristic];
                    //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral writeValue:[self stringToByte:self.writeValue2]forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
                
            }
            
        }
        
    }
}

/**
 *  when read the data from the didDiscoverCharacteristicsForService. this method will be updated.
 *
 *  @param peripheral     <#peripheral description#>
 *  @param characteristic <#characteristic description#>
 *  @param error          <#error description#>
 */
-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2005"]])
    {
        if( (characteristic.value)  || !error )
        {
            NSLog(@"didDiscoverCharacteristicsForService --- > %@", characteristic.value);
            
        }
    }
    
    //NSString *manf=[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSString *manf = NSDataToHex(characteristic.value);
    NSLog(@"didDiscoverCharacteristicsForService --- > %@", manf);
    
    
    
}

/**
 *  write response
 *
 *  @param peripheral     <#peripheral description#>
 *  @param characteristic <#characteristic description#>
 *  @param error          <#error description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME object:self.SOSDiscoveredPeripherals];
    }
    NSLog(@"write successfully !!! ");
    
    
    if (setPassword) {
        if (isBeep) {
            isBeep = false;
            //post get sos device broadcast
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME object:self.SOSDiscoveredPeripherals];
        }else if (isMajor){
            isMajor = false;
            [peripheral discoverServices:nil];
        }else if (isMinor){
            isMinor = false;
            //post get sos device broadcast
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME object:self.SOSDiscoveredPeripherals];
        }
        
    }else{
        setPassword = true;
        [peripheral discoverServices:nil];
    }
    
    
}

#pragma mark - hex data to string
static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}

NSString * NSDataToHex(NSData *data) {
    NSUInteger i, len;
    unsigned char *buf, *bytes;
    
    len = data.length;
    bytes = data.bytes;
    buf = malloc(len*2);
    
    for (i=0; i<len; i++) {
        buf[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len*2
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
}


#pragma mark - hex string to data
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}



#pragma mark - scan mothods
/**
 *  step one
 */
-(void) startScan {
    NSLog(@"Starting scan");
    
    // scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFE0"]]  (make your own device)
    //CBCentralManagerOptionRestoreIdentifierKey :@YES @{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES}
    [self.central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO ,CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
}

-(void) stopScan{
    NSLog(@"Stop scan");
    
    [self.central stopScan];
}

#pragma mark - disconnect mothods
-(void) disConnect:(CBPeripheral *) peripheral{
    [self.central cancelPeripheralConnection:peripheral];
}


#pragma mark - write functions

-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue {
    //initial data
    isBeep = true;
    self.writeValue1 = writeValue;
    
    [self initData:major minor:minor];
    [self startScan];
    
}





-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor{
    NSLog(@"NAME --- > %@" , [notification name] );
    
    isReadBattery = true;
    [self initData:major minor:minor];
    [self startScan];
    
    
}


-(void) writeMajorAndMinorThenMajor:(NSString *)UUID writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor{
    //initial data
    isMajor = true;
    isMinor = true;
    isSOSDevice = false;
    self.writeValue1 = writeMajor;
    self.writeValue2 = writeMinor;
    
    _targetUUIDPeripheral = UUID;
    [self initData:@"" minor:@""];
    
    [self startScan];
    
}

-(void) findSOSDevice{
    
    isSOSDevice = true;

    [self initData:@"" minor:@""];
    
    [self startScan];
    
}

#pragma mark - initial data

-(void) initData:(NSString *) major minor:(NSString*)minor{
    self.targetMajorAndMinorPeripheral = [NSString stringWithFormat:@"%@%@",minor,major];
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
    self.discoveredPeripherals = [NSMutableArray new];
    self.discoveredPeripheralsRssi = [NSMutableArray new];
    self.discoveredPeripheralsDic = [NSMutableDictionary new];
    self.checkDiscoveredPeripherals = [NSMutableArray new];
    self.SOSDiscoveredPeripherals = [NSMutableArray new];
    
    self.service2000 = [CBUUID UUIDWithString:@"0x2000"];
    self.service1000 = [CBUUID UUIDWithString:@"0x1000"];
}

@end
