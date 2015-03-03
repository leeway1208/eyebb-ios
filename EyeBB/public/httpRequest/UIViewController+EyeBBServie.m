//
//  UIViewController+EyeBBServie.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "UIViewController+EyeBBServie.h"

@implementation UIViewController(EyeBBServie)
#pragma mark --
#pragma mark --- 获得网络控制器
-(HttpRequest *)HttpRequest{
    return [HttpRequest instance];
}

-(void)getRequest:(NSString *)requestStr  delegate:(id)delegate
{
    [[self HttpRequest] getRequest:requestStr delegate:self];
}

<<<<<<< Updated upstream
-(void)postRequest:(NSString *)requestStr  RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate
=======
-(void)postRequest:(NSString *)requestStr RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate
>>>>>>> Stashed changes
{
    [[self HttpRequest] postRequest:requestStr RequestDictionary:requestDictionary delegate:self];
}
@end
