//
//  OCSProInfoViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "MBProgressHUD.h"

@interface OCSProInfoViewController : UIViewController<PassValueDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>

@property (strong,nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

//项目信息
@property (retain, nonatomic) IBOutlet UILabel *cName;
@property (retain, nonatomic) IBOutlet UILabel *projectPlan;
@property (retain, nonatomic) IBOutlet UILabel *projectType;
@property (retain, nonatomic) IBOutlet UILabel *projectPeople;
@property (retain, nonatomic) IBOutlet UILabel *projectRemarks;
@property (retain, nonatomic) IBOutlet UILabel *projectStage;
@property (retain, nonatomic) IBOutlet UITextView *projectIntroduction;
@property (retain, nonatomic) IBOutlet UILabel *basicTid;
@property (retain, nonatomic) IBOutlet UILabel *basicSex;
@property (retain, nonatomic) IBOutlet UILabel *basicDate;
@property (retain, nonatomic) IBOutlet UILabel *basicHome;
@property (retain, nonatomic) IBOutlet UILabel *basicNationality;
@property (retain, nonatomic) IBOutlet UILabel *basicTopdiplomas;
@property (retain, nonatomic) IBOutlet UILabel *basicEmail;
@property (retain, nonatomic) IBOutlet UILabel *basicMobile;

@property (strong,nonatomic) NSString *projectId;
@property (strong,nonatomic) NSDictionary *projectInfo;

@end
