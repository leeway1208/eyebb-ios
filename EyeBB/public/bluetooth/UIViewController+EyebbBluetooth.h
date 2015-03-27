//
//  UIViewController+EyebbBluetooth.h
//  EyeBB
//
//  Created by liwei wang on 24/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EyeBBViewController.h"
@interface UIViewController(EyebbBluetooth)

-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue;
-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor;
-(void) writeMajorAndMinorThenMajor:(NSString *)UUID writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor;
-(void) findSOSDevice;


-(void) startScan;
-(void) stopScan;



@end
