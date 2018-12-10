//
//  SCConstants.h
//  ShanChain
//
//  Created by MoShen-Sugar on 2017/5/26.
//  Copyright © 2017年 krew. All rights reserved.
//

#ifndef SCConstants_h
#define SCConstants_h

//尺寸
#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height

#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width

#define KSCMargin 15.0

#define KSYBetweenMargin 8.0f
// 视图背景色
#define Theme_ViewBackgroundColor  RGB(245, 245, 245)
#define Theme_MainTextColor   [UIColor colorWithString:@"#333333"]

//AppDelegate
#define App_Delegate ((AppDelegate*)[[UIApplication sharedApplication]delegate])

#define App_RootCtr  [UIApplication sharedApplication].keyWindow.rootViewController

//weakSelf
#define WEAKSELF __weak typeof(self) weakSelf = self;

//Font
#define SCFont(FONTSIZE)  [UIFont systemFontOfSize:(FONTSIZE)]

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil)  || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#define SCBOLDFont(FONTSIZE)  [UIFont boldSystemFontOfSize:(FONTSIZE)]

//#define SCColorA(r, g, b, r) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(r)]

#define SCRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define SEARCHBACKGROUNDCOLOR  [UIColor colorWithRed:(110.0)/255.0 green:(110.0)/255.0 blue:(110.0)/255.0 alpha:0.4]

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

//iOS系统版本
#define iOS9x_systemVersion [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f
#define iOS8x_systemVersion [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f
#define iOS7x_systemVersion ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define iOS6x_systemVersion [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iOSNot6x_systemVersion [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

//* ========= 颜色值 ========== */

// 主题背景颜色值 [浅色背景view]

// 项目中cell线的颜色值 [浅灰色线]

//* 字号色 */

/** 消息扩展参数用户头像key值*/
#define HX_EXT_MSG_HEAD_IMG @"headImg"
/** 消息扩展参数群头像key值*/
#define HX_EXT_MSG_GROUP_IMG @"groupImg"
/** 消息扩展参数用户昵称key值*/
#define HX_EXT_MSG_NICK_NAME @"nickName"
/** 消息扩展参数消息类型key值 int*/
#define HX_EXT_MSG_ATTR @"msgAttr"
/**消息扩展参数是否是群信息key值*/
#define HX_EXT_MSG_IS_GROUP @"isGroup"
/** 消息扩展参数消息中@人的数组*/
#define HX_EXT_MSG_AT_LIST @"msgAtList"

#define HX_EXT_MSG_CHARACTER @"characterId"

//* 路径 */
#define kDiscvoerVideoPath @"Download/Video"  // video子路径
#define kChatVideoPath @"Chat/Video"  // video子路径
#define kVideoType @".mp4"        // video类型 mp4
#define kRecoderType @".wav"      // video类型 wav
#define kRecodAmrType @".amr"

#define kChatRecoderPath @"Chat/Recoder"



#endif /* SCConstants_h */
