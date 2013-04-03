//
//  OCSAppDelegate.h
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) IBOutlet UITabBarController *rootController;

@property (strong, nonatomic) UISplitViewController *prosSplitView;

@end
