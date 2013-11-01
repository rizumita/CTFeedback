//
//  CTFeedbackViewController.h
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/10/31.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class CTFeedbackTopicCellItem;
@class CTFeedbackContentCellItem;

@interface CTFeedbackViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *localizedTopics;

/*
 * selectedTopic's default value is first item of topics.
 */
@property (nonatomic, strong) NSString *selectedTopic;


@property (nonatomic, readonly) NSString *platformString;
@property (nonatomic, readonly) NSString *systemVersion;
@property (nonatomic, readonly) NSString *appName;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuild;

@property (nonatomic, strong) NSArray *toRecipients;

@property (nonatomic, strong) NSArray *ccRecipients;

@property (nonatomic, strong) NSArray *bccRecipients;

+ (CTFeedbackViewController *)controllerWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics;

+ (NSArray *)defaultTopics;

+ (NSArray *)defaultLocalizedTopics;

- (instancetype)initWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics;

@end
