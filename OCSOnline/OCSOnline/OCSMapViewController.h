//
//  OCSMapViewController.h
//  OCSOnline
//
//  Created by jivoin on 13-3-12.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "CALayerExporter.h"
#import "SVGKImage.h"
#import "MBProgressHUD.h"
#import "V8HorizontalPickerView.h"

@interface OCSMapViewController : UIViewController< UIPopoverControllerDelegate, UISplitViewControllerDelegate , CALayerExporterDelegate, UIScrollViewDelegate,V8HorizontalPickerViewDataSource,V8HorizontalPickerViewDelegate>

@property (strong,nonatomic) UIToolbar *toolBar;


@property (strong,nonatomic) MBProgressHUD *HUD;
@property (nonatomic,retain) V8HorizontalPickerView *pickerView;
@property (nonatomic,retain) NSDictionary *floorArray;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UITextView* exportText;
@property (nonatomic, retain) NSMutableString* exportLog;
@property (nonatomic, retain) CALayerExporter* layerExporter;
@property (nonatomic, retain) UITapGestureRecognizer* tapGestureRecognizer;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewForSVG;
@property (nonatomic, retain) IBOutlet SVGKImageView *contentView;
//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *viewActivityIndicator;

@property (nonatomic, retain) UIButton *button;
@property (nonatomic,retain) CAShapeLayer* hitLayer;

@property (nonatomic, retain) id detailItem;

@property (retain, nonatomic) IBOutlet UIScrollView *topView;

- (IBAction)animate:(id)sender;
- (IBAction)exportLayers:(id)sender;

- (IBAction) showHideBorder:(id)sender;
- (IBAction)floorClick:(id)sender;
- (IBAction)showInfo:(id)sender;

-(void)showPlace;

@end
