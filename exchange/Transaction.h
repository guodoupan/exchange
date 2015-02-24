//
//  Transaction.h
//  exchange
//
//  Created by Doupan Guo on 2/24/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Transaction : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *requestingItemId;
@property (nonatomic, strong) NSString *requestedItemId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

- (id)initWithPFObject: (PFObject *)object;
+ (NSArray *)transactionsWithArray: (NSArray *)array;

- (PFObject *)pfObject;
@end
