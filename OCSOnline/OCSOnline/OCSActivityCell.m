//
//  OCSActivityCell.m
//  OCSOnline
//
//  Created by jivoin on 13-3-28.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//

#import "OCSActivityCell.h"

@implementation OCSActivityCell

#define nameTag 1
#define beginDateTag 2
#define endDateTag 2
#define addressTag 4

@synthesize titleFont;
@synthesize contentFont;
@synthesize titleSize;
@synthesize contentSize;

@synthesize nameLabel;
@synthesize beginDateLabel;
@synthesize endDateLabel;
@synthesize addressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleFont = [UIFont fontWithName:@"Arial" size:14];
        contentFont = [UIFont fontWithName:@"Arial" size:12];
        titleSize = CGSizeMake(600, 20000.0f);
        contentSize = CGSizeMake(300, 20000.0f);

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createCell:(NSString *)name :(NSString *)beginDate :(NSString *)endDate :(NSString *)address{
    if (nameLabel) {
        [nameLabel removeFromSuperview];
        nameLabel = nil;
    }
    if (beginDateLabel) {
        [beginDateLabel removeFromSuperview];
        beginDateLabel = nil;
    }
    if (endDateLabel) {
        [endDateLabel removeFromSuperview];
        endDateLabel = nil;
    }
    if (addressLabel) {
        [addressLabel removeFromSuperview];
        addressLabel = nil;
    }
    nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.text = name;
    nameLabel.font = titleFont;
    nameLabel.tag = nameTag;
    [nameLabel setNumberOfLines:0];
    CGSize nameSize = [name sizeWithFont:titleFont constrainedToSize:titleSize lineBreakMode:UILineBreakModeWordWrap];
    [nameLabel setFrame:CGRectMake(20.0f, 20.0f, nameSize.width, nameSize.height)];
    [self.contentView addSubview:nameLabel];
    
    beginDateLabel = [[UILabel alloc]init];
    beginDateLabel.textAlignment = UITextAlignmentLeft;
    beginDateLabel.text = beginDate;
    beginDateLabel.font = contentFont;
    beginDateLabel.tag = beginDateTag;
    [beginDateLabel setNumberOfLines:0];
    CGSize beginDateSize = [beginDate sizeWithFont:contentFont constrainedToSize:contentSize lineBreakMode:UILineBreakModeWordWrap];
    [beginDateLabel setFrame:CGRectMake(10.0f, nameLabel.frame.origin.y+10.0f+nameSize.height, beginDateSize.width, beginDateSize.height)];
    [self.contentView addSubview:beginDateLabel];
    
    endDateLabel = [[UILabel alloc]init];
    endDateLabel.textAlignment = UITextAlignmentLeft;
    endDateLabel.text = endDate;
    endDateLabel.font = contentFont;
    endDateLabel.tag = endDateTag;
    [endDateLabel setNumberOfLines:0];
    CGSize endDateSize = [endDate sizeWithFont:contentFont constrainedToSize:contentSize lineBreakMode:UILineBreakModeCharacterWrap];
    [endDateLabel setFrame:CGRectMake(beginDateLabel.frame.origin.x+10.0f+beginDateLabel.frame.size.width, beginDateLabel.frame.origin.y, endDateSize.width, endDateSize.height)];
    [self.contentView addSubview:endDateLabel];

    addressLabel = [[UILabel alloc]init];
    addressLabel.textAlignment = UITextAlignmentLeft;
    addressLabel.text = address;
    addressLabel.font = contentFont;
    addressLabel.tag = addressTag;
    [addressLabel setNumberOfLines:0];
    CGSize addressSize = [address sizeWithFont:contentFont constrainedToSize:contentSize lineBreakMode:UILineBreakModeCharacterWrap];
    [addressLabel setFrame:CGRectMake(10.0f, endDateLabel.frame.origin.y+10.0f+endDateLabel.frame.size.height, addressSize.width, addressSize.height)];
    [self.contentView addSubview:addressLabel];
}

-(void)dealloc{
    [self.nameLabel release];
    [self.beginDateLabel release];
    [self.endDateLabel release];
    [self.addressLabel release];
    [self.titleFont release];
    [self.contentFont release];
    [super dealloc];
}

@end
