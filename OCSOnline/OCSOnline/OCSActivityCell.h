//
//  OCSActivityCell.h
//  OCSOnline
//
//  Created by jivoin on 13-3-28.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCSActivityCell : UITableViewCell

@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *beginDateLabel;
@property (strong,nonatomic) UILabel *endDateLabel;
@property (strong,nonatomic) UILabel *addressLabel;

@property (strong,nonatomic) UIFont *contentFont;
@property (strong,nonatomic) UIFont *titleFont;

@property (nonatomic) CGSize titleSize;
@property (nonatomic) CGSize contentSize;


-(void)createCell:(NSString *)name :(NSString *)beginDate :(NSString *)endDate :(NSString *)address;

@property (nonatomic) CGFloat cellHight;

@end
