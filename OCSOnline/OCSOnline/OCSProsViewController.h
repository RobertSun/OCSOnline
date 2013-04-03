//
//  OCSProsViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCSProsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (retain,nonatomic) NSArray *pros;
@property (retain,nonatomic) IBOutlet UITableView *table;
@property (retain,nonatomic) IBOutlet UISearchBar *searchBar;

@end
