//
//  ScanDeviceToBindingViewController.h
//  EyeBB
//
//  Created by liwei wang on 25/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//


#import "EyeBBViewController.h"

@interface ScanDeviceToBindingViewController : EyeBBViewController
/* device major */
@property (strong,nonatomic) NSString *devicMajor;
/* device minor */
@property (strong,nonatomic) NSString *devicMinor;
/* child id */
@property (strong,nonatomic) NSString *childId;
/* mac address  */
@property (strong,nonatomic) NSString *macAddress;
/* guardian Id  */
@property (strong,nonatomic) NSString *guardianId;
@end
