//
//  OCSProInfoViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSProInfoViewController.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "OCSWebserviceHandler.h"

@interface OCSProInfoViewController ()

@end

@implementation OCSProInfoViewController

@synthesize HUD;
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize projectId;
@synthesize projectInfo;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passValue:(NSString *)value{
//    self.title = [[NSString alloc]initWithFormat:@"%@项目信息介绍",value];
    HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载信息，请稍后...";
    projectId = [value substringFromIndex:1];
    [self getInfo];
}

-(void)passNSDictionary:(NSDictionary *)value{
    HUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载信息，请稍后...";
    [self setProjectInfo:value];
}

-(void)getInfo{
    matchingElement = @"return";
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>\n"
                         "<ns1:getProjectById xmlns:ns1=\"http://webservices.ocsonline.com/\">"
                         "<proId>%@</proId>"
                         "</ns1:getProjectById>\n"
                         "</soap:Body>\n"
                         "</soap12:Envelope>",projectId];
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/webservice/Project/getProjectById.asmx",[OCSWebserviceHandler getWebUrl]]];
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
//    
//    if ([elementName isEqualToString:matchingElement]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码信息"
//                                                        message:[NSString stringWithFormat:@"%@", soapResults]
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        elementFound = FALSE;
//        // 强制放弃解析
//        [xmlParser abortParsing];
//    }
//}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    projectInfo = [soapResults objectFromJSONString];
    if (soapResults) {
        soapResults = nil;
    }
    [self setProjectInfo:projectInfo];
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)setProjectInfo:(NSDictionary *)result{
    self.cName.text = [result objectForKey:@"uProjectCname"];
    self.projectPlan.text = [result objectForKey:@"uprojectPlan"];
    self.projectType.text = [result objectForKey:@"uprojectTypeInfo"]==nil?[result objectForKey:@"uprojectType"]:[result objectForKey:@"uprojectTypeInfo"];
    self.projectPeople.text = [result objectForKey:@"uprojectPeople"];
    self.projectRemarks.text = [result objectForKey:@"uprojectRemarks"];
    self.projectStage.text = [result objectForKey:@"uprojectStage"];
    self.projectIntroduction.text = [result objectForKey:@"uprojectIntroduction"];
    NSDictionary *ubasic = [result objectForKey:@"ubasic"];
    self.basicTid.text = [ubasic objectForKey:@"ubasicTid"];
    NSString *sex = [NSString stringWithFormat:@"%@",[ubasic objectForKey:@"ubasicSex"]];
    self.basicSex.text = [sex isEqualToString:@"0"]?@"男":@"女";
    self.basicDate.text = [ubasic objectForKey:@"ubasicDate"];
    NSString *home = [[NSString stringWithFormat:@"%@",[ubasic objectForKey:@"ubasicHome"]]autorelease];
    self.basicHome.text = home;
    if ([ubasic objectForKey:@"ubasicNationality"]) {
        self.basicNationality.text =[NSString stringWithFormat:@"%@", [ubasic objectForKey:@"ubasicNationality"]];
    }
    self.basicTopdiplomas.text =[ubasic objectForKey:@"ubasicTopdiplomas"];
    self.basicEmail.text = [ubasic objectForKey:@"ubasicEmail"];
    self.basicMobile.text = [ubasic objectForKey:@"ubasicMobile"];
    self.title = [NSString stringWithFormat:@"%@介绍",[result objectForKey:@"uProjectCname"]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



- (void)dealloc {
    [_cName release];
    [_projectPlan release];
    [_projectType release];
    [_projectPeople release];
    [_projectRemarks release];
    [_projectStage release];
    [_projectIntroduction release];
    [_basicTid release];
    [_basicSex release];
    [_basicDate release];
    [_basicHome release];
    [_basicNationality release];
    [_basicTopdiplomas release];
    [_basicEmail release];
    [_basicMobile release];
    [projectId release];
    [projectInfo release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCName:nil];
    [self setProjectPlan:nil];
    [self setProjectType:nil];
    [self setProjectPeople:nil];
    [self setProjectRemarks:nil];
    [self setProjectStage:nil];
    [self setProjectIntroduction:nil];
    [self setBasicTid:nil];
    [self setBasicSex:nil];
    [self setBasicDate:nil];
    [self setBasicHome:nil];
    [self setBasicNationality:nil];
    [self setBasicTopdiplomas:nil];
    [self setBasicEmail:nil];
    [self setBasicMobile:nil];
    [self setProjectId:nil];
    [self setProjectInfo:nil];
    [super viewDidUnload];
}
@end
