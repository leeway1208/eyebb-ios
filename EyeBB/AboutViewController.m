//
//  AboutViewController.m
//  EyeBB
//
//  Created by liwei wang on 9/4/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import "AboutViewController.h"
#import "SettingsViewController.h"
@interface AboutViewController ()
/* logo */
@property (nonatomic,strong) UIImageView* logoImg;
/* version label*/
@property (nonatomic,strong) UILabel* versionLbl;
/* web */
@property (nonatomic,strong) UILabel* webLbl;
/* introduction */
@property (nonatomic,strong) UILabel* introductionLbl;

@property (nonatomic,strong) NSString *version;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];

    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];

     [self loadWidget];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    
    
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_logoImg removeFromSuperview];
    [_versionLbl removeFromSuperview];
    [_webLbl removeFromSuperview];
    [_introductionLbl removeFromSuperview];
    
    [self.view removeFromSuperview];
    [self setLogoImg:nil];
    [self setVersionLbl:nil];
    [self setWebLbl:nil];
    [self setIntroductionLbl:nil];

    [self setView:nil];
    [super viewDidDisappear:animated];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// gesture to cancel swipe (use for ios 8)
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]){
        return  NO;
        
    }else{
        return YES;
    }
}




-(void)loadWidget{
    _logoImg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_cht"]];
    _logoImg.frame = CGRectMake(Drive_Wdith / 2 - 75, Drive_Height /2 - 240, 150, 150);
    [self.view addSubview:_logoImg];
    
    

    //version
    _versionLbl =[[UILabel alloc]initWithFrame:CGRectMake(0,  Drive_Height /2 - 240 + 150 + 30, self.view.frame.size.width, 20)];
    [_versionLbl setText:[NSString stringWithFormat:@"%@  %@", LOCALIZATION(@"text_version"), [self getAppVersion] ]];
    
    [_versionLbl setFont:[UIFont systemFontOfSize: 12.0]];
    [_versionLbl setTextColor:[UIColor blackColor]];
    [_versionLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_versionLbl];
    
    
    //web
    _webLbl =[[UILabel alloc]initWithFrame:CGRectMake(0,  Drive_Height /2 - 240 + 150 + 30 + 20, self.view.frame.size.width, 20)];
    //[CopyrightLbl setText:LOCALIZATION(@"text_policy")];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:LOCALIZATION(@"text_http")];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _webLbl.attributedText = content;
    [_webLbl setFont:[UIFont systemFontOfSize: 12.0]];
    [_webLbl setTextColor:[UIColor blackColor]];
    [_webLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_webLbl];
    
    
    //introductionLbl
    _introductionLbl =[[UILabel alloc]initWithFrame:CGRectMake(10,  Drive_Height /2 - 240 + 150 + 30 + 40, self.view.frame.size.width - 20, 220)];
    [_introductionLbl setText:LOCALIZATION(@"text_about_details")];
    
    [_introductionLbl setFont:[UIFont systemFontOfSize: 15.0]];
    [_introductionLbl setTextColor:[UIColor blackColor]];
    _introductionLbl.numberOfLines = 8;
    [_introductionLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_introductionLbl];
    

    
}

@end
