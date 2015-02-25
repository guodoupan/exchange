//
//  Transaction.m
//  exchange
//
//  Created by Doupan Guo on 2/24/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    
    if (self) {
        self.objectId = [object objectId];
        self.requestingItemId = object[@"requestingItemId"];
        self.requestedItemId = object[@"requestedItemId"];
//        self.requestingItem = [[ExchangeItem alloc] initWithPFObject:object[@"requestingItem"]];
//        self.requestedItem = [[ExchangeItem alloc] initWithPFObject:object[@"requestedItem"]];
        self.status = [object[@"status"] integerValue];
        self.createdAt = [object createdAt];
        self.updatedAt = [object updatedAt];
    }
    
    return self;
}

+ (NSArray *)transactionsWithArray:(NSArray *)array {
    NSMutableArray *transactions = [NSMutableArray array];
    for (PFObject *object in array) {
        Transaction *transaction = [[Transaction alloc] initWithPFObject:object];
        [transactions addObject: transaction];
    }
    return transactions;
}

- (PFObject *)pfObject {
    PFObject *object = [PFObject objectWithClassName:NSStringFromClass([self class])];
    object[@"requestingItemId"] = self.requestingItemId;
    object[@"requestedItemId"] = self.requestedItemId;
//    object[@"requestingItem"] = [self.requestingItem pfObject];
//    object[@"requestedItem"] = [self.requestedItem pfObject];
    object[@"status"] = @(self.status);
    return object;
}

@end
