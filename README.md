CTFeedback
==========

UI Component to feedback for iOS

Example
----------

```Objective-C
CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
feedbackViewController.toRecipients = @[@"ctfeedback@example.com"];
[self.navigationController pushViewController:feedbackViewController animated:YES];
```

License
----------

MIT license