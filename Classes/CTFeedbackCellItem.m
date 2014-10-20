//
// Created by rizumita on 2013/10/31.
//


#import "CTFeedbackCellItem.h"
#import "NSBundle+CTFeedback.h"

#define ContentCellHeight 100

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CTFeedbackCellItem
{

}

+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleDefault;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self.class);
}

- (CGFloat)cellHeight
{
    return 44.0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end


@implementation CTFeedbackTopicCellItem

+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleValue1;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = CTFBLocalizedString(@"Topic");
    }
    return self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];

    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.topic;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end


@implementation CTFeedbackContentCellItem

- (id)init
{
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 310, ContentCellHeight)];
        self.textView.text = self.content;
        self.textView.delegate = self;
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];

    [cell.contentView addSubview:self.textView];
}

- (CGFloat)cellHeight
{
    return MAX(ContentCellHeight, self.textView.contentSize.height);
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willChangeValueForKey:@"cellHeight"];

    CGRect frame = self.textView.frame;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.textView sizeToFit];
        [self.textView layoutIfNeeded];
    }

    frame.size.height = MAX(ContentCellHeight, self.textView.contentSize.height);
    self.textView.frame = frame;

    [self didChangeValueForKey:@"cellHeight"];
}

@end


@implementation CTFeedbackInfoCellItem

+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleValue1;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];

    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.value;
}

@end


@implementation CTFeedbackAdditionInfoCellItem

+ (UITableViewCellStyle)cellStyle
{
    return UITableViewCellStyleValue1;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];

    cell.imageView.image = self.screenImage;
    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.value;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end
