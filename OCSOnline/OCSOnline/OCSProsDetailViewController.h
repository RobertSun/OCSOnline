//
//  OCSProsDetailViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface OCSProsDetailViewController : UIViewController<UISplitViewControllerDelegate,UIPopoverControllerDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (retain,nonatomic) NSString *proID;

//webservice
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

//学子项目信息
@property (strong,nonatomic) NSArray *projects;
//
@property (retain, nonatomic) IBOutlet UISearchBar *search;
@property (retain, nonatomic) IBOutlet UITableView *projectTable;
@property (strong,nonatomic) IBOutlet NSString *typeId;
@property (strong,nonatomic) NSString *searchKey;
-(IBAction)showMessage:(NSString *)type;

@end
