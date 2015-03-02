//
//  LoginViewController.m
//  EyeBB
//
//  Created by liwei wang on 2/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(LoginSelectLeftAction:)];

    [self loadWidget];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadWidget{
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)LoginSelectLeftAction:(id)sender
{
    [[self navigationController] pushViewController:nil animated:YES];
}
@end
