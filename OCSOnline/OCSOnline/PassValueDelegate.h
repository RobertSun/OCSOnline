//
//  PassValueDelegate.h
//  OCSOnline
//
//  Created by jivoin on 13-3-13.
//  Copyright (c) 2013年 enraynet. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol PassValueDelegate <NSObject>

- (void)passValue:(NSString*)value;

- (void)passNSDictionary:(NSDictionary *)value;

@end