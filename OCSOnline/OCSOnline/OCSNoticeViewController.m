//
//  OCSNoticeViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSNoticeViewController.h"
#import "OCSNoticeInfoViewController.h"


@interface OCSNoticeViewController ()
    
@end

@implementation OCSNoticeViewController

@synthesize array;

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
    self.array = [[NSMutableArray alloc]initWithObjects:@"aa",@"bb", nil];
}

-(IBAction)showInfo:(id)sender{
    OCSNoticeInfoViewController *infoView = [[OCSNoticeInfoViewController alloc]init];
    [self.navigationController pushViewController:infoView animated:YES];
    infoView.title = @"通知详细信息view";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark Table Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Notice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [array objectAtIndex:row];
    cell.detailTextLabel.text=@"2012-03-02";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [array objectAtIndex:[indexPath row]];
    OCSNoticeInfoViewController *infoView = [[OCSNoticeInfoViewController alloc]init];
    [infoView passValue:title];
    [self.navigationController pushViewController:infoView animated:YES];
}

- (void)dealloc {
    [_navBar release];
    [super dealloc];
}
@end
