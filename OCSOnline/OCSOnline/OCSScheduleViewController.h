//
//  OCSScheduleViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface OCSScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

@property (strong,nonatomic) NSMutableArray *activities;
@property (retain, nonatomic) IBOutlet UITableView *tableVIew;

@end
