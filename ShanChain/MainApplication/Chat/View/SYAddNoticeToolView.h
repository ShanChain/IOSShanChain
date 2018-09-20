//
//  SYAddNoticeToolView.h
//  ShanChain
//
//  Created by krew on 2017/10/17.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SYAddNoticeToolViewButtonTypePicture,//相册
    SYAddNoticeToolViewButtonTypeMention,//提到@
    
}SYAddNoticeToolViewButtonType;

@class SYAddNoticeToolView;

@protocol  SYAddNoticeToolViewDelegate<NSObject>

- (void)noticeTool:(SYAddNoticeToolView *)toolbar didClickedButton:(SYAddNoticeToolViewButtonType)buttonType;

@end


@interface SYAddNoticeToolView : UIView

@property(nonatomic,strong)id <SYAddNoticeToolViewDelegate> delegate;

@end
