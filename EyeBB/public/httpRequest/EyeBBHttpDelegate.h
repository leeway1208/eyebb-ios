//
//  EyeBBHttpDelegate.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-27.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EyeBBHttpDelegate<NSObject>

-(void)onReciveData:(ZCDHMessageResponse *) messageResponse with:(long)tag;
-(void)onError:(NSError *)error with:(long)tag;
//-(void)startRequest;
//-(void)endResponse;
-(void)endResponse:(BOOL)resultStatus;
-(void)startRequest:(NSString *)ViewControllerName;
-(void)setMyView:(NSString *)ViewControllerName;
/**显示加载层*/
-(void)ShowView;
@end
