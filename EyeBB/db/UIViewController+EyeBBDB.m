//
//  UIViewController+EyeBBDB.m
//  EyeBB
//
//  Created by evan.Yan on 15-2-28.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "UIViewController+EyeBBDB.h"
#import "sqlite3.h"
#import "AppDelegate.h"

@implementation UIViewController(EyeBBDB)
/**获取数据库地址*/
-(NSString *)findDBUrl
{
    NSString *dataBasePath;
     NSArray *dicr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dbName = @"eyebb.db";
    dataBasePath = [dicr objectAtIndex:0];
    dataBasePath = [dataBasePath stringByAppendingPathComponent:dbName];
    
    return dataBasePath;

}

#pragma mark--
#pragma mark --机构查询

-(NSMutableArray *)allOrganization{
    
    NSMutableArray *skillArray = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
    if (sqlite3_open([[self findDBUrl] UTF8String] , &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSAssert(0, @"打开数据库失败！");
        
    }
    
    //查询技能
    NSString *qSkill = @"SELECT code,name,param_category_code,technology_id FROM zcdh_technology";
    
    sqlite3_stmt *statementSkill;
    
    if (sqlite3_prepare_v2(database, [qSkill UTF8String], -1, &statementSkill, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statementSkill) == SQLITE_ROW) {
            //临时装载信息
            NSMutableDictionary *row=[NSMutableDictionary dictionaryWithCapacity:4];
            
            //获得数据
            char* code = (char *)sqlite3_column_text(statementSkill, 0);
            NSString *codestr =  [NSString stringWithCString:code encoding:NSUTF8StringEncoding];
            char* name = (char *)sqlite3_column_text(statementSkill, 1);
            NSString *namestr =  [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            char* paramCategoryCode = (char *)sqlite3_column_text(statementSkill, 2);
            NSString *paramCategoryCodestr =  [NSString stringWithCString:paramCategoryCode encoding:NSUTF8StringEncoding];
            int technology_id = sqlite3_column_int(statementSkill, 3);
            
            [row setObject:codestr forKey:@"code"];
            [row setObject:namestr forKey:@"name"];
            [row setObject:paramCategoryCodestr forKey:@"param_category_code"];
            [row setObject:[NSString stringWithFormat:@"%i", technology_id] forKey:@"technology_id"];
            
            [skillArray addObject:row];
            
        }
        
        sqlite3_finalize(statementSkill);
        
    }
    
    return skillArray;
}

@end
