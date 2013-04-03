//
//  OCSNoticeInfoViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSNoticeInfoViewController.h"

@interface OCSNoticeInfoViewController ()

@end

@implementation OCSNoticeInfoViewController
@synthesize noticeID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[[NSString alloc]initWithFormat:@"通知：%@ 详细信息",noticeID];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passValue:(NSString *)value{
    self.noticeID = value;
    self.title=[[NSString alloc]initWithFormat:@"通知：%@ 详细信息",noticeID];
}

@end
