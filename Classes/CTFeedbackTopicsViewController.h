//
//  CTFeedbackTopicsViewController.h
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/11/01.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTFeedbackTopicsViewController : UITableViewController

@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *localizedTopics;
@property (nonatomic, copy) void (^action)(NSString *);
@end
