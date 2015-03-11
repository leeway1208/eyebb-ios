//
//  ChildrenListViewController.h
//  EyeBB
//
//  Created by Evan on 15/3/11.
//  Copyright (c) 2015年 EyeBB. All rights reserved.
//

#import "EyeBBViewController.h"

@interface ChildrenListViewController : EyeBBViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    UITableView * tableview;
    NSMutableArray * Aarray;
    UISearchBar * searchBar;
    UISearchDisplayController *searchControl;
}

@end
