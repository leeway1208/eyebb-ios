//
//  QRCodeViewController.m
//  zcdh
//
//  Created by evan.Yan on 14-12-11.
//
//

#import "QRCodeViewController.h"
#import "QRCodeGenerator.h"
#import "AppDelegate.h"

@interface QRCodeViewController ()
{
    AppDelegate *myDelegate;
}
@property (strong, nonatomic)  UIImageView *imageview;
@property (strong, nonatomic)  UIImageView *logoimageview;
@property (strong, nonatomic)  UILabel *EntNameLbl;
/**页底提示信息*/
@property (strong, nonatomic)  UILabel *strLbl;
@end

@implementation QRCodeViewController
@synthesize url,strLbl,logoimageview,EntNameLbl,EntLogoImg,EntName,imageview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"企业二维码";
     [[[self navigationController] navigationBar] setHidden:NO];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initialize];
    [self predictload];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark-
#pragma mark--初始化

/**初始化参数*/
-(void)initialize
{
   myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

/**控件加载*/
-(void)predictload
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu06_normal"] style:UIBarButtonItemStyleBordered target:self action:@selector(backingACtion:)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(loadACtion:)];
   
    
    logoimageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 60, 60)];
    [logoimageview setImage:EntLogoImg];
    [self.view addSubview:logoimageview];
    
    EntNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, Drive_Wdith-90, 60)];
    EntNameLbl.numberOfLines=2;
    EntNameLbl.text = EntName;
    EntNameLbl.textColor=[UIColor colorWithRed:0.561 green:0.569 blue:0.561 alpha:1];
    EntNameLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    EntNameLbl.textAlignment = UITextAlignmentLeft;
    EntNameLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:EntNameLbl];
    
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(Drive_Wdith/2-140, Drive_Height/2-140, Drive_Wdith-40, Drive_Wdith-40)];
    
	imageview.image = [QRCodeGenerator qrImageForString:url imageSize:self.imageview.bounds.size.width];
    
    [self.view addSubview:imageview];

    
    
    strLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, imageview.frame.origin.y+imageview.frame.size.height+10, Drive_Wdith-20, 30)];

    strLbl.text = @"扫一扫上面的二维码，获取信息";
    strLbl.textColor=[UIColor colorWithRed:0.561 green:0.569 blue:0.561 alpha:1];
    strLbl.font=[UIFont fontWithName:@"Helvetica" size:15];
    strLbl.textAlignment = UITextAlignmentCenter;
    strLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:strLbl];

}



#pragma mark-
#pragma mark--数据处理
#pragma mark--------------页面处理事件
/**清除页面数据*/
-(void)delViewDate
{
    [self.strLbl removeFromSuperview];
    [self.logoimageview removeFromSuperview];
    [self.EntNameLbl removeFromSuperview];
    [self.imageview removeFromSuperview];

    
    
    myDelegate=nil;
    url=nil;
    strLbl=nil;
    logoimageview=nil;
    EntNameLbl=nil;
    EntLogoImg=nil;
    EntName=nil;
    imageview=nil;
   }

#pragma mark--服务器返回信息数据处理


#pragma mark-
#pragma mark--点击事件
- (void)backingACtion:(id)sender {
//    if (isPush==0) {
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self delViewDate];
}
@end
