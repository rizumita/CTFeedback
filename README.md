CTFeedback
==========

Library to send feedback for iOS. iOS >=  6.0

![Screenshot](https://raw.github.com/rizumita/CTFeedback/master/CTFeedback.png)

Install
----------
To  install  by  CocoaPods
```Ruby
pod 'CTFeedback'
```

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
