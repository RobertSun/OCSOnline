//
//  OCSNoticeViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PassValueDelegate.h"

@interface OCSNoticeViewController : UITableViewController<UITableViewDataSource>

-(IBAction)showInfo:(id)sender;

@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;

@property (retain,nonatomic) NSMutableArray *array;

@end
