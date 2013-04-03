//
//  OCSAppDelegate.m
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSAppDelegate.h"
#import "OCSMapViewController.h"
#import "OCSNoticeViewController.h"
#import "OCSScheduleViewController.h"
#import "OCSProsViewController.h"
#import "OCSProsMasterViewController.h"
#import "OCSProsDetailViewController.h"
#import "OCSCompaniesViewController.h"
@implementation OCSAppDelegate

@synthesize rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.rootController = [[UITabBarController alloc] init];
    //地图
    OCSMapViewController *mapView = [[[OCSMapViewController alloc]initWithNibName:@"OCSMapViewController" bundle:nil]autorelease];
    mapView.title = @"地图";
    UINavigationController *mapNav = [[[UINavigationController alloc]initWithRootViewController:mapView]autorelease];
    [mapNav setNavigationBarHidden:YES];
//    [mapView release];
    
    //日程
    OCSScheduleViewController *scheduleView = [[[OCSScheduleViewController alloc]init]autorelease];
    scheduleView.title =@"日程";
    UINavigationController *scheduleNav = [[[UINavigationController alloc]initWithRootViewController:scheduleView]autorelease];
//    [scheduleView release];

    //通知
    OCSNoticeViewController *noticeView = [[[OCSNoticeViewController alloc]init]autorelease];
    noticeView.title = @"通知";
    UINavigationController *noticeNav = [[[UINavigationController alloc]initWithRootViewController:noticeView] autorelease];
    
    //企业查询
    OCSCompaniesViewController *companiesView = [[[OCSCompaniesViewController alloc]init]autorelease];
    companiesView.title = @"企业查询";
    UINavigationController *companiesNav = [[[UINavigationController alloc]initWithRootViewController:companiesView] autorelease];
    
    //项目    
    OCSProsDetailViewController *prosDetailView = [[OCSProsDetailViewController alloc]init];
    UINavigationController *prosDetailNav = [[UINavigationController alloc]initWithRootViewController:prosDetailView];
    OCSProsMasterViewController *prosMasterView = [[OCSProsMasterViewController alloc]init];
    UINavigationController *prosMasterNav = [[UINavigationController alloc]initWithRootViewController:prosMasterView];
    prosMasterView.detailViewController = prosDetailView;
    self.prosSplitView = [[[UISplitViewController alloc] init] autorelease];
    self.prosSplitView.delegate = prosDetailView;
    self.prosSplitView.viewControllers = @[prosMasterNav, prosDetailNav];
    self.prosSplitView.title = @"学子项目查询";
    
    [mapNav.tabBarItem setImage:[UIImage imageNamed:@"ico_场地_默认.png"]];
    [scheduleNav.tabBarItem setImage:[UIImage imageNamed:@"ico_日程_默认.png"]];
    [self.prosSplitView.tabBarItem setImage:[UIImage imageNamed:@"ico_项目_默认.png"]];
    [companiesNav.tabBarItem setImage:[UIImage imageNamed:@"ico_企业_默认.png"]];
    
    
    rootController.viewControllers = @[mapNav,scheduleNav,self.prosSplitView,companiesNav];
    self.window.rootViewController=rootController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
