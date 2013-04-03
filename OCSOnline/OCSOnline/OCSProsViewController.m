//
//  OCSProsViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSProsViewController.h"
#import "OCSProsDetailViewController.h"
#import "JSONKit.h"
@interface OCSProsViewController ()

@end

@implementation OCSProsViewController
@synthesize pros;
@synthesize table;
@synthesize searchBar;



- (void)viewDidLoad
{
    [super viewDidLoad];
    pros=[[NSArray alloc]initWithObjects:@"项目1",@"项目2",@"项目3",@"项目4",@"项目5",@"项目6",@"项目7", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pros count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.pros objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCSProsDetailViewController *detailView = [[OCSProsDetailViewController alloc]init];
    [detailView passValue:[self.pros objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:detailView animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText = searchBar.text;
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"search" message:[[NSString alloc]initWithFormat:@"您输入的搜索条件是：%@",searchText] delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles: nil];
    [alert show];
    pros=[[NSArray alloc]initWithObjects:@"项目1",@"项目3", nil];
    [table reloadData];
}


@end
