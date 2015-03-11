//
//  UIViewController+EyeBBDB.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(EyeBBDB)
-(NSMutableArray *)allOrganization;

#pragma mark--
#pragma mark --保存儿童信息
-(void)SaveChildren:(NSArray *)childrenArray;
@end
