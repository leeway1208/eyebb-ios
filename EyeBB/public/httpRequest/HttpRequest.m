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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVER_URL"%@",requestStr]];
    
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
    [[self clientDelegates] setObject:delegate forKey:self.methodStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [ request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy ];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setTimeOutSeconds:10];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
   
    //[request failWithError:ASIRequestTimedOutError];
    [request startAsynchronous];
    
}


-(void)postRequest:(NSString *)requestStr RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate
{

    
    self.methodStr=requestStr;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVER_URL"%@",requestStr]];
    [[self clientDelegates] setObject:delegate forKey:self.methodStr];

    NSLog(@"self.methodStr 1 = %@",self.methodStr);

    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [ request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy ];
    if ([requestDictionary count] > 0) {
        for (NSString *key in requestDictionary) {
            [request setPostValue:requestDictionary[key] forKey:key];
        }
    }
    
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}



- (void)requestFinished:(ASIHTTPRequest *)request //delegate:(id)delegate
{
    //    EyeBBViewController *httpView = (EyeBBViewController *)delegate;
    //     NSLog(@"---%@,---%@\n",[NSString stringWithFormat:@"%@",httpView.class],httpView.nibName);
    NSString *responseString = [request responseString];

    EyeBBViewController *clientDelegate = [[self clientDelegates] objectForKey: self.methodStr];
    
    [[self clientDelegates] removeObjectForKey:self.methodStr];
    [clientDelegate requestFinished:request tag:self.methodStr];

    
    // 当以文本形式读取返回内容时用这个方法
    
    
    
    //    // 当以二进制形式读取返回内容时用这个方法
    //
    //    NSData *responseData = [request responseData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    NSString *responseString = [request responseString];
    EyeBBViewController *clientDelegate = [[self clientDelegates] objectForKey: self.methodStr];
    
    [[self clientDelegates] removeObjectForKey:self.methodStr];
    [clientDelegate requestFinished:request tag:self.methodStr];
//    NSString *message = NULL;
//    
//    NSError *error = [request error];
//    switch ([error code])
//    {
//        case ASIRequestTimedOutErrorType:
//            message = @"AASDSADSADAS";
//            break;
//        case ASIConnectionFailureErrorType:
//            message = @"AASDSADSADAddd ddS";
//            break;
//            
//    }
//    
//    NSLog(@"------> %@",message);
//    
}


@end

