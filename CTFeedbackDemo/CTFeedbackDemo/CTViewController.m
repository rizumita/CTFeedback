//
//  CTViewController.m
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/10/31.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import "CTViewController.h"
#import "CTFeedbackViewController.h"
#import "CTAppDelegate.h"

@interface CTViewController () <CTFeedbackViewControllerDelegate>

@end

@interface UIWindow(CTViewController)

- (UIImage *)ct_snapshot;

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackButtonTapped:(id)sender
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];

    if ([UIApplication sharedApplication] != nil &&
        [[UIApplication sharedApplication].delegate window] != nil) {
        feedbackViewController.screenshot = [[[UIApplication sharedApplication].delegate window] ct_snapshot];
    }
    
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (IBAction)modalFeedbackButtonTapped:(id)sender
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.toRecipients = @[@"ctfeedback@example.com"];

    if ([UIApplication sharedApplication] != nil &&
        [[UIApplication sharedApplication].delegate window] != nil) {
        feedbackViewController.screenshot = [[[UIApplication sharedApplication].delegate window] ct_snapshot];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)customFeebackButtonTapped:(id)sender
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.showsUserEmail = YES;
    feedbackViewController.useCustomCallback = YES;
    feedbackViewController.delegate = self;

    if ([UIApplication sharedApplication] != nil &&
        [[UIApplication sharedApplication].delegate window] != nil) {
        feedbackViewController.screenshot = [[[UIApplication sharedApplication].delegate window] ct_snapshot];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)simpleFeebackButtonTapped:(id)sender
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.hidesAdditionalContent = YES;
    feedbackViewController.hidesAppBuildCell = YES;
    feedbackViewController.hidesAppNameCell = YES;
    feedbackViewController.hidesAppVersionCell = YES;
    feedbackViewController.hidesTopicCell = YES;
    feedbackViewController.mailSubject = @"Simple Title";

    if ([UIApplication sharedApplication] != nil &&
        [[UIApplication sharedApplication].delegate window] != nil) {
        feedbackViewController.screenshot = [[[UIApplication sharedApplication].delegate window] ct_snapshot];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)feedbackViewController:(CTFeedbackViewController *)controller
   didFinishWithCustomCallback:(NSString *)email
                         topic:(NSString *)topic
                       content:(NSString *)content
                    attachment:(UIImage *)attachment
{
    if (!email.length) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter E-mail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    if (!content.length) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter your message!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    NSLog(@"User email: %@", email);
    NSLog(@"Topic: %@", topic);
    NSLog(@"Content: %@", content);
    NSLog(@"Attachment: %@", attachment);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your message has been send!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

@implementation UIWindow(CTViewController)

- (UIImage *)ct_snapshot
{
    UIScreen* mainScreen = [UIScreen mainScreen];
    if (mainScreen == nil) {
        return nil;
    }

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, [mainScreen scale]);

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (currentContext == nil) {
        return nil;
    }

    [[self layer] renderInContext:currentContext];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

@end