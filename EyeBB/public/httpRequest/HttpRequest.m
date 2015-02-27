//
//  HttpRequest.m
//  EyeBB
//
//  Created by Evan on 15/2/26.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "EyeBBHttpViewController.h"
@interface HttpRequest()
@property(nonatomic, retain) NSMutableDictionary *clientDelegates;
@end
@implementation HttpRequest
static HttpRequest *instance;

@synthesize  clientDelegates;
#pragma mark ---
#pragma mark --- 处理业务逻辑委托
-(NSMutableDictionary *)clientDelegates{
    NSLog(@"--------------3------------------");
    if(clientDelegates==nil){
        clientDelegates = [[NSMutableDictionary alloc] init];
    }
    
    return clientDelegates;
}
#pragma mark ---
#pragma mark ---单例实现
+(HttpRequest *)instance{
    NSLog(@"--------------2------------------");
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        if(instance==nil){
            instance = [[self alloc] init];
        }
        
    });
    return instance;
}


-(void)getRequest:(id)delegate
{
    
//    EyeBBHttpViewController *clientDelegate = [[self clientDelegates] objectForKey: [NSString stringWithFormat:@"%d",0]];
    
     [[self clientDelegates] setValue:delegate forKey:@"0"];
NSURL *url = [NSURL URLWithString:@"http://test.eyebb.com:8089/kindergartenList"];


ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

[request setDelegate:self];

[request startAsynchronous];

}

-(void)postRequest
{
    
    NSURL *url = [NSURL URLWithString:@"http://test.eyebb.com:8089/"];
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:appraiseTextField.text forKey:@"app"];
//    [request setPostValue:numberTextField.text   forKey:@"count"];
//    [request setPostValue:goodsTextField.text    forKey:@"name"];
//    [request setPostValue:priceTextField.text    forKey:@"price"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request

{
    EyeBBHttpViewController *clientDelegate = [[self clientDelegates] objectForKey: @"0"];
    
    [clientDelegate requestFinished:request];
    // 当以文本形式读取返回内容时用这个方法
   
    NSString *responseString = [request responseString];
    
    //    // 当以二进制形式读取返回内容时用这个方法
    //
    //    NSData *responseData = [request responseData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    
    NSError *error = [request error];
    
}

@end
