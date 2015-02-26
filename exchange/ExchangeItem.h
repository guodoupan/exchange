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

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger wanted;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) PFFile *imageFile;

- (id)initWithPFObject: (PFObject *)object;
+ (NSArray *)exchangeItemsWithArray: (NSArray *)array;

- (PFObject *)pfObject;

@end
