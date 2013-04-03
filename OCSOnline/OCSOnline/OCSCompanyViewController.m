//
//  OCSCompanyViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-22.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSCompanyViewController.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "OCSWebserviceHandler.h"
#import "OCSMapViewController.h"
@interface OCSCompanyViewController ()

@end

@implementation OCSCompanyViewController
@synthesize HUD;
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize isCompanyParse;
@synthesize companyId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"正在加载信息，请稍后...";
//    isCompanyParse = YES;
//    [self getInfo];

//    isCompanyParse = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passValue:(NSString *)value{
   HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   HUD.labelText = @"正在加载信息，请稍后...";
    isCompanyParse = YES;
    companyId = [value substringFromIndex:1];
    [self getInfo];
}

-(void)getInfo{
    matchingElement = @"return";
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>\n"
                         "<ns1:queryCompanyInfo xmlns:ns1=\"http://webservices.ocsonline.com/\">"
                         "<id>%@</id>"
                         "</ns1:queryCompanyInfo>\n"
                         "</soap:Body>\n"
                         "</soap12:Envelope>",companyId];
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/webservice/CompanyInfo/queryCompanyInfo.asmx",[OCSWebserviceHandler getWebUrl]]];
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
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:matchingElement]) {
        NSDictionary *result = [soapResults objectFromJSONString];
//        if (isCompanyParse) {
            [self setcompanyInfo:result];
//        }else{
        
//        }
        elementFound = FALSE;
        // 强制放弃解析
        [xmlParser abortParsing];
    }
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
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

-(void) setcompanyInfo:(NSDictionary *)result{
    self.name.text = [result objectForKey:@"name"];
    self.bankRoll.text = [result objectForKey:@"registerBankroll"];
    self.webSite.text = [result objectForKey:@"webSite"];
    if ([result objectForKey:@"companyProperty"] != nil) {
        self.property.text = [result objectForKey:@"companyProperty"];
    }else{
        self.property.text = [result objectForKey:@"companyPropertyOther"];
    }
    if ([result objectForKey:@"companyDomain"] != nil) {
        self.domain.text = [result objectForKey:@"companyDomain"];
    }else{
        self.domain.text = [result objectForKey:@"companyDomainInfo"];
    }
    self.introduction.text = [result objectForKey:@"introduction"];
    NSString *sheng = [result objectForKey:@"addressProvince"];
    NSString *shi = [result objectForKey:@"addressCity"];
    self.address.text = [[NSString alloc]initWithFormat:@"%@ %@ %@",sheng,shi,[result objectForKey:@"address"]];
    self.inputMoney.text = [result objectForKey:@"inputMoney"];
    if ([result objectForKey:@"companyType"] != nil) {
        self.companyType.text = [result objectForKey:@"companyType"];
    }else{
        self.companyType.text = [result objectForKey:@"companyTypeOther"];
    }
    
    self.projectMoney.text = [result objectForKey:@"projectMoney"];
    self.stage.text = [result objectForKey:@"projectStage"];
//    self.lingyu.text = [result objectForKey:@"<#string#>"];
    self.fangshi.text = [result objectForKey:@"projectType"];
    self.key.text = [result objectForKey:@"projectKey"];
    self.title = [NSString stringWithFormat:@"%@介绍",[result objectForKey:@"name"]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)passNSDictionary:(NSDictionary *)value{
    [self setcompanyInfo:value];
}


- (void)dealloc {
    [_textview release];
    [_address release];
    [_name release];
    [_bankRoll release];
    [_webSite release];
    [_inputMoney release];
    [_companyType release];
    [_property release];
    [_domain release];
    [_introduction release];
    [_lingyu release];
    [_fangshi release];
    [_key release];
    [_stage release];
    [_projectMoney release];
    [companyId release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLingyu:nil];
    [self setFangshi:nil];
    [self setKey:nil];
    [self setStage:nil];
    [self setProjectMoney:nil];
    [self setCompanyId:nil];
    [super viewDidUnload];
}
- (IBAction)showPlace:(id)sender {
    OCSMapViewController *mapView = [[OCSMapViewController alloc]init];
    [self.navigationController pushViewController:mapView animated:YES];
    [mapView showPlace];
}
@end
