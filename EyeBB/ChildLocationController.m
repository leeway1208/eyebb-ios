//
//  ChildLocationController.m
//  eyebb
//
//  Created by liwei wang on 19/5/15.
//  Copyright (c) 2015 eyebb. All rights reserved.
//

#import "ChildLocationController.h"
#import "MainViewController.h"
#import "KCAnnotation.h"

@interface ChildLocationController()<MKMapViewDelegate>{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

@property (strong,nonatomic) NSMutableArray * gpsLocationListAy;
@property (strong,nonatomic) NSMutableArray * connectKidsByScanedAy;
@property (strong,nonatomic) NSMutableArray * connectKidsByScanedT;
@end


@implementation ChildLocationController 
#pragma mark - 原生方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    // Do any additional setup after loading the view.
    //    self.navigationController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"navi_btn_back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(regViewLeftAction:)];
    [newBackButton setBackgroundImage:[UIImage
                                       imageNamed: @"navi_btn_back.png"]forState:UIControlStateSelected  barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.title = LOCALIZATION(@"btn_map");
    
    
    
    [self loadParameter];
    [self loadWidget];
}

-(void)loadParameter{
    
    _gpsLocationListAy = [NSMutableArray new];
    
    NSLog(@"childid -> %@ ",_childId);
    
    NSDictionary *tempDoct = [NSDictionary dictionaryWithObjectsAndKeys:_childId, @"childId", @"6" ,@"hoursBefore",nil];
    
    [self postRequest:GET_LOCATION_BEAN RequestDictionary:tempDoct delegate:self];
    
}


-(void)loadWidget{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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

-(void)viewDidDisappear:(BOOL)animated
{
    //[_regTView removeFromSuperview];

    [self.view removeFromSuperview];
    //[self setRegTView:nil];
    [self setView:nil];
    [super viewDidDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - addAnnotation
-(void)addAnnotation{
    NSDictionary *tempDoc =  [NSDictionary dictionary];
    for (int i = 0; i < _gpsLocationListAy.count; i ++) {
        tempDoc = [_gpsLocationListAy objectAtIndex:i];
        
        float latitude = [[NSString stringWithFormat:@"%@",[tempDoc objectForKey:@"latitude"]] floatValue];
        float longitude = [[NSString stringWithFormat:@"%@",[tempDoc objectForKey:@"longitude"]] floatValue];
        float radius = [[NSString stringWithFormat:@"%@",[tempDoc objectForKey:@"radius"]] floatValue];
        NSLog(@"latitude %f  longitude %f",latitude,longitude);
        CLLocationCoordinate2D locations = CLLocationCoordinate2DMake(latitude, longitude);
        KCAnnotation *annotations=[[KCAnnotation alloc]init];
        annotations.title= _childName;
        annotations.subtitle=@"Hi !";
        annotations.coordinate=locations;
        
        // Add an overlay
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:locations radius:radius];
        [_mapView addOverlay:circle];
        
        [_mapView addAnnotation:annotations];
     
    }

    

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:[UIColor redColor]];
    [circleView setStrokeColor:[UIColor blackColor]];
    [circleView setAlpha:0.3f];
    return circleView;
}

#pragma mark - button action
-(void)regViewLeftAction:(id)sender
{
    
    for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
    {
        if([[self.navigationController.viewControllers objectAtIndex: i] isKindOfClass:[MainViewController class]]){
            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:i] animated:YES];
        }
    }
    
    
    
}


#pragma mark - server request
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag{
    //关闭加载
    
    if ([tag isEqualToString:GET_LOCATION_BEAN]) {
        NSData *responseData = [request responseData];
        NSString * resGET_LOCATION_BEAN = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"GET_LOCATION_BEAN %@",resGET_LOCATION_BEAN);
        
        _gpsLocationListAy = [[[responseData mutableObjectFromJSONData] objectForKey:@"gpsLocationList"] mutableCopy];
        
        [self addAnnotation];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag
{
    NSString *responseString = [request responseString];
    //关闭加载
    [HUD hide:YES afterDelay:0];
    
    [[[UIAlertView alloc] initWithTitle:LOCALIZATION(@"text_tips")
                                message:LOCALIZATION(@"text_network_error")
                               delegate:self
                      cancelButtonTitle:LOCALIZATION(@"btn_confirm")
                      otherButtonTitles:nil] show];
}
@end
