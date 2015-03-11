//
//  EyeBBHttpDelegate.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EyeBBHttpDelegate<NSObject>
- (void)requestFinished:(ASIHTTPRequest *)request;

@end
