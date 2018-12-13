//
//  UrlConstants.h
//  ShanChain
//
//  Created by flyye on 2017/10/24.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#ifndef UrlConstants_h
#define UrlConstants_h

#define  SPACE_ROLE_MODEL @"/v1/character/model/query/modelId"
#define  CHANGE_SPACE_ROLE_MODEL @"/v1/character/model/modify"
#define  CHANGE_USER_CHARACTER @"/v1/character/modify"
#define  DELETE_USER_CHARACTER @"/v1/character/delete"
#define  DELETE_SPACE_ROLE_MODEL @"/v1/character/model/delete"
#define  CANCEL_FOCUS_SOMEONE @"/v1/focus/unfocus"
#define  CANCEL_SUPPORT_CHARACTER @"/v1/character/model/unSupport"
#define  CHEATE_USER_CHARACTER @"/v1/character/create"
#define  GET_MY_FOCUS_LIST @"/v1/focus/myFocus"
#define  GET_MY_FUNS_LIST @"/v1/focus/funs"
#define  FIND_MODEL_BY_NAME @"/v1/character/model/query/name"
#define  FIND_CHARACTER_LIST_BY_USER @"/v1/character/query/userId"
#define  FIND_CHARACTER_BY_CHARID @"/v1/character/query"
#define  CHREATE_USER_MODEL @"/v1/character/model/create"
#define  ADD_CHATACTER_FOCUS @"/v1/focus/focus"
#define  ADD_CHATACTER_SUPPORT @"/v1/character/model/support"
#define  FIND_MODEL_LIST_ORDER @"/v1/character/model/list/spaceId"
#define  FIND_MODEL_BY_TAG @"/v1/character/query/tag/id"
#define  MODIFY_SPACE_ANNO @"/v1/spaceAnno/modify"
#define  DELETE_SPACE_ANNO @"/v1/spaceAnno/delete"
#define  DELETE_SPACE_NEWS @"/v1/spaceNews/delete"
#define  DELETE_SPACE_NOTICE @"/v1/spaceNotice/delete"
#define  UPDATE_SPACE_NEWS @"/v1/spaceNews/modify"
#define  FIND_ANNO_LIST_BY_TITLE @"/v1/spaceAnno/list"
#define  FIND_NEWS_LIST_BY_TITLE @"/v1/spaceNews/list"
#define  GET_NEWS_BY_ID @"/v1/spaceNews/query"
#define  FIND_NOTICE_LIST_BY_SPACE @"/v1/spaceNotice/list"
#define  CHREATE_SPACE_ANNO @"/v1/spaceAnno/create"
#define  CHREATE_SPACE_NEWS @"/v1/spaceNews/create"
#define  CHREATE_SPACE_NOTICE @"/v1/spaceNotice/create"
#define  MODIFY_SPACE @"/v1/space/modify"
#define  MODIFY_SPACE_BG_TEXT @"/v1/space/bgtext/modify"
#define  DELETE_SPACE_IMGS @"/v1/space/pic/del"
#define  CREATE_SPACE @"/v1/space/create"
#define  DELETE_SPACE @"/v1/space/delete"
#define  DELETE_SPACE_BG_TEXT @"/v1/space/bgtext/del"
#define  CANCEL_FOCUS_SPACE @"/v1/space/unFavorite"
#define  FOCUS_SPACE @"/v1/space/favorite"
#define  ALL_SPACE @"/v1/space/list/all"
#define  GET_SPACE_IMGS @"/v1/space/pic/list"
#define  GET_SPACE_BY_ID @"/v1/space/get/id"
#define  GET_SPACE_LIST_BY_IDS @"/v1/space/list/spaceId"
#define  FIND_SPACE_LIST_BY_NAME @"/v1/space/list/name"
#define  ADD_SPACE_IMG @"/v1/space/pic/add"
#define  ADD_SPACE_BG_TEXT @"/v1/space/bgtext/create"
#define  ADD_SPACE_MANAGER @"/v1/spaceManager/create"
#define  SWITCH_SPACE @"/v1/space/switch"
#define  DELETE_SPACE_MANAGER @"/v1/spaceManager/delete"
#define  ADD_TAG_FOR_SPACE @"/v1/space/tag/add"
#define  DELETE_SPACE_TAG @"/v1/space/tag/remove"
#define  GET_MY_FOCUS_SPACE_LIST @"/v1/space/list/favorite"
#define  GET_SPACE_MANAGER_LIST @"/v1/spaceManager/list"
#define  GET_SPACE_BGTEXT_LIST @"/v1/space/bgtext/list"
#define  FIND_SPACE_LIST_BY_TAG @"/v1/space/list/tag"
#define  REPORT_STOTY @"/v1/story/report"
#define  UPDATE_STORY @"/v1/story/update"
#define  DELETE_STORY @"/v1/story/delete"
#define  DELETE_STORY_COMMENT @"/v1/story_comment/delete"
#define  ADD_STORY @"/v1/story/add"
#define  BLOCK_STORY @"/v1/story/block"
#define  RECOVERY_STORY @"/v1/story/recovery"
#define  ADD_STORY_COMMENT @"/v1/story_comment/add"
#define  ADD_STORY_SUPPORT @"/v1/story/support/add"
#define  REMOVE_COMMENT_SUPPORT @"/v1/story_comment/support/remove"
#define  ADD_COMMENT_SUPPORT @"/v1/story_comment/support/add"
#define  GET_STORY_LINE_BY_ID @"/v1/story/chain/id"
#define  FIND_CHARACTER_LIST_BY_MODEL @"/v1/character/query/modelId"
#define  FIND_TOPIC_LIST_BY_SPACEID @"/v1/topic/query/spaceId"
#define  FIND_BACKGROUND_BY_USER @"/v1/userinfo/background"
#define  USER_FEEDBACK @"/v1/feedback/user"
#define  RECOMMEND_HOT_LIST @"/v1/recommend/hot"
#define  RECOMMEND_STORY_LIST_FOCUS @"/v1/recommend/focus"
#define  RECOMMEND_STORY_LIST @"/v1/recommend/rate"
#define  STORY_LIST_BY_CHARACTER @"/v1/dynamic/character"
#define  SET_DEVICE_TOKEN @"/v1/user/deviceToken"
#define  BIND_OTHER_ACCOUNT @"/v1/user/bind_other_account"
#define  Feedback_URL @"/v1/feedback/user"  //意见反馈


#define  GETCOORDINATE  @"/v1/lbs/coordinate/infos" // 获取当前位置及周边聊天室信息
#define  COORDINATEINFO  @"/v1/lbs/coordinate/info" // 获获取当前位置聊天室信息



#pragma mark - 登录注册
//创建用户
#define COMMONUSERLOGINTHIRD @"/v1/user/third_login"

//注册
#define COMMONUSERREGISTER @"/v1/user/register"

//获取验证码
#define COMMONSMSUNLOGINVERIFYCODE @"/v1/sms/unlogin/verifycode"

#define COMMONCHECKVERSION @"/oss/apk/get/latest"
//登录
#define COMMONUSERLOGIN @"/v1/user/login"

//1.5修改密码
#define COMMONUSERRESETPASSWORD @"/v1/user/reset_password"

//意见反馈
#define COMMONUSERINFOGET @"/v1/userinfo/get"

//注册环信用户
#define COMMONHXUSERREGISTER @"/hx/user/regist"

// 获取登录验证码
#define  Verifycode_URL  @"/v1/2.0/sms/login/verifycode"
// 验证码登录
#define  Sms_login_URL   @"/v1/2.0/user/sms_login"

// 三方授权登录
#define  Third_login_URL @"/v1/2.0/user/third_login"


#pragma mark ----------- 点亮元社区-------------------

#define  Countdown_URL @"/v1/2.0/light/countdown"  // 活动倒计时


#pragma mark ----------- 故事 -------------------
//点赞
#define  STORYSUPPORTADD @"/v1/story/support/add"

//取消点赞
#define  STORYSUPPORTREMOVE @"/v1/story/support/remove"

//添加小尾巴
#define  STORYTAILADD @"/v1/tail/add"

//标签列表
#define STORYTAGQUERY @"/v1/tag/query"

#define STORYSPACELISTBYNAME @"/v1/space/list/name"


// 给时空添加标签
#define STORYSPACETAGADD @"/v1/space/tag/add"

// 收藏时空
#define STORYFAVORITE @"/v1/space/favorite"

// 取消收藏
#define STORYSPACEUNFAVORITE @"/v1/space/unFavorite"

// 查找时空人物模型
#define STORYCHARACTERMODELQUERYSPACEID @"/v1/character/model/query/spaceId"

// 获取收藏的时空
#define STORYSPACELISTFAVORITE @"/v1/space/list/favorite"

// 添加标签
#define STORYTAGCREATE @"/v1/tag/create"

//上传图片
#define STORYUPLOADAPP @"/oss/upload/app"

//发布动态
#define STORYADD @"/v1/story/add"

//转发动态
#define STORYTRANSMIT @"/v1/story/transpond"
// 是否点赞
#define STORYISFAVORITE @"/v1/story/isFav"
// 是否关注
#define FRIENDISFAVORITE @"/v1/focus/isFav"

#define FRIENDADDFOLLOW @"/v1/focus/focus"

#define FRIENDREMOVEFOLLOW @"/v1/focus/unfocus"

//获取评论列表
#define STORYCOMMENTLIST @"/v1/storyComment/query"

//新建评论
#define STORYCOMMENTADD @"/v1/storyComment/add"

//评论点赞
#define STORYCOMMENTSUPPORTADD @"/v1/storyComment/support/add"

//取消评论点赞
#define STORYCOMMENTSUPPORTREMOVE @"/v1/storyComment/support/remove"

//创建时空
#define STORYSPACECREATE @"/v1/space/create"
// 创建话题
#define STORYTOPICCREATE @"/v1/topic/create"

//创建角色
#define STORYCHARATERCREATE @"/v1/character/model/create"

//举报故事
#define STORYREPORT @"/v1/story/report/create"

//屏蔽人
#define STORYBLOCK @"/v1/story/block"

//话题列表
#define STORYQUERYNAME @"/v1/topic/query/name"

//获取世界的话题
#define TOPICLISTINSPACE @"/v1/topic/query/spaceId"

//通过故事id列表获取故事
#define STORYGET @"/v1/story/get"

//获取时空联系人列表
#define STORYCHARACTERMODELLISTSPACEID @"/v1/character/model/list/spaceId"

//查找我关注的列表
#define STORYFOCUSQUERY @"/v1/focus/query"

//查找我联系人
#define STORYFOCUSCONTACTS @"/v1/focus/contacts"

//切换角色
#define STORYCHARACTERCHANGE @"/v1/character/change"

// 获取用户信息
#define STORYCHARACTQUERYBYID @"/v1/character/query"

//获取话题，小说，故事列表
#define STORYRECOMMENDDETAIL @"/v1/recommend/detail"

// 获取就是简要信息
#define STORYCAHRACTERQUERYBRIEF @"/v1/character/query/brief"

//通过id查找话题
#define STORYTOPICQUERY @"/v1/topic/query"

#define STORYTOPICQUERYBYID @"/v1/topic/query/id"

#define STORYListByTOPICID @"/v1/dynamic/topic"

//获取当前角色
#define STORYCHARACTERGETCURRENT @"/v1/character/get/current"

//提交videoID和imageURL到服务器
#define PLAY_ADD_URL            @"/v1/play/add"

// 分享
#define SHARE_SAVE              @"/v1/share/save"

// 举报用户
#define REPORT_USER_URL         @"/v1/user/report/create"

// 删除评论
#define COMMENT_DELETE_URL      @"/v1/storyComment/delete"

#pragma mark -IM接口

//创建大戏
#define HXGAMECREATE @"/hx/game/create"

//大戏签到
#define HXGANMESIGNIN @"/hx/game/signIn"

//大戏签退
#define HXGAMESIGNOUT @"/hx/game/signOut"

//获取大戏列表
#define HXGAMELIST @"/hx/game/list"

//获取群公告列表
#define HXGROUPNOTICEGET @"/hx/group/notice/get"

//修改群信息
#define HXGROUPMODIFY @"/hx/group/modify"

//添加群公告
#define HXGROUPNOTICEADD @"/hx/group/notice/add"

//移除群公告
#define HXGROUPNOTICEDELETE @"/hx/group/notice/delete"

//添加好友
#define HXUSERADDFRIEND @"/hx/user/addFriend"

//查找群
#define HXGROUPQUERY @"/hx/group/query"
#define HXGROUPMEMBERQUERY @"/hx/group/members"

//根据HXID批量查询用户信息
#define HXUSERQUERYBATCH @"/hx/user/hxUserName/list"

#define HXGROUPQUERYBATCH @"/hx/group/list"

#define HXUSERQUERY @"/hx/user/query"

//查找我所在的群
#define HXGROUPMYGROUP @"/hx/group/myGroup"

//创建群
#define HXGROUPCREATE @"/hx/group/create"

//退群
#define HXGROUPMEMBERREMOVE @"/hx/group/rmMember"

//根据characterId查找环信联系人
#define HXUSERLIST @"/hx/user/list"

#pragma mark --------------------------------- AliyunPlayer --------------------------
#define ALIYUNPLAYERUPLOADER @"/oss/video/uploadAuth/app"

#pragma mark -----------------------  Play ---------------------------------
//#define PLAYADD @"/v1/play/add"

#endif /* UrlConstants_h */

