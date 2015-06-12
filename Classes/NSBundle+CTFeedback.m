//
// Created by rizumita on 2013/11/01.
//


#import "NSBundle+CTFeedback.h"

#import "CTFeedbackViewController.h"

@implementation NSBundle (CTFeedback)

+ (NSBundle *)feedbackBundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        NSBundle *classBundle = [NSBundle bundleForClass:[CTFeedbackViewController class]];
        NSURL *bundleURL = [classBundle URLForResource:@"CTFeedback" withExtension:@"bundle"];

        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        } else {
            bundle = [NSBundle mainBundle];
        }
    });

    return bundle;
}

@end