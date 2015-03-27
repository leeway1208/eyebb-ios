//
//  RegViewController.m
//  EyeBB
//
//  Created by Evan on 15/2/23.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "EyeBBViewController.h"
@interface RootViewController : EyeBBViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
      NSTimer * timer;
}
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic, retain) NSString * childID;
/* guardian Id  */
@property (strong,nonatomic) NSString *guardianId;
@end
