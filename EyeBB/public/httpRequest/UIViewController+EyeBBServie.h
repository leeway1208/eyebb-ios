//
//  UIViewController+EyeBBServie.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EyeBBViewController.h"

@interface UIViewController(EyeBBServie)
-(void)getRequest:(NSString *)requestStr  delegate:(id)delegate;
-(void)postRequest:(NSString *)requestStr RequestArray:(NSArray *)requestArray delegate:(id)delegate;
@end
