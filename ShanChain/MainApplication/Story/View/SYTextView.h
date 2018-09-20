#import <UIKit/UIKit.h>

@interface SYTextView : UITextView

@property (copy, nonatomic) NSString   *placeholder;

@property (strong, nonatomic) UIColor  *placeholderColor;

@property (assign, nonatomic) int  *maxWordNum;

- (void)insertMention:(NSString *)name withCharacterId:(NSString *)characterId;

- (void)insertTopic:(NSString *)name withTopicId:(NSString *)topicId;

- (NSArray *)generateIntroduction;

@end
