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

-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue;
-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor;
-(void) writeMajorAndMinorMajor:(NSString *)major minor:(NSString *)minor writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor;

@end
