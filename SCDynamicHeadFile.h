//
//  SCDynamicHeadFile.h
//  ShanChain
//
//  Created by MoShen-Sugar on 2017/5/26.
//  Copyright © 2017年 krew. All rights reserved.
//

#ifndef SCDynamicHeadFile_h
#define SCDynamicHeadFile_h

//热门Cell相关信息
#define DSStatusToolbarHeight 38
#define DSStatusCellMargin 5
#define DSStatusCellInset 15
#define DSStatusCellIconEdge 40
#define DSStatusOriginalNameFont [UIFont systemFontOfSize:12]
#define DSStatusOriginalTimeFont [UIFont systemFontOfSize:12]
#define DSStatusOriginalSourceFont DSStatusOriginalTimeFont
#define DSStatusRetweetedNameFont [UIFont systemFontOfSize:18]
#define DSStatusOriginalDidMoreNotication @"StatusOriginalDidMoreNotication"
#define SCContentIconImageDidClickNotication @"ContentIconImageDidClickNotication"
#define DSKindStoryDidClickNotication @"KindStoryDidClickNotication"
#define SCChallengeHeadFreshDidClickNotication @"SCChallengeheadViewNotication"
#define SCChallengeHeadPickerDidClickNotication @"ChallengeHeadPickerDidClickNotication"
#define SCChallengeHeadDetailRuleDidClickNotication @"ChallengeHeadDetailDidClickNotication"
#define SCChallengeBtnActionNotication @"ChallengeBtnDidClickNotication"
#define SCHappierDidClickNotication @"HappierDidClickNotication"
#define SCBowDidClickNotication @"BowDidClickNotication"
#define SCWalkMoreDidClickNotication @"WalkMoreDidClickNotication"
#define SCSleepDidClickNotication @"SleepDidClickNotication"
#define SCPersonalConcernBtnClickNotication @"ConcernBtnClickNotication"
#define SCNoBowStartBtnClickNotication @"BowStartBtnClickNotication"
#define SCWalkDetailQuitBtnClickNotication @"WalkDetailQuitBtnClickNotication"
#define SCWalkChallengeAttendBtnClickNotication @"WalkDetailQuitBtnClickNotication"
#define SCSleepChallengeClickNotication @"SleepChallengeClickNotication"
#define SCNightMarketOtherClickNotication @"NightMarketOtherClickNotication"
#define SCMarketDetailHeadClickNotication @"MarketDetailHeadClickNotication"
#define SCWelfareProjectDetailActionClickNotication @"WelfareProjectDetailActionClickNotication"
#define SCWelfareProjectSureDemotionActionClickNotication @"WelfareProjectSureDemotionActionClickNotication"

#define SCStoryListHeadViewActionClickNotication @"StoryListHeadViewActionClickNotication"
#define SCStoryFooterViewCollectionNotication @"StoryHomeFooterViewCollectionNotication"
#define SCStoryNowRouteCellHeadIconActionNotication @"StoryNowRouteCellHeadIconActionNotication"

#define SCStoryNowRouteCellTipViewActionNotication @"StoryNowRouteCellTipViewActionNotication"

#define SCIncorporateActionNotication @"IncorporateActionNotication"
#define SCBifurcationBtnClickActionNotication @"BifurcationBtnClickActionNotication"

#define SCCurrentRouteViewActionNotication @"CurrentRouteViewActionNotication"
#define SCSupportBtnClickActionNotication @"SupportBtnClickActionNotication"

#define SCStoryCityDesitionBtnClickNotication @"StoryCityDesitionBtnClickNotication"
#define SCDreamClockBtnClickNotication @"DreamClockBtnClickNotication"
#define SCTimePoutBtnClickNotication @"TimePoutBtnClickNotication"
#define SCMountainRoadBtnClickNotication @"MountainRoadBtnClickNotication"

#define SCStoryHomeDynamicBtnClickNotication @"StoryHomeDynamicBtnClickNotication"

#define SCStoryHomeItemClickNotication @"StoryHomeItemClickNotication"


/**新增*/
#define SYStoryDidReportNotication @"SYStoryDidReportNotication"

/**对话*/
#define SYMessageDidDramaBtnClickNotication @"SYMessageDidDramaBtn"
#define SYMessageDidScreenBtnClickNotication @"SYMessageDidScreenBtn"
#define SYMessageDidMentionBtnClickNotication @"SYMessageDidMentionBtn"
#define SYMessageDidAlertBtnClickNotication @"SYMessageDidAlertBtn"

/**场内的人更多按钮*/
#define SYScreenInsideDidArrowClickBtnActionNotication @"SYScreenInside"

// 富文本字体
#define DSStatusRichTextFont [UIFont systemFontOfSize:18]
// 转发正文字体
#define DSStatusHighTextColor SWColor(93, 123, 169)
// 表情的最大行数
#define DSEmotionMaxRows 3
// 表情的最大列数
#define DSEmotionMaxCols 7
// 每页最多显示多少个表情
#define DSEmotionMaxCountPerPage (DSEmotionMaxRows * DSEmotionMaxCols - 1)
// 表情选择通知
#define DSEmotionDidSelectedNotification @"EmotionDidSelectedNotification"
// 表情选择是emotion key
#define DSSelectedEmotion @"SelectEmotionKey"
#define DSEmotionDidDeletedNotification @"EmotionDidDeletedNotification"
// 富文本链接通知
#define DSLinkDidSelectedNotification @"DSLinkDidSelectedNotification"
// 转发的字体颜色
#define DSStatusRetweededTextColor DSColor(111, 111, 111)
// 普通文本通知
#define DSStatusNormalTextDidSelectedNotification @"DSStatusNormalTextDidSelectedNotification"

#endif /* SCDynamicHeadFile_h */
