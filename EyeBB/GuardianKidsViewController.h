//
//  GuardianKidsViewController.h
//  EyeBB
//
//  Created by Evan on 15/3/22.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "EyeBBViewController.h"

@interface GuardianKidsViewController : EyeBBViewController
{
    
}
/**已选中儿童列表*/
@property (nonatomic,strong) NSMutableArray*SelectedchildrenArray;
/**授权人ID*/
@property (nonatomic,strong) NSString *guestId;
/**数据源数组*/
@property (nonatomic,strong) NSArray *_childrenArray;
/* guest == 1 master == 2 */
@property int guestOrMaster ;
@end
