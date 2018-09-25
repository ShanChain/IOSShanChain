//
//  UIViewController+NoDataTip.h
//  MyLibs
//
//  Created by michael chen on 14/12/10.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define No_data_icon_Classification     (@"Classification_No-data.png")
#define No_data_title_Classification    (@"网络不太给力哦，请稍后再试")
#define No_data_icon_MyCollection       (@"cry.png")
#define No_data_title_MyCollection      (@"您还没有收藏商品")
#define No_data_title_Recommend         (@"暂无推荐商品!")
#define No_data_title_Parameter         (@"暂无规格参数")
#define No_data_icon_FilterNoGoods      (@"awkward.png")
#define No_data_title_FilterNoGoods     (@"抱歉，没有找到符合条件的商品！")
#define No_data_title_info              (@"暂无信息")

typedef void(^ClickButtonBlock)();

@interface NoDataTip : UIView

@property (strong, nonatomic)  UILabel *tipLabel;
@property (strong, nonatomic)  UIImageView *tipImage;
@property (strong, nonatomic)  UIButton *tipButton;
@property (assign, nonatomic)  NSInteger tipLabelInterval;
@property (copy, nonatomic) ClickButtonBlock clickButtonBlock;

- (void)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image;

@end

@interface UIViewController (NoDataTip)

- (NoDataTip *)loadingTipShow:(NSString *)content inView:(UIView *)superView;

- (NoDataTip *)noDataTipShow;
- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content;
- (NoDataTip *)noDataTipShow:(NSString *)content image:(UIImage *)image;
- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image;

- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image backgroundColor:(UIColor *)color;
- (NoDataTip *)noDataTipShow:(UIView *)superView shouldLoading:(BOOL)loading content:(NSString *)content image:(UIImage *)image buttonTitle:(NSString *)title buttonBlock:(void(^)())buttonBlock;
- (void)noDataTipDismiss;
- (void)noDataTipDismissWithAccomplishedBlock:(void (^)())accomplishedBlock;

@end
