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
    Uploaded, // just uploaded
    ExchangeRequesting, // someone requesting an exchange
    ExchangeAccepted, // exchange accecpted
    NotAvaiable // not avaiable for exchange
} ItemStatus;

@end
