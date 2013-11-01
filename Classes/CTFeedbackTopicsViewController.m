//
//  CTFeedbackTopicsViewController.m
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2013/11/01.
//  Copyright (c) 2013年 CAPH. All rights reserved.
//

#import "CTFeedbackTopicsViewController.h"

static NSString *CTFeedbackTopicsViewControllerCellIdentifier = @"Cell";

@interface CTFeedbackTopicsViewController ()

@end

@implementation CTFeedbackTopicsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedStringFromTable(@"Topics", @"CTFeedbackLocalizable", @"Topics");

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CTFeedbackTopicsViewControllerCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *topic = self.localizedTopics[(NSUInteger)indexPath.row];
    cell.textLabel.text = topic;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CTFeedbackTopicsViewControllerCellIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedTopic = self.topics[(NSUInteger)indexPath.row];
    if (self.action) self.action(selectedTopic);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
