//
//  UIViewController+EyebbBluetooth.h
//  EyeBB
//
//  Created by liwei wang on 24/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface UIViewController(EyebbBluetooth)
#define BLUETOOTH_READ_BATTERY_LIFE_BROADCAST_NAME @"read_battery_life"

-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue;
-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor;
-(void) writeMajorAndMinorThenMajor:(NSString *)major minor:(NSString *)minor writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor;

@end
