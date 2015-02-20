//
//  ExchangeItem.h
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ExchangeItem : NSObject

@property (nonatomic, strong) NSString *nsid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSDate *uploadDate;

- (id)initWithPFObject: (PFObject *)object;
+ (NSArray *)exchangeItemsWithArray: (NSArray *)array;

- (PFObject *)pfObject;

@end
