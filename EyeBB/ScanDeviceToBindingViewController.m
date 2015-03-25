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
/**introdaction label*/
@property (nonatomic,strong) UILabel* introLabel;

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
    
    _introLabel = [[UILabel alloc]init];
    _introLabel.frame = CGRectMake(10, 20, Drive_Wdith - 10, 30);
    _introLabel.text = LOCALIZATION(@"text_press_the_button_on_the_device");
    _introLabel.textAlignment = NSTextAlignmentCenter;
    _introLabel.numberOfLines = 2;
}


-(void)loadParameter{
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [_introLabel removeFromSuperview];

    [self.view removeFromSuperview];

    [self setIntroLabel:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
}

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
