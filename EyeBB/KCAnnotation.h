//
//  KCAnnotation.h
//  eyebb
//
//  Created by liwei wang on 19/5/15.
//  Copyright (c) 2015 eyebb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KCAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end