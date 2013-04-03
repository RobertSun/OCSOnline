//
//  OCSCompaniesViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-26.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSCompaniesViewController.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "OCSCompanyViewController.h"
#import "OCSWebserviceHandler.h"

@interface OCSCompaniesViewController ()

@property (nonatomic) BOOL loadMore;
@property (strong,nonatomic) NSString *searchText;
@end

@implementation OCSCompaniesViewController
@synthesize HUD;
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize companies;
@synthesize currentPage;
@synthesize loadMore;
@synthesize searchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
}

-(void)searchCompany:(NSString *)companyName{
    HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载信息，请稍后...";
    matchingElement = @"return";
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>\n"
                         "<ns1:queryCompanies xmlns:ns1=\"http://webservices.ocsonline.com/\">"
                         "<name>%@</name>"
                         "<pageNum>%d</pageNum>"
                         "</ns1:queryCompanies>\n"
                         "</soap:Body>\n"
                         "</soap12:Envelope>",companyName,currentPage];
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/webservice/CompanyInfo/queryCompanies.asmx",[OCSWebserviceHandler getWebUrl]]];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    //    [req setHTTPBody:[soapMsg ]]
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [[NSMutableData data]retain];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark URL Connection Data Delegate Methods

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    [webData appendData:data];
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"访问数据出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
                                                length:[webData length]
                                              encoding:NSUTF8StringEncoding];
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
}
#pragma mark -
#pragma mark XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if ([elementName isEqualToString:matchingElement]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
        [soapResults appendString: string];
    }
}

//// 结束解析这个元素名
//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    if ([elementName isEqualToString:matchingElement]) {
//        projects = [[NSArray alloc]initWithArray:[soapResults objectFromJSONString]];
////        [projectTable reloadData];
//        elementFound = FALSE;
//        // 强制放弃解析
////        [xmlParser abortParsing];
//    }
//}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (loadMore) {
        [companies addObjectsFromArray:[[NSArray alloc]initWithArray:[soapResults objectFromJSONString]]];
    }else{
        companies = [[NSMutableArray alloc]initWithArray:[soapResults objectFromJSONString]];
    }
    
    if (soapResults) {
        soapResults = nil;
    }
    [_companyTable reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [companies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *company = [companies objectAtIndex:[indexPath row]];
    if (company) {
        cell.textLabel.text = [company objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == [companies count]-1) {
        loadMore = YES;
        [self createFooterView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSDictionary *company = [companies objectAtIndex:row];
    OCSCompanyViewController *companyView = [[OCSCompanyViewController alloc]init];
//    [companyView passNSDictionary:company];
    [self.navigationController pushViewController:companyView animated:YES];
    [companyView passNSDictionary:company];
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (loadMore) {
        self.currentPage+=1;
        [self searchCompany:searchText];
    }
}

//搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.currentPage = 1;
    searchText = [[NSString alloc] initWithString:searchBar.text];
    loadMore = NO;
    [self searchCompany:searchText];
}

-(void)createFooterView{
    self.companyTable.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.companyTable.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 40.f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setText:@"上拉显示更多信息"];
    [tableFooterView addSubview:loadMoreText];
    self.companyTable.tableFooterView = tableFooterView;
}

- (void)dealloc {
    [_searchBar release];
    [_companyTable release];
    [HUD release];
    [webData release];
    [soapResults release];
    [xmlParser release];
    [matchingElement release];
    [conn release];
    [_companyTable release];
    [companies release];
//    [searchText release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setCompanyTable:nil];
    [self setHUD:nil];
    [self setWebData:nil];
    [self setSoapResults:nil];
    [self setXmlParser:nil];
    [self setMatchingElement:nil];
    [self setConn:nil];
    [self setCompanies:nil];
//    [self setSearchText:nil];
    [super viewDidUnload];
}
@end
