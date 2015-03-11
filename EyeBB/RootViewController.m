
//
//  RootViewController.m
//  NewProject
//
// Created by evan.Yan on 14-10-13.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
@interface RootViewController ()
{
     AppDelegate *myDelegate;
}
/**0为打开二维码扫描器，1为返回，2为跳转*/
@property (nonatomic) NSInteger  OperationType;
@property (nonatomic,strong)NSString *url;


@end

@implementation RootViewController

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
    self.OperationType=0;
    myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.365 green:0.365 blue:0.365 alpha:1]];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
  }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   

    
//    if (self.OperationType==1) {
//        [self dismissModalViewControllerAnimated:YES];
//    }
    if (self.OperationType==2) {
        NSArray *strArray=[self.url componentsSeparatedByString:@"/"];
        @try {
            if(strArray.count<5)
            {
               
                self.OperationType=0;
            }
            else
            {
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
           }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.OperationType==0) {
    [self scanBtnAction];
    }
    else  if (self.OperationType==1) {
        [self dismissModalViewControllerAnimated:YES];
    }
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    UIButton * scanButton = (UIButton *)[self.view viewWithTag:200];
//    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//}
-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     self.OperationType=1;
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
   
//    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.OperationType=2;
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //初始化
    ZBarReaderController * read = [ZBarReaderController new];
    //设置代理
    read.readerDelegate = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    for (symbol in results)
    {
        break;
    }
    NSString * result;
    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
        
    {
        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = symbol.data;
    }
    
    self.url=result;
    
    NSLog(@"result is %@",result);

    
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--数据处理

@end
