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
#import "EyeBBViewController.h"
#import "ASIDownloadCache.h"
@interface HttpRequest()
@property(strong,nonatomic) NSMutableDictionary *clientDelegates;
@property (strong,nonatomic) NSString *methodStr;
@end
@implementation HttpRequest
static HttpRequest *instance;

@synthesize  clientDelegates;
#pragma mark ---
#pragma mark --- 处理业务逻辑委托
-(NSMutableDictionary *)clientDelegates{
    
    if(clientDelegates==nil){
        clientDelegates = [[NSMutableDictionary alloc] init];
    }
    
    return clientDelegates;
}
#pragma mark ---
#pragma mark ---单例实现
+(HttpRequest *)instance{
    
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        if(instance==nil){
            instance = [[self alloc] init];
        }
        
    });
    return instance;
}


-(void)getRequest:(NSString *)requestStr delegate:(id)delegate RequestDictionary:(NSDictionary *)requestDictionary
{
    self.methodStr=requestStr;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://test.eyebb.com:8089/%@",requestStr]];
    
    if (requestDictionary!=nil)
    {
        //%@=%@&
        int tempNum=0;
        for (id key in requestDictionary)
        {
            NSString *str;
            if (tempNum==0) {
                str=[NSString stringWithFormat:@"?%@=%@",key,[requestDictionary objectForKey:key]];
            }
            else
            {
                str=[NSString stringWithFormat:@"&%@=%@",key,[requestDictionary objectForKey:key]];
            }
             url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,str]];
            tempNum++;
        }
    }
    [[self clientDelegates] setObject:delegate forKey:@"0"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [ request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy ];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}


-(void)postRequest:(NSString *)requestStr RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate
{
    self.methodStr=requestStr;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://test.eyebb.com:8089/%@",requestStr]];
    [[self clientDelegates] setObject:delegate forKey:@"0"];
    
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [ request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy ];
    if ([requestDictionary count] > 0) {
        for (NSString *key in requestDictionary) {
            [request setPostValue:requestDictionary[key] forKey:key];
        }
    }
    
    
    [request setDelegate:self];
    [request startAsynchronous];
}



- (void)requestFinished:(ASIHTTPRequest *)request //delegate:(id)delegate
{
    //    EyeBBViewController *httpView = (EyeBBViewController *)delegate;
    //     NSLog(@"---%@,---%@\n",[NSString stringWithFormat:@"%@",httpView.class],httpView.nibName);
    NSString *responseString = [request responseString];
    EyeBBViewController *clientDelegate = [[self clientDelegates] objectForKey: @"0"] ;
    
    
    [clientDelegate requestFinished:request tag:self.methodStr];
    [[self clientDelegates] removeAllObjects];
    
    
    // 当以文本形式读取返回内容时用这个方法
    
    
    
    //    // 当以二进制形式读取返回内容时用这个方法
    //
    //    NSData *responseData = [request responseData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    
    NSError *error = [request error];
    
}

@end

