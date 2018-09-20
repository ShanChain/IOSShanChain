//
//  SYWordEditView.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/1.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYWordEditView : UITextView

@property (strong, nonatomic) UITextField *titleTextField;

@property (assign, nonatomic) BOOL isTitleEditing;

@property (assign, nonatomic) int maxWordNum;

- (void)setPlaceholder:(NSString *)text;

- (void)becomeResponder;

- (void)insertImage:(UIImage *)image;

- (void)insertTopic:(NSString *)topic;

- (NSMutableArray *)generateContentBodyWithImageURLArray:(NSDictionary *)imageDictionary forLocalPreview:(BOOL)preview;

- (NSMutableDictionary *)getImageDictionary;

- (NSMutableArray *)getImageArray;

- (NSString *)generateIntroduction;

@end
