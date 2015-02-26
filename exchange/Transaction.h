//
//  Transaction.h
//  exchange
//
//  Created by Doupan Guo on 2/24/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ExchangeItem.h"

@interface Transaction : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *requestingItemId;
@property (nonatomic, strong) NSString *requestedItemId;
@property (nonatomic, strong) ExchangeItem *requestingItem;
@property (nonatomic, strong) ExchangeItem *requestedItem;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) PFUser *requestingUser;
@property (nonatomic, strong) PFUser *requestedUser;

- (id)initWithPFObject: (PFObject *)object;
+ (NSArray *)transactionsWithArray: (NSArray *)array;

- (PFObject *)pfObject;
@end
