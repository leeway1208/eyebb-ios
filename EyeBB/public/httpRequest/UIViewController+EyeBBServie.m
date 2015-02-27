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

-(void)getRequest:(id)delegate
{
    [[self HttpRequest] getRequest:self];
}
@end
