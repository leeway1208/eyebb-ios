//
//  EyeBBViewController.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//


#import "EyeBBHttpDelegate.h"
#import "HttpRequest.h"
#import "HttpRequestUtils.h"
#import "JSONKit.h"
//加载状态
#import "MBProgressHUD.h"
//访问服务器
#import "UIViewController+EyeBBServie.h"
//访问本地数据库
#import "UIViewController+EyeBBDB.h"
//公用方法
#import "ViewController+EyebbPublic.h"
#import "HttpRequestUtils.h"
//bluetooth
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIViewController+EyebbBluetooth.h"
#import "CustomerBluetooth.h"
#import "UserDefaultsUtils.h"

@interface EyeBBViewController : UIViewController<MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic, retain)HttpRequest *httpRequest;
- (void)requestFinished:(ASIHTTPRequest *)request tag:(NSString *)tag;
- (void)requestFailed:(ASIHTTPRequest *)request tag:(NSString *)tag;
/**
 *  set user languages
 *
 *  @param language language (1 is Chinese, 2 is Cantonese, default is English)
 */
-(void)setUserLanguge:(int)language;
- (NSString *)getCurrentSystemLanguage;
- (NSString *)getCurrentAppLanguage;

CGFloat getLableTextWidth(UILabel * label,CGFloat textSize);


//bluetooth test

@property(nonatomic, retain)CustomerBluetooth *CustomerBluetoothRequest;
-(void) writeBeepMajor:(NSString *)major minor:(NSString *)minor writeValue:(NSString *)writeValue;
-(void) readBattery:(NSNotification *)notification major:(NSString *)major minor:(NSString *)minor;
-(void) writeMajorAndMinorThenMajor:(NSString *)UUID writeMajor:(NSString *)writeMajor writeMinor:(NSString *)writeMinor;
-(void) findSOSDevice;
-(void)stopfindSOSDevice;

-(void)scanTheDevice;
-(void)stopScanTheDevice;


-(NSString *)getMajor:(NSString *)major;
-(NSString *)getMinor:(NSString *)minor;


-(NSString *)getAppVersion;
@end
