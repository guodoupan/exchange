//
//  ExchangeItem.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ExchangeItem.h"

@implementation ExchangeItem

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    
    if (self) {
        self.objectId = [object objectId];
        self.name = object[@"name"];
        self.desc = object[@"desc"];
        self.type = [[object valueForKey:@"type"] integerValue];
        self.status = [[object valueForKey:@"status"] integerValue];
        self.wanted = [[object valueForKey:@"wanted"] integerValue];
        self.userId = object[@"userid"];
        self.createdAt = [object createdAt];
        self.updatedAt = [object updatedAt];
        self.imageFile = object[@"imageFile"];
    }
    
    return self;
}

+ (NSArray *)exchangeItemsWithArray:(NSArray *)array {
    NSMutableArray *items = [NSMutableArray array];
    for (PFObject *object in array) {
        ExchangeItem *item = [[ExchangeItem alloc] initWithPFObject:object];
        [items addObject: item];
    }
    return items;
}

- (PFObject *)pfObject {
    PFObject *object = [PFObject objectWithClassName:NSStringFromClass([self class])];
    object[@"name"] = self.name;
    object[@"desc"] = self.desc;
    object[@"type"] = @(self.type);
    object[@"status"] = @(self.status);
    object[@"userid"] = self.userId;
    object[@"imageFile"] = self.imageFile;
    object[@"wanted"] = @(self.wanted);
    
    return object;
}

@end
