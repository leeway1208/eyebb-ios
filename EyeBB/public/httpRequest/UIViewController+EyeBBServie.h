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
-(void)getRequest:(NSString *)resquestStr  delegate:(id)delegate;
@end
