//
//  ChildLocationController.h
//  eyebb
//
//  Created by liwei wang on 19/5/15.
//  Copyright (c) 2015 eyebb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EyeBBViewController.h"


@interface ChildLocationController : EyeBBViewController
@property (strong,nonatomic) NSString* childId;
@property (strong,nonatomic) NSString* childName;

@end
