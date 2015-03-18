//
//  WebViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-3-18.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
//web内容页
@property (strong, nonatomic)  UIWebView *webView;
@end

@implementation WebViewController
@synthesize urlStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self iv];
    [self lc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - 初始化页面元素

/**
 *初始化参数
 */
-(void)iv
{

}

/**
 *加载控件
 */
-(void)lc
{
self.navigationController.interactivePopGestureRecognizer.enabled = NO;
      self.navigationController.navigationBarHidden = NO;
     self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor blackColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height-64)];
  

    [_webView setDelegate:self];
    [self.view addSubview: self.webView];
    [self loadWebPageWithString:urlStr];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    @try {
        NSLog(@"urlString is： %@",urlString);
        NSURL *url =[NSURL URLWithString:urlString];
        NSLog(@"url is： %@",urlString);
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma mark-
#pragma mark--页面执行
/**开始加载的时候执行该方法*/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开启加载
    [HUD show:YES];
}
/**加载完成的时候执行该方法*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //关闭加载
    [HUD hide:YES afterDelay:0];
}
/**加载出错的时候执行该方法*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //关闭加载
    [HUD hide:YES afterDelay:0];
}

/**清除页面数据*/
-(void)delViewDate
{
//    [self.webView removeFromSuperview];
//    [self.gifView removeFromSuperview];
//    
//    myDelegate=nil;
//    self.urlStr=nil;
//    self.myTitle=nil;
//    self.webView=nil;
//    self.gifView=nil;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked&&isPush==4)
//    {
//        
//        [self dismissModalViewControllerAnimated:YES];
//        
//        [self delViewDate];
//        return NO;
//    }
    return YES;
}
#pragma mark --
#pragma mark --点击事件
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
