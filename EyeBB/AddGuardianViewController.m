//
//  AddGuardianViewController.m
//  EyeBB
//
//  Created by evan.Yan on 15-3-19.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "AddGuardianViewController.h"
#import <Social/Social.h>
@interface AddGuardianViewController ()
/**右按钮*/
@property(nonatomic, retain) UIBarButtonItem *rightBtnItem;
@end

@implementation AddGuardianViewController
@synthesize  rightBtnItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(settingsSelectLeftAction:)];
    
     self.navigationItem.rightBarButtonItem = self.rightBtnItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**自定义右按钮*/
-(UIBarButtonItem *)rightBtnItem{
    if (rightBtnItem==nil) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(Drive_Wdith-100, 6, 80, 32)];
        [button setBackgroundColor:[UIColor colorWithRed:0.914 green:0.267 blue:0.235 alpha:1]];
        [button setTitle:LOCALIZATION(@"btn_logout") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1.0];
        //设置按钮是否圆角
        [button.layer setMasksToBounds:YES];
        //圆角像素化
        [button.layer setCornerRadius:4.0];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button addTarget:self action:@selector(shareByActivity:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
        
    }
    return rightBtnItem;
}
#pragma mark - 点击事件

//分享
- (void)shareByActivity:(id)sender {
    NSArray *activityItems;
    
//    if (self.sharingImage != nil) {
//        activityItems = @[self.sharingText, self.sharingImage];
//    } else {
        activityItems = @[LOCALIZATION(@"text_search_guset_activity_share_msg")];
//    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

@end
