//
// Created by rizumita on 2013/11/01.
//


#import <Foundation/Foundation.h>

#define CTFBLocalizedString(key) [[NSBundle feedbackBundle] localizedStringForKey:key value:nil table:@"CTFeedbackLocalizable"]

@interface NSBundle (CTFeedback)

+ (NSBundle *)feedbackBundle;

@end