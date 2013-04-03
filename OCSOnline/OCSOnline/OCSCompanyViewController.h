//
//  OCSCompanyViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-22.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "MBProgressHUD.h"
#import "OCSMapViewController.h"

@interface OCSCompanyViewController : UIViewController <PassValueDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>

@property (strong,nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;


@property (nonatomic) BOOL isCompanyParse;

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *bankRoll;
@property (retain, nonatomic) IBOutlet UILabel *webSite;
@property (retain, nonatomic) IBOutlet UILabel *property;
@property (retain, nonatomic) IBOutlet UILabel *domain;
@property (retain, nonatomic) IBOutlet UITextView *introduction;


@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UILabel *inputMoney;
@property (retain, nonatomic) IBOutlet UILabel *companyType;
@property (retain, nonatomic) IBOutlet UITextView *textview;

@property (retain, nonatomic) IBOutlet UITextView *projectMoney;
@property (retain, nonatomic) IBOutlet UILabel *lingyu;
@property (retain, nonatomic) IBOutlet UILabel *fangshi;
@property (retain, nonatomic) IBOutlet UILabel *stage;
@property (retain, nonatomic) IBOutlet UILabel *key;

@property (strong,nonatomic) NSString *companyId;
- (IBAction)showPlace:(id)sender;

@property (strong,nonatomic) IBOutlet OCSMapViewController *mapView;

@end
