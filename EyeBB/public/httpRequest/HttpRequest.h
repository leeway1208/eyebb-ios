//
//  HttpRequest.h
//  EyeBB
//
//  Created by Evan on 15/2/26.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+(HttpRequest *)instance;


-(void)getRequest:(NSString *)requestStr  delegate:(id)delegate;


-(void)postRequest:(NSString *)requestStr RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate;

@end
