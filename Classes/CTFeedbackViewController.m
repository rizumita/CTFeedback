//
//  CTFeedbackViewController.m
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/10/31.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import "CTFeedbackViewController.h"
#import "CTFeedbackCell.h"
#import "CTFeedbackCellItem.h"
#import "CTFeedbackTopicsViewController.h"
#include <sys/sysctl.h>
#import "NSBundle+CTFeedback.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger, CTFeedbackSection){
    CTFeedbackSectionInput = 0,
    CTFeedbackSectionScreenshot,
    CTFeedbackSectionDeviceInfo,
    CTFeedbackSectionAppInfo
};

@interface CTFeedbackViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic, readonly) NSUInteger selectedTopicIndex;

@property (nonatomic, strong) NSArray *cellItems;

@property (nonatomic, readonly) NSArray *inputCellItems;
@property (nonatomic, readonly) NSArray *deviceInfoCellItems;
@property (nonatomic, readonly) NSArray *appInfoCellItems;
@property (nonatomic, readonly) NSArray *additionCellItems;
@property (nonatomic, strong) CTFeedbackTopicCellItem *topicCellItem;
@property (nonatomic, strong) CTFeedbackContentCellItem *contentCellItem;
@property (nonatomic, strong) CTFeedbackAdditionInfoCellItem *additionCellItem;
@property (nonatomic, readonly) NSString *mailSubject;
@property (nonatomic, readonly) NSString *mailBody;
@property (nonatomic, readonly) NSData *mailAttachment;
@end

@implementation CTFeedbackViewController

+ (CTFeedbackViewController *)controllerWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics
{
    return [[CTFeedbackViewController alloc] initWithTopics:topics localizedTopics:localizedTopics];
}

+ (NSArray *)defaultTopics
{
    return @[
            @"Question",
            @"Request",
            @"Bug Report",
            @"Other"
    ];
}

+ (NSArray *)defaultLocalizedTopics
{
    return @[
            CTFBLocalizedString(@"Question"),
            CTFBLocalizedString(@"Request"),
            CTFBLocalizedString(@"Bug Report"),
            CTFBLocalizedString(@"Other")
    ];
}

- (instancetype)initWithTopics:(NSArray *)topics localizedTopics:(NSArray *)localizedTopics
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.topics = topics;
        self.localizedTopics = localizedTopics;
        self.useHTML = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = CTFBLocalizedString(@"Feedback");

    [self.tableView registerClass:[CTFeedbackCell class] forCellReuseIdentifier:[CTFeedbackTopicCellItem reuseIdentifier]];
    [self.tableView registerClass:[CTFeedbackCell class] forCellReuseIdentifier:[CTFeedbackContentCellItem reuseIdentifier]];
    [self.tableView registerClass:[CTFeedbackCell class] forCellReuseIdentifier:[CTFeedbackInfoCellItem reuseIdentifier]];
    [self.tableView registerClass:[CTFeedbackCell class] forCellReuseIdentifier:[CTFeedbackAdditionInfoCellItem reuseIdentifier]];

    self.cellItems = @[self.inputCellItems, self.additionCellItems ,self.deviceInfoCellItems, self.appInfoCellItems];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CTFBLocalizedString(@"Mail") style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonTapped:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.presentingViewController.presentedViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.contentCellItem removeObserver:self forKeyPath:@"cellHeight"];
}

#pragma mark - Key value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"cellHeight"]) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark -

- (void)cancelButtonTapped:(id)sender
{
    if(self.navigationController != nil){
        if( [self.navigationController viewControllers][0] == self){
            // Can't pop, just dismiss
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            // Can be popped
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setTopics:(NSArray *)topics
{
    _topics = topics;

    self.selectedTopic = _topics.count >= 1 ? _topics[0] : @"";
}

- (NSUInteger)selectedTopicIndex
{
    return [self.topics indexOfObject:self.selectedTopic];
}

- (NSArray *)inputCellItems
{
    NSMutableArray *result = [NSMutableArray array];

    __weak typeof (self) weakSelf = self;

    self.topicCellItem = [CTFeedbackTopicCellItem new];
    self.topicCellItem.topic = self.localizedTopics[self.selectedTopicIndex];
    self.topicCellItem.action = ^(CTFeedbackViewController *sender) {
        CTFeedbackTopicsViewController *topicsViewController = [[CTFeedbackTopicsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        topicsViewController.topics = sender.topics;
        topicsViewController.localizedTopics = sender.localizedTopics;
        topicsViewController.action = ^(NSString *selectedTopic) {
            weakSelf.selectedTopic = selectedTopic;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:CTFeedbackSectionInput];
            CTFeedbackTopicCellItem *cellItem = weakSelf.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
            cellItem.topic = weakSelf.localizedTopics[weakSelf.selectedTopicIndex];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        [sender.navigationController pushViewController:topicsViewController animated:YES];
    };
    [result addObject:self.topicCellItem];

    self.contentCellItem = [CTFeedbackContentCellItem new];
    [self.contentCellItem addObserver:self forKeyPath:@"cellHeight" options:NSKeyValueObservingOptionNew context:nil];
    [result addObject:self.contentCellItem];

    return result.copy;
}

- (NSArray *)additionCellItems{
    NSMutableArray *result = [NSMutableArray array];

	__weak typeof (self) weakSelf = self;

	self.additionCellItem = [CTFeedbackAdditionInfoCellItem new];
    self.additionCellItem.value = CTFBLocalizedString(@"Additional detail");
    self.additionCellItem.action = ^(CTFeedbackViewController *sender){
		UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:weakSelf
                                                        cancelButtonTitle:CTFBLocalizedString(@"Cancel")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:CTFBLocalizedString(@"Camera"), CTFBLocalizedString(@"PhotoLibrary"), nil];
		[choiceSheet showInView:weakSelf.view];
    };

    [result addObject:self.additionCellItem];

    return [result copy];
}

- (NSArray *)deviceInfoCellItems
{
    NSMutableArray *result = [NSMutableArray array];

    CTFeedbackInfoCellItem *platformItem = [CTFeedbackInfoCellItem new];
    platformItem.title = CTFBLocalizedString(@"Device");
    platformItem.value = self.platformString;
    [result addObject:platformItem];

    CTFeedbackInfoCellItem *systemVersionItem = [CTFeedbackInfoCellItem new];
    systemVersionItem.title = CTFBLocalizedString(@"iOS");
    systemVersionItem.value = self.systemVersion;
    [result addObject:systemVersionItem];

    return result.copy;
}

- (NSArray *)appInfoCellItems
{
    NSMutableArray *result = [NSMutableArray array];

    CTFeedbackInfoCellItem *nameItem = [CTFeedbackInfoCellItem new];
    nameItem.title = CTFBLocalizedString(@"Name");
    nameItem.value = self.appName;
    [result addObject:nameItem];

    CTFeedbackInfoCellItem *versionItem = [CTFeedbackInfoCellItem new];
    versionItem.title = CTFBLocalizedString(@"Version");
    versionItem.value = self.appVersion;
    [result addObject:versionItem];

    CTFeedbackInfoCellItem *buildItem = [CTFeedbackInfoCellItem new];
    buildItem.title = CTFBLocalizedString(@"Build");
    buildItem.value = self.appBuild;
    [result addObject:buildItem];

    return result.copy;
}

- (NSString *)platform
{
    int mib[2];
    size_t len;
    char *machine;

    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);

    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

// http://theiphonewiki.com/wiki/Models
- (NSString *)platformString
{
    NSString *platform = [self platform];

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (Global)";

    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";

    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad-4G (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad-4G (GSM)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad-4G (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad mini-1G (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad mini-1G (GSM)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad mini-1G (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini-2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini-2G (Cellular)";

    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";

    return platform;
}

- (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuild
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

- (NSString *)mailSubject
{
    return [NSString stringWithFormat:@"%@: %@", self.appName, self.topics[self.selectedTopicIndex]];
}

- (NSString *)mailBody
{
    NSString *content = self.contentCellItem.textView.text;
    NSString *body;
    
    if (self.useHTML) {
        body = [NSString stringWithFormat:@"<style>td {padding-right: 20px}</style>\
                <p>%@</p><br />\
                <table cellspacing=0 cellpadding=0>\
                <tr><td>Device:</td><td><b>%@</b></td></tr>\
                <tr><td>iOS:</td><td><b>%@</b></td></tr>\
                <tr><td>App:</td><td><b>%@</b></td></tr>\
                <tr><td>Version:</td><td><b>%@</b></td></tr>\
                <tr><td>Build:</td><td><b>%@</b></td></tr>\
                </table>",
                [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
                self.platformString,
                self.systemVersion,
                self.appName,
                self.appVersion,
                self.appBuild];
    } else {
        body = [NSString stringWithFormat:@"%@\n\n\nDevice: %@\niOS: %@\nApp: %@\nVersion: %@\nBuild: %@",
                content,
                self.platformString,
                self.systemVersion,
                self.appName,
                self.appVersion,
                self.appBuild];
    }
    
    if (self.additionalDiagnosticContent) {
        body = [body stringByAppendingString:self.additionalDiagnosticContent];
    }
    
    return body;
}
#pragma mark - Convert image

static NSString * const MIME_TYPE_JPEG = @"image/jpeg";
static NSString * const ATTACHMENT_FILENAME = @"screenshot.jpg";

- (NSData *)mailAttachment{
    return UIImageJPEGRepresentation(self.additionCellItem.screenImage, 0.5);
}

#pragma mark - send email
- (void)sendButtonTapped:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:self.toRecipients];
        [controller setCcRecipients:self.ccRecipients];
        [controller setBccRecipients:self.bccRecipients];
        [controller setSubject:self.mailSubject];
        [controller setMessageBody:self.mailBody isHTML:self.useHTML];
        // Attach an image to the email
        if (self.mailAttachment && [self.mailAttachment length]>0) {
            [controller addAttachmentData:self.mailAttachment mimeType:MIME_TYPE_JPEG fileName:ATTACHMENT_FILENAME];
        }
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CTFBLocalizedString(@"Error")
                                                        message:CTFBLocalizedString(@"Mail no configuration")
                                                       delegate:nil
                                              cancelButtonTitle:CTFBLocalizedString(@"Dismiss")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 3;
    return [self.cellItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellItems[(NSUInteger)section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedbackCellItem *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[cellItem class] reuseIdentifier] forIndexPath:indexPath];

    [cellItem configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case CTFeedbackSectionInput:
            return nil;
        case CTFeedbackSectionScreenshot:
            return CTFBLocalizedString(@"Additional Info");
        case CTFeedbackSectionDeviceInfo:
            return CTFBLocalizedString(@"Device Info");
        case CTFeedbackSectionAppInfo:
            return CTFBLocalizedString(@"App Info");
        default:
            return nil;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedbackCellItem *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    return cellItem.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedbackCellItem *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    if (cellItem.action) cellItem.action(self);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentCellItem.textView resignFirstResponder];
}

#pragma mark - MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    void (^completion)(void) = ^{
        if (self.presentingViewController.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };

    if (result == MFMailComposeResultCancelled) {
        completion = nil;
    } else if (result == MFMailComposeResultFailed && error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CTFBLocalizedString(@"Error")
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:CTFBLocalizedString(@"Dismiss")
                                              otherButtonTitles:nil];
        [alert show];
    }

    [controller dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark UIActionSheetDelegate

- (void)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = sourceType;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0) {
        // camera
        if([self isCameraAvailable]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }

        [self createImagePickerControllerWithSourceType:sourceType];
    } else if (buttonIndex == 1) {
        // PhotoLibrary
        [self createImagePickerControllerWithSourceType:sourceType];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:CTFeedbackSectionScreenshot];
        CTFeedbackAdditionInfoCellItem *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];

        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil){
			image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        cellItem.screenImage = image;
        //        cellItem.value = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
@end
