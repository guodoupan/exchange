//
//  Constants.h
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString *const DidLogoutNotificationKey;
extern NSString *const ParseAppId;
extern NSString *const ParseClientKey;

typedef enum ItemStatus : NSInteger {
    ItemUploaded, // just uploaded
    ItemExchangeRequesting, // someone requesting an exchange
    ItemExchangeAccepted, // exchange accecpted
    ItemNotAvaiable // not avaiable for exchange
} ItemStatus;

typedef enum TransactionStatus : NSInteger {
    TransactionRequesting,
    TransactionAccepted,
    TransactionRejected,
    TransactionClosed
} TransactionStatus;

@end
