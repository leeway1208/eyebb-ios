//
//  UIViewController+EyebbBluetooth.m
//  EyeBB
//
//  Created by liwei wang on 24/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "UIViewController+EyebbBluetooth.h"


@implementation UIViewController(EyebbBluetooth)
-(CustomerBluetooth *)BluetoothRequest{
    return [CustomerBluetooth instance];
}



-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue{
    [[self BluetoothRequest]writeBeepMajor:major minor:minor writeValue:writeValue];
}

-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor{
    [[self BluetoothRequest] readBattery:notification major:major minor:minor];
}

-(void) writeMajorAndMinorThenMajor:(NSString *)UUID  writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor{
    
    [[self BluetoothRequest] writeMajorAndMinorThenMajor:UUID writeMajor:writeMajor writeMinor:writeMinor];
    
}


-(void)scanTheDevice{
    [[self BluetoothRequest] scanTheDevice];
}

-(void)stopScanTheDevice{
    [[self BluetoothRequest] stopScanTheDevice];

}

-(void) findSOSDevice{
    [[self BluetoothRequest] findSOSDevice ];
}
-(void)stopfindSOSDevice{
    [[self BluetoothRequest] stopfindSOSDevice ];
}



-(void)antiLostService:(NSMutableArray * )antiLostDeviceAy NameAy:(NSMutableArray * )nameAy{
    [[self BluetoothRequest] antiLostService:(NSMutableArray * )antiLostDeviceAy NameAy:(NSMutableArray * )nameAy ];

    
}
-(void) writeToResetAntiMajor:(NSString *)major minor:(NSString *)minor{
    
      [[self BluetoothRequest] writeToResetAntiMajor:(NSString *)major minor:(NSString *)minor];
    
}

-(void)stopAntiLostService{
     [[self BluetoothRequest] stopAntiLostService ];
}

@end
