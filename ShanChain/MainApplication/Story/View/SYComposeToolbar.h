//
//  SYComposeToolbar.h
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYComposeToolbarButtonType) {
    SYComposeToolbarButtonTypeNone,
    SYComposeToolbarButtonTypePicture,//相册
    SYComposeToolbarButtonTypeMention,//提到@
    SYComposeToolbarButtonTypeTrend,//话题
    SYComposeToolbarButtonTypeAlert,//弹框
    SYComposeToolbarButtonTypeSwitch,//长文或普通
    SYComposeToolbarButtonTypePreView //预览
};

typedef NS_ENUM(NSInteger, ICChatBoxStatus) {
    ICChatBoxStatusNothing,     // 默认状态
    ICChatBoxStatusShowVoice,   // 录音状态
    ICChatBoxStatusShowFace,    // 输入表情状态
    ICChatBoxStatusShowMore,    // 显示“更多”页面状态
    ICChatBoxStatusShowKeyboard,// 正常键盘
    ICChatBoxStatusShowVideo    // 录制视频
};

typedef NS_ENUM(NSInteger, SYComposeToolbarShowType) {
    SYComposeToolbarShowTypeTopic,         // 话题 动态
    SYComposeToolbarShowTypeNovelTitle,         // 长文小说 标题
    SYComposeToolbarShowTypeNovelBody         // 长文小说 正文
    
};

@class SYComposeToolbar;

@protocol  SYComposeToolbarDelegate<NSObject>

- (void)composeTool:(SYComposeToolbar *)toolbar didClickedButton:(SYComposeToolbarButtonType)buttonType;

- (void)chatBox:(SYComposeToolbar *)chatBox changeStatusForm:(ICChatBoxStatus)fromStatus to:(ICChatBoxStatus)toStatus;

- (void)composeToolSwitchBtn:(BOOL )isButtonOn;

@end

@interface SYComposeToolbar : UIView

@property (strong, nonatomic)id <SYComposeToolbarDelegate> delegate;

@property (assign, nonatomic) int     index;

@property (assign, nonatomic) SYComposeToolbarShowType showType;
/** 保存状态 */
@property (assign, nonatomic) ICChatBoxStatus status;

- (void)changeComposeToolBarShowType:(SYComposeToolbarShowType)type;

- (void)hiddenSwithBtn;

@end
