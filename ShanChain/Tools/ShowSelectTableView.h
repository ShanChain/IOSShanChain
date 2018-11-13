//
//  ShowSelectTableView.h
//  TYWithHHSProject
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowSelectEntity;

#define   SELECT_TAB_HEIGHT   45

typedef NS_ENUM(NSInteger,ShowSelectEntityClickType) {
    ShowSelectEntityClickType_Nomal,
    ShowSelectEntityClickType_Venue,
    ShowSelectEntityClickType_State,
    ShowSelectEntityClickType_PeopleNumner,
    ShowSelectEntityClickType_Area,
    ShowSelectEntityClickType_ServiceForms, //服务形式
    ShowSelectEntityClickType_AcitityStatus, //活动状态
    ShowSelectEntityClickType_ClassType //课程类型
};

@interface ShowSelectTableView : UIView

@property  (nonatomic,copy) void (^selectEntityBlock)(ShowSelectEntity * entity);


- (instancetype)initWithFrame:(CGRect)frame ModelsArray:(NSArray<ShowSelectEntity*>*)modelsAry;
- (void)tb_removeSuperview;

@end




@interface ShowSelectEntity: NSObject

@property  (nonatomic,copy)   NSString   *value;
@property  (nonatomic,copy)   NSString   *key;
@property  (nonatomic,copy)   NSString  *typeCode;
//@property  (nonatomic,assign)   ShowSelectEntityClickType  clickType;
@property  (nonatomic,assign)   BOOL      isSelect; //是否被选中

+(instancetype)newInitializationWithValue:(NSString*)value Key:(NSString*)key;

@end
