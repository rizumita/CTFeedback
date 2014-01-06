CTFeedback
==========

CTFeedback is a library to send feedback for iOS 6.0+.

![Screenshot](https://raw.github.com/rizumita/CTFeedback/master/CTFeedback.png)

Install
----------
CTFeedback is on [Cocoapods](http://cocoapods.org). Simply add:

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

License
----------

MIT license
