//
//  ChildInformationMatchingViewController.h
//  EyeBB
//
//  Created by liwei wang on 4/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeBBViewController.h"
@interface ChildInformationMatchingViewController : EyeBBViewController<UIActionSheetDelegate>
/* kindergarten name from kindergarten view */
@property (nonatomic,retain) NSString *kindergartenName;
/* kindergarten Id  */
@property (nonatomic,retain) NSString *kindergartenId;
/* guardian Id  */
@property (strong,nonatomic) NSString *guardianId;
@end
