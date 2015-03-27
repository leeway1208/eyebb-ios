//
//  KindergartenListViewController.h
//  EyeBB
//
//  Created by liwei wang on 6/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeBBViewController.h"
#import "ChildInformationMatchingViewController.h"

@interface KindergartenListViewController : EyeBBViewController
/* new a thread to load image with mutithread */
@property (nonatomic,strong) NSData *data;
/* image index */
@property (nonatomic,assign) int index;
/* guardian Id  */
@property (strong,nonatomic) NSString *guardianId;
@end
