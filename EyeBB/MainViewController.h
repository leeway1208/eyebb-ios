//
//  MainViewController.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-24.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


#import "EyeBBViewController.h"
#import <CoreLocation/CoreLocation.h> 

@interface MainViewController : EyeBBViewController<CLLocationManagerDelegate>



@property BOOL antiLostConfirm;
@end
