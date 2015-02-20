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
        self.nsid = object[@"nsid"];
        self.name = object[@"name"];
        self.desc = object[@"desc"];
        self.imageUrl = object[@"imageUrl"];
        self.type = [[object valueForKey:@"type"] integerValue];
        self.status = [[object valueForKey:@"status"] integerValue];
        self.userId = object[@"userid"];
        //TODO date
    }
    
    return self;
}

- (PFObject *)pfObject {
    PFObject *object = [PFObject objectWithClassName:NSStringFromClass([self class])];
    object[@"name"] = self.name;
    object[@"desc"] = self.desc;
    object[@"type"] = @(self.type);
    object[@"status"] = @(self.status);
    object[@"userid"] = self.userId;
    
    //TODO imageurl, date, nsid
    return object;
}

@end
