//
//  OCSProsMasterViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-25.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSProsMasterViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "OCSWebserviceHandler.h"
@interface OCSProsMasterViewController ()


@end

@implementation OCSProsMasterViewController

@synthesize conn;
@synthesize webData;
@synthesize HUD;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize types;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    types = [[NSArray alloc]init];
    HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载信息，请稍后...";
    [self getProjectTypes];
    self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0f, 600.0f);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *type = [types objectAtIndex:[indexPath row]];
    if (type) {
        cell.textLabel.text = [type objectForKey:@"sName"];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *type = [types objectAtIndex:row];
    [self.detailViewController showMessage:[type objectForKey:@"sId"]];

}

-(void)getProjectTypes{
    matchingElement = @"return";
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>\n"
                         "<ns1:getProjectType xmlns:ns1=\"http://webservices.ocsonline.com/\">"
                         "</ns1:getProjectType>\n"
                         "</soap:Body>\n"
                         "</soap12:Envelope>"];
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/webservice/Speciality/getProjectType.asmx",[OCSWebserviceHandler getWebUrl]]];
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
    
    // 打印出得到的XML
    //    NSLog(@"%@", theXML);
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

// 结束解析这个元素名
//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    if ([elementName isEqualToString:matchingElement]) {
//        types = [[NSArray alloc]initWithArray:[soapResults objectFromJSONString]];
//        [self.tableView reloadData];
//        elementFound = FALSE;
//        // 强制放弃解析
//        [xmlParser abortParsing];
//    }
//}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    types = [[NSArray alloc]initWithArray:[soapResults objectFromJSONString]];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (soapResults) {
        soapResults = nil;
    }
    
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



- (void)dealloc {
    [self.conn release];
    [self.webData release];
    [self.HUD release];
    [self.soapResults release];
    [self.xmlParser release];
//    [self.elementFound release];
    [self.matchingElement release];
    [self.types release];
    [self.tableView release];
    
//    [self.tableView release];
//    [self.tableView release];
//    [self.tableView release];
//    [self.tableView release];

    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
