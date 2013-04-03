//
//  OCSNoticeInfoViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface OCSNoticeInfoViewController : UIViewController<PassValueDelegate>

@property (retain,nonatomic) NSString *noticeID;

@end
