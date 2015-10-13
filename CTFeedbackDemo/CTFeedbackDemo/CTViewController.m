//
//  CTViewController.m
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/10/31.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import "CTViewController.h"
#import "CTFeedbackViewController.h"

@interface CTViewController () <CTFeedbackViewControllerDelegate>

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
    feedbackViewController.showsUserEmail = YES;
    feedbackViewController.hidesAdditionalContent = YES;
    feedbackViewController.useCustomCallback = YES;
    feedbackViewController.delegate = self;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (IBAction)modalFeedbackButtonTapped:(id)sender
{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.toRecipients = @[@"ctfeedback@example.com"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)feedbackViewController:(CTFeedbackViewController *)controller didFinishWithCustomCallback:(NSString *)email topic:(NSString *)topic content:(NSString *)content
{
    NSLog(@"User email: %@", email);
    NSLog(@"Topic: %@", topic);
    NSLog(@"Content: %@", content);
}

@end
