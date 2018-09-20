//
//  SYPoppedAuxiliaryView.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SYPoppedAuxiliaryCallBack) (NSString *text);

@interface SYPoppedAuxiliaryView : UIView

@property (nonatomic, copy) SYPoppedAuxiliaryCallBack callback;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *secondTitle;

@property (copy, nonatomic) NSString *placeholder;

- (void)presentView;
@end
