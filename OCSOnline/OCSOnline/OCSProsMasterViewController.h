//
//  OCSProsMasterViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-25.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "OCSProsDetailViewController.h"
@interface OCSProsMasterViewController : UITableViewController<MBProgressHUDDelegate,NSXMLParserDelegate,UIAlertViewDelegate>

//webservicess
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

//数组
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *types;

//详细窗体
@property (strong,nonatomic) IBOutlet OCSProsDetailViewController *detailViewController;
@end
