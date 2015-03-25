//
//  ScanDeviceToBindingViewController.m
//  EyeBB
//
//  Created by liwei wang on 25/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "ScanDeviceToBindingViewController.h"
#import "RootViewController.h"

@interface ScanDeviceToBindingViewController ()

@end

@implementation ScanDeviceToBindingViewController
#pragma mark - view load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"navi_btn_back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(scanDeviceViewLeftAction:)];
    
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.title = LOCALIZATION(@"text_search_your_device");
    
    [self loadParameter];
    [self loadWidget];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

// gesture to cancel swipe (use for ios 8)
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]){
        return  NO;
        
    }else{
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWidget{
    
}


-(void)loadParameter{
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - button aciton
-(void)scanDeviceViewLeftAction:(id)sender
{
    
    for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
    {
        if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[RootViewController class]]){
            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
        }
    }
    
    
    
}

@end
