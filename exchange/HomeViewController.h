//
//  HomeViewController.h
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "PostViewController.h"
#import "ExchangeItemCell.h"

@interface HomeViewController : UIViewController

@property (nonatomic, strong) ExchangeItemCell *protoTypeCell;

@end
