//
//  OCSMapViewController.m
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSMapViewController.h"
#import "NodeList+Mutable.h"
#import "SVGKFastImageView.h"
#import "OCSProInfoViewController.h"
#import "OCSCompanyViewController.h"
#import "MBProgressHUD.h"
#import "OCSWebserviceHandler.h"


@interface OCSMapViewController ()
//@property (nonatomic, retain) UIPopoverController *popoverController;
@property (strong,nonatomic) NSString *contentId;
- (void)loadResource:(NSString *)name;
- (void)shakeHead;
@property (nonatomic,retain) NSArray *floorKeys;
@end

@implementation OCSMapViewController

@synthesize scrollViewForSVG;
@synthesize toolbar, contentView, detailItem;
//@synthesize viewActivityIndicator;
@synthesize hitLayer;
@synthesize button;
@synthesize HUD;
@synthesize contentId;
@synthesize floorArray;
@synthesize pickerView;
@synthesize floorKeys;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)initToolBar{
    
}

- (void)dealloc {
    //	self.popoverController = nil;
    [self.toolBar release];
    [self.detailItem release];
    [self.name release];
    [self.exportText release];
    [self.exportLog release];
    [self.layerExporter release];
    [self.scrollViewForSVG release];
    [self.contentView release];
//    [self.viewActivityIndicator release];
    [self.hitLayer release];
    [self.button release];
    [self.pickerView release];
    [self.floorArray release];
    [self.floorKeys release];
//	self.toolbar = nil;
//	self.detailItem = nil;
//	self.name = nil;
//	self.exportText = nil;
//	self.exportLog = nil;
//	self.layerExporter = nil;
//	self.scrollViewForSVG = nil;
//	self.contentView = nil;
//	self.viewActivityIndicator = nil;
//	self.hitLayer = nil;
    [_topView release];
	[super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[pickerView scrollToElement:0 animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"aaaaa");
	return NO;
    //	(interfaceOrientation == UIInterfaceOrientationPortrait ||
    //	 interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
    //	 interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    floorArray = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@/svg/floor1st.svg",[OCSWebserviceHandler getWebUrl]],@"一楼", nil];
    floorKeys = [[NSArray alloc]initWithObjects:@"滑动以显示展厅地图",@"一楼",@"二楼",@"三楼",@"四楼",@"五楼", nil];
    [self creaetPicker];
//    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:
//                          [[[UIBarButtonItem alloc] initWithTitle:@"一楼" style:UIBarButtonItemStyleBordered target:self action:@selector(floorClick:)] autorelease],
//                          [[[UIBarButtonItem alloc] initWithTitle:@"二楼" style:UIBarButtonItemStyleBordered target:self action:@selector(floorClick:)] autorelease],
//                          nil];
    
    
}

-(void)creaetPicker{
    NSString *hexColor = @"dd8989";
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green]; 
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    CGFloat margin = 0.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat pickerHeight = 40.0f;
	CGFloat x = margin;
	CGFloat y = 0.0f;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
    pickerView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
	pickerView.backgroundColor = [UIColor colorWithRed:(float)(50/255.0f) green:(float)(00/255.0f) blue:(float)(00/255.0f) alpha:1.0f];
	pickerView.selectedTextColor = [UIColor whiteColor];
	pickerView.textColor   = [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
	pickerView.delegate    = self;
	pickerView.dataSource  = self;
	pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	pickerView.selectionPoint = CGPointMake(120, 0);
    
	// add carat or other view to indicate selected element
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.gif"]];
	pickerView.selectionIndicatorView = indicator;
    //	pickerView.indicatorPosition = V8HorizontalPickerIndicatorTop; // specify indicator's location
	[indicator release];
    [self.view addSubview:pickerView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(IBAction)floorClick:(id)sender{
//    UIBarButtonItem *iterm = (UIBarButtonItem *)sender;
//    if ([iterm.title isEqualToString:@"一楼"]) {
//        [self loadResource:@"Map"];
//    }else{
////        [self loadResource:@"australia_states_blank"];
//        [self loadResource:@"http://192.168.10.130:8080/OCSOnline/svg/1floor.svg"];
//    }
//    
//}

-(void) deselectTappedLayer
{
    if (self.hitLayer!=nil) {
        [self.hitLayer removeFromSuperlayer];
//        [self.hitLayer release];
        self.hitLayer = nil;
    }
    if (self.button!=nil) {
        [self.button removeFromSuperview];
        self.button = nil;
    }
}

- (void)loadResource:(NSString *)name
{
    NSLog(@"%@",name);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载信息，请稍后...";
//	[self.viewActivityIndicator startAnimating];
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]]; // makes the animation appear
	
    [self.contentView removeFromSuperview];
    
	SVGKImage *document = nil;
	/** Detect URL vs file */
	if( [name hasPrefix:@"http://"])
	{
		document = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:name]];
	}
	else
		document = [SVGKImage imageNamed:[name stringByAppendingPathExtension:@"svg"]];
	
	
	
	if( document == nil )
	{
        [[[[UIAlertView alloc] initWithTitle:@"加载地图失败" message:@"服务器请求超时。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
	}
	else
	{
		if( document.parseErrorsAndWarnings.rootOfSVGTree != nil )
		{
			NSLog(@"[%@] Freshly loaded document (name = %@) has size = %@", [self class], name, NSStringFromCGSize(document.size) );
			
			if( self.contentView != nil
               && self.tapGestureRecognizer != nil )
				[self.contentView removeGestureRecognizer:self.tapGestureRecognizer];
			
			if( self.tapGestureRecognizer == nil )
			{
				self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
			}
			
			if(
			   [name  isEqualToString:@"Monkey"] // Monkey uses layer-animations, so REQUIRES the layered version of SVGKImageView
			   || [name isEqualToString:@"RainbowWing"] // RainbodWing uses gradient-fills, so REQUIRES the layered version of SVGKImageView
			   )
			{
				self.contentView = [[[SVGKLayeredImageView alloc] initWithSVGKImage:document] autorelease];
			}
			else
			{
				self.contentView = [[[SVGKFastImageView alloc] initWithSVGKImage:document] autorelease];
//				
//				NSLog(@"[%@] WARNING: workaround for Apple bugs: UIScrollView spams tiny changes to the transform to the content view; currently, we have NO WAY of efficiently measuring whether or not to re-draw the SVGKImageView. As a temporary solution, we are DISABLING the SVGKImageView's auto-redraw-at-higher-resolution code - in general, you do NOT want to do this", [self class]);
				
				((SVGKFastImageView*)self.contentView).disableAutoRedrawAtHighestResolution = TRUE;
			}
			self.contentView.showBorder = FALSE;
			[self.contentView addGestureRecognizer:self.tapGestureRecognizer];
			
			if (_name) {
				[_name release];
				_name = nil;
			}
			
			_name = [name copy];
			
			[self.scrollViewForSVG addSubview:self.contentView];
			[self.scrollViewForSVG setContentSize: self.contentView.frame.size];
			
			float screenToDocumentSizeRatio = self.scrollViewForSVG.frame.size.width / self.contentView.frame.size.width;
			
			self.scrollViewForSVG.minimumZoomScale = MIN( 1, screenToDocumentSizeRatio );
			self.scrollViewForSVG.maximumZoomScale = MAX( 1, screenToDocumentSizeRatio );
		}
		else
		{
			[[[[UIAlertView alloc] initWithTitle:@"SVG parse failed" message:[NSString stringWithFormat:@"%i fatal errors, %i warnings. First fatal = %@",[document.parseErrorsAndWarnings.errorsFatal count],[document.parseErrorsAndWarnings.errorsRecoverable count]+[document.parseErrorsAndWarnings.warnings count], ((NSError*)[document.parseErrorsAndWarnings.errorsFatal objectAtIndex:0]).localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
	}
	[MBProgressHUD hideHUDForView:self.view animated:YES];
//	[self.viewActivityIndicator stopAnimating];
}



/**
 Example of how to handle gaps on an SVG
 */
-(void) handleTapGesture:(UITapGestureRecognizer*) recognizer
{
    [self deselectTappedLayer];
	CGPoint p = [recognizer locationInView:self.contentView];
	SVGKImage* svgImage = nil; // ONLY used for the hacky code below that demonstrates how complex hit-
	CALayer* layerForHitTesting;
	if( [self.contentView isKindOfClass:[SVGKFastImageView class]])
	{
		layerForHitTesting = ((SVGKFastImageView*)self.contentView).image.CALayerTree;
		svgImage = ((SVGKFastImageView*)self.contentView).image;
		CGSize scaleConvertImageToViewForHitTest = CGSizeMake( self.contentView.bounds.size.width / svgImage.size.width, self.contentView.bounds.size.height / svgImage.size.height ); // this is a copy/paste of the internal "SCALING" logic used in SVGKFastImageView
		
		p = CGPointApplyAffineTransform( p, CGAffineTransformInvert( CGAffineTransformMakeScale( scaleConvertImageToViewForHitTest.width, scaleConvertImageToViewForHitTest.height)) ); // must do the OPPOSITE of the zoom (to convert the 'seeming' point to the 'actual' point
	}
	else
		layerForHitTesting = self.contentView.layer;
	CAShapeLayer *layer = (CAShapeLayer *)[layerForHitTesting hitTest:p];
    if( ![layer isKindOfClass:[CAShapeLayer class]] ){
//        [self.nextResponder floorClick];
        return;
    }
    self.hitLayer = [[[CAShapeLayer alloc]init] autorelease];
    self.hitLayer.fillColor = [[UIColor orangeColor] CGColor];
    self.hitLayer.frame = layer.frame;
    self.hitLayer.lineCap = layer.lineCap;
    self.hitLayer.lineWidth = layer.lineWidth;
    self.hitLayer.path = layer.path;
    self.hitLayer.strokeColor = layer.strokeColor;
    [self.contentView.layer addSublayer:self.hitLayer];
    
    self.button = [[UIButton alloc]init];
    button.frame = layer.frame;
    self.contentId = layer.name;
    [button setTitle:[[NSString alloc]initWithFormat:@"查看信息"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
	
}

-(IBAction)showInfo:(id)sender{
    UIButton *button = (UIButton *)sender;
    if ([self.contentId hasPrefix:@"c"]) {
        OCSCompanyViewController *companyView = [[OCSCompanyViewController alloc]init];
        [companyView passValue:self.contentId];
        [self.navigationController pushViewController:companyView animated:YES];
                
    }
    if ([self.contentId hasPrefix:@"s"]) {
        OCSProInfoViewController *projectView = [[OCSProInfoViewController alloc]init];
        [projectView passValue:self.contentId];
        [self.navigationController pushViewController:projectView animated:YES];

    }
    
}

#pragma mark - CRITICAL: this method makes Apple render SVGs in sharp focus

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)finalScale
{
    [self.scrollViewForSVG setZoomScale:finalScale+0.01 animated:NO];
    [self.scrollViewForSVG setZoomScale:finalScale animated:NO];


}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

- (IBAction)exportLayers:(id)sender {
    if (_layerExporter) {
        return;
    }
    _layerExporter = [[CALayerExporter alloc] initWithView:contentView];
    _layerExporter.delegate = self;
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    UIViewController* textViewController = [[[UIViewController alloc] init] autorelease];
    [textViewController setView:textView];
    UIPopoverController* exportPopover = [[UIPopoverController alloc] initWithContentViewController:textViewController];
    [exportPopover setDelegate:self];
    [exportPopover presentPopoverFromBarButtonItem:sender
						  permittedArrowDirections:UIPopoverArrowDirectionAny
										  animated:YES];
    
    _exportText = textView;
    _exportText.text = @"exporting...";
    
    _exportLog = [[NSMutableString alloc] init];
    [_layerExporter startExport];
}

- (void) layerExporter:(CALayerExporter*)exporter didParseLayer:(CALayer*)layer withStatement:(NSString*)statement
{
    //NSLog(@"%@", statement);
    [_exportLog appendString:statement];
    [_exportLog appendString:@"\n"];
}

- (void)layerExporterDidFinish:(CALayerExporter *)exporter
{
    _exportText.text = _exportLog;
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)pc
//{
//    [_exportText release];
//    _exportText = nil;
//    
//    [_layerExporter release];
//    _layerExporter = nil;
//    
//    [pc release];
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	CGFloat margin = 40.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat x = margin;
	CGFloat y = 0.0f;
	CGFloat height = 40.0f;
	CGFloat spacing = 25.0f;
	CGRect tmpFrame;
	if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		y = 150.0f;
		spacing = 25.0f;
		tmpFrame = CGRectMake(x, y, width, height);
	} else {
		y = 50.0f;
		spacing = 10.0f;
		tmpFrame = CGRectMake(x, y, width, height);
	}
	pickerView.frame = tmpFrame;
    
}


#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [floorKeys count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [floorKeys objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [floorKeys objectAtIndex:index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    NSString *content = [floorArray objectForKey:[floorKeys objectAtIndex:index]];
    if (content) {
        [self loadResource:content];
        return;
    }
    if ([[floorKeys objectAtIndex:index] isEqualToString:@"滑动以显示展厅地图"]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"该楼层为展示picker控件，不包含展厅地图" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
//	self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
}

-(void)showPlace{
    floorArray = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@/svg/floor1st.svg",[OCSWebserviceHandler getWebUrl]],@"一楼", nil];
    floorKeys = [[NSArray alloc]initWithObjects:@"滑动以显示展厅地图",@"一楼",@"二楼",@"三楼",@"四楼",@"五楼", nil];
    [self creaetPicker];
    [pickerView scrollToElement:1 animated:NO];
    CALayer *layerTree = ((SVGKFastImageView*)self.contentView).image.CALayerTree;
    CALayer *layer = nil;
    NSArray *array = [layerTree sublayers];
    for (int i =0; i<[array count]; i++) {
        layer = [array objectAtIndex:i];
        if ([layer.name isEqualToString:@"c26"]) {
            NSLog(@"find");
            break;
        }
        NSLog(@"--------");
    }
    if (layer) {
        CALayer *tappLayer = [[CALayer alloc]init];
        tappLayer.frame = layer.frame;
        tappLayer.borderColor = [UIColor redColor].CGColor;
        tappLayer.borderWidth = 3.0f;
        [self.contentView.layer addSublayer:tappLayer];
        [self.scrollViewForSVG setContentOffset:CGPointMake((layer.frame.origin.x-self.scrollViewForSVG.frame.size.width/2), 200.0f)];
    }
    
    
}


- (void)viewDidUnload {
    [self setTopView:nil];
    [super viewDidUnload];
}
@end
