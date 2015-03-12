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
//    dbFilePath = [documentFolderPath stringByAppendingPathComponent:DATABASE_FILE_NAME];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:dataBasePath];
    //- (BOOL)fileExistsAtPath:(NSString *)path;
    
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        //拷贝数据库
        
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:@"eyebb"
                                  ofType:@"db"];
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dataBasePath error:nil];
        NSLog(@"cp = %d",cp);
        //- (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error
        NSLog(@"backupDbPath =%@",backupDbPath);
        
    }
    NSLog(@"isExist =%d",isExist);
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
    
    //查询机构
    NSString *qOrganization = @"SELECT code,name,param_category_code,technology_id FROM zcdh_technology";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [qOrganization UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //临时装载信息
            NSMutableDictionary *row=[NSMutableDictionary dictionaryWithCapacity:4];
            
            //获得数据
            char* code = (char *)sqlite3_column_text(statement, 0);
            NSString *codestr =  [NSString stringWithCString:code encoding:NSUTF8StringEncoding];
            char* name = (char *)sqlite3_column_text(statement, 1);
            NSString *namestr =  [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            char* paramCategoryCode = (char *)sqlite3_column_text(statement, 2);
            NSString *paramCategoryCodestr =  [NSString stringWithCString:paramCategoryCode encoding:NSUTF8StringEncoding];
            int technology_id = sqlite3_column_int(statement, 3);
            
            [row setObject:codestr forKey:@"code"];
            [row setObject:namestr forKey:@"name"];
            [row setObject:paramCategoryCodestr forKey:@"param_category_code"];
            [row setObject:[NSString stringWithFormat:@"%i", technology_id] forKey:@"technology_id"];
            
            [skillArray addObject:row];
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    return skillArray;
}


#pragma mark--
#pragma mark --保存儿童信息

-(void)SaveChildren:(NSArray *)childrenArray {

    
    sqlite3 *database;
    if (sqlite3_open([[self findDBUrl] UTF8String] , &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSAssert(0, @"打开数据库失败！");
        
    }
    

    for(int i=0;i<childrenArray.count;i++)
    {
        NSString *insert =@"INSERT INTO 'children' ('child_id', 'name', 'icon', 'phone', 'relation_with_user', 'mac_address') VALUES (?, ?, ?, ?, ?, ?)";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [insert UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [[NSString stringWithFormat: @"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"childId" ]] UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 2, [[NSString stringWithFormat: @"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"name" ]] UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 3, [[NSString stringWithFormat: @"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"icon" ]] UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 1, [[NSString stringWithFormat: @"%@",[[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"child" ]objectForKey:@"" ]] UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 2, [[NSString stringWithFormat: @"%@",[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"relation" ]] UTF8String], -1,NULL);
            sqlite3_bind_text(statement, 3, [[NSString stringWithFormat: @"%@",[[[childrenArray objectAtIndex:i] objectForKey:@"childRel"]objectForKey:@"macAddress" ]] UTF8String], -1,NULL);
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSAssert(0, @"插入数据失败！");
            
            sqlite3_finalize(statement);
        }

    }
      sqlite3_close(database);
}


#pragma mark--
#pragma mark --儿童查询

-(NSMutableArray *)allChildren{
    
    NSMutableArray *ChildrenArray = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
    if (sqlite3_open([[self findDBUrl] UTF8String] , &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSAssert(0, @"打开数据库失败！");
        
    }
    
    //查询儿童
    NSString *qChildren = @"SELECT child_id,name,icon,relation_with_user,mac_address FROM  children";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [qChildren UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @try {
                //临时装载信息
                NSMutableDictionary *row=[NSMutableDictionary dictionaryWithCapacity:4];
                
                //获得数据
                int child_id = sqlite3_column_int(statement, 0);
                
                char* name = (char *)sqlite3_column_text(statement, 1);
                NSString *namestr =  [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                
                char* icon = (char *)sqlite3_column_text(statement, 2);
                NSString *iconstr =  [NSString stringWithCString:icon encoding:NSUTF8StringEncoding];
                
                char* relation = (char *)sqlite3_column_text(statement, 3);
                
                NSString * relationstr =  [NSString stringWithCString:relation encoding:NSUTF8StringEncoding];
                
                char* macAddress = (char *)sqlite3_column_text(statement, 3);
                NSString *macAddressstr =  [NSString stringWithCString:macAddress encoding:NSUTF8StringEncoding];
                
                [row setObject:[NSString stringWithFormat:@"%i", child_id] forKey:@"child_id"];
                [row setObject:namestr forKey:@"name"];
                [row setObject:iconstr forKey:@"icon"];
                [row setObject:relationstr forKey:@"relation_with_user"];
                [row setObject:macAddressstr forKey:@"mac_address"];
                
                [ChildrenArray addObject:row];

            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }
      sqlite3_close(database);
    return ChildrenArray;
}



@end
