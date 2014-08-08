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

@protocol CTFeedbackViewControllerDelegate;

@interface CTFeedbackViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak) id <CTFeedbackViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *localizedTopics;

/*
 * selectedTopic's default value is first item of topics.
 */
@property (nonatomic, strong) NSString *selectedTopic;

@property (nonatomic, assign) BOOL hidesAppNameCell;
@property (nonatomic, assign) BOOL hidesAppVersionCell;
@property (nonatomic, assign) BOOL hidesAppBuildCell;

@property (nonatomic, readonly) NSString *platformString;
@property (nonatomic, readonly) NSString *systemVersion;
@property (nonatomic, readonly) NSString *appName;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuild;

@property (nonatomic, strong) NSArray *toRecipients;

@property (nonatomic, strong) NSArray *ccRecipients;

@property (nonatomic, strong) NSArray *bccRecipients;

@property (nonatomic, strong) NSString *additionalDiagnosticContent;
@property (assign) BOOL useHTML;

+ (CTFeedbackViewController *)controllerWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics;

+ (NSArray *)defaultTopics;

+ (NSArray *)defaultLocalizedTopics;

- (instancetype)initWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics;

@end

@protocol CTFeedbackViewControllerDelegate <NSObject>
@optional
- (void)feedbackViewController:(CTFeedbackViewController *)controller didFinishWithMailComposeResult:(MFMailComposeResult)result error:(NSError *)error;

@end