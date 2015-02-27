//
//  EyeBBHttpViewController.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


#import "EyeBBHttpDelegate.h"
#import "HttpRequest.h"
#import "UIViewController+EyeBBServie.h"
@interface EyeBBHttpViewController : UIViewController
@property(nonatomic, retain)HttpRequest *httpRequest;
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end
