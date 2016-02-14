CTFeedback
==========

CTFeedback is a library to send feedback for iOS 6.0+.

![Screenshot](https://raw.github.com/rizumita/CTFeedback/master/CTFeedback.png)

Install
----------
CTFeedback is on [CocoaPods](http://cocoapods.org). Simply add:

```Ruby
pod 'CTFeedback'
```

to your Podfile.

Example
----------
```Objective-C
CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
feedbackViewController.toRecipients = @[@"ctfeedback@example.com"];
feedbackViewController.useHTML = NO;
[self.navigationController pushViewController:feedbackViewController animated:YES];
```

Sample Output
----------

###Plaintext Email:

> Device: iPhone 5s (GSM)

> iOS: 7.0.4

> App: CTFeedbackDemo

> Version: 1.0.1

> Build: 1.0.1

###HTML Email:

><table cellspacing=0 cellpadding=0>
	<tr><td>Device:</td><td><b>iPhone 5s (GSM)</b></td></tr>
	<tr><td>iOS:</td><td><b>7.0.4</b></td></tr>
	<tr><td>App:</td><td><b>CTFeedbackDemo</b></td></tr>
	<tr><td>Version:</td><td><b>1.0.1</b></td></tr>
	<tr><td>Build:</td><td><b>1.0.1</b></td></tr>
</table>

Custom Feedback via your server API
----------

You also can use your own server API to send feedback.
It can be useful if user has no E-mail account on device or else.

To use custom callback set `useCustomCallback` to `YES`.
If you want to let user input his E-mail, set `showUserEmail` to `YES`.


```
CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
feedbackViewController.showsUserEmail = YES;
feedbackViewController.useCustomCallback = YES;
feedbackViewController.delegate = self;
[self.navigationController pushViewController:feedbackViewController animated:YES];
```

Also implement delegate function: 
```
- (void)feedbackViewController:(CTFeedbackViewController *)controller
   didFinishWithCustomCallback:(NSString *)email
                         topic:(NSString *)topic
                       content:(NSString *)content
                    attachment:(UIImage *)attachment
```

See demo for more details.

License
----------

MIT license
