//
//  CustomerBluetooth.h
//  EyeBB
//
//  Created by liwei wang on 26/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CustomerBluetooth : NSObject
#define BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME @"read_battery_life"
#define BLUETOOTH_GET_SOS_DEVICE_PERIPHERAL_BROADCAST_NAME @"get_sos_device_peripheral"
#define BLUETOOTH_GET_BEEP_TIME_OUT @"beep_time_out"
#define BLUETOOTH_READ_BATTERY_TIME_OUT @"read_battery_time_out"

#define BLUETOOTH_GET_SOS_DEVICE_ADVERTISEMENT_DATA_BROADCAST_NAME @"get_sos_device_advertisementData"
#define BLUETOOTH_GET_WRITE_SUCCESS_BROADCAST_NAME @"write_success"
#define BLUETOOTH_GET_WRITE_FAIL_BROADCAST_NAME @"write_fail"
#define BLUETOOTH_SCAN_DEVICE_BROADCAST_NAME @"scan_device"
+(CustomerBluetooth *)instance;


-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue;
-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor;
-(void) writeMajorAndMinorThenMajor:(NSString *)UUID  writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor;
-(void) findSOSDevice;
-(void)stopfindSOSDevice;
NSString * NSDataToHex(NSData *data);

-(void)scanTheDevice;
-(void)stopScanTheDevice;



@end
