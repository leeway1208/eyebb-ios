//
//  UIViewController+EyeBBDB.h
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(EyeBBDB)
-(NSMutableArray *)allOrganization;

#pragma mark--
#pragma mark --保存儿童信息
-(void)SaveChildren:(NSArray *)childrenArray;
-(BOOL)saveLocalNameToDB:(NSString *)childID ChildNewName:(NSString *)childNewName;
-(BOOL)saveLocalIconToDB:(NSString *)childID ChildNewIcon:(NSString *)childNewIcon;
#pragma mark--
#pragma mark --儿童查询

-(NSMutableArray *)allChildren;
NSData* loadImageData(NSString *directoryPath, NSString *imageName);
#pragma mark--
#pragma mark --清除旧的儿童数据
/**清除旧的儿童数据*/
-(void)delLodChild;

-(NSString *)localImgPath;
-(NSString *)localImgName:(NSString *)childId;
@end
