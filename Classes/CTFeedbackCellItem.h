//
// Created by rizumita on 2013/10/31.
//


#import <Foundation/Foundation.h>


@interface CTFeedbackCellItem : NSObject

+ (UITableViewCellStyle)cellStyle;
+ (NSString *)reuseIdentifier;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, copy) void (^action)(id sender);

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@interface CTFeedbackTopicCellItem : CTFeedbackCellItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topic;

@end


@interface CTFeedbackContentCellItem : CTFeedbackCellItem <UITextViewDelegate>

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UITextView *textView;
@end


@interface CTFeedbackInfoCellItem : CTFeedbackCellItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

@end

@interface CTFeedbackAdditionInfoCellItem : CTFeedbackCellItem

@property (nonatomic, strong) UIImage *screenImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end
