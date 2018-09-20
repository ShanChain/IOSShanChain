//
//  SCDynamicChainView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicChainView.h"
#import "SCDynamicStatusFrame.h"
#import "SYStatusTextview.h"

@interface SCDynamicChainView()

@property (strong, nonatomic) UIButton *textButton;

@end

@implementation SCDynamicChainView


- (UIButton *)textButton {
    if(!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setTitleColor:RGB(28, 179, 193) forState:UIControlStateNormal];
        _textButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_textButton setImage:[UIImage imageNamed:@"abs_home_btn_dropdown_default"] forState:UIControlStateNormal];
        [_textButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _textButton;
}


- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (!dynamicStatusFrame.dynamicModel.showChain) {
        return;
    }
    
    SCDynamicModel *dynamicModel = dynamicStatusFrame.dynamicModel;
    int totalCount = dynamicModel.chains.count;
    int disCount = dynamicStatusFrame.dynamicChainFrame.chains.count;
    NSString *text = totalCount == disCount ? @"展开剩余楼层" : [NSString stringWithFormat:@"展开剩余%@层楼", totalCount - disCount];
    [self.textButton setTitle:text forState:UIControlStateNormal];
    self.textButton.frame = dynamicStatusFrame.dynamicChainFrame.prompt;
    CGFloat imageViewWidth = CGRectGetWidth(self.textButton.imageView.frame);
    CGFloat titleLabelWidth = CGRectGetWidth(self.textButton.titleLabel.frame);
    self.textButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageViewWidth - 6, 0, imageViewWidth + 6);
    self.textButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelWidth + 6, 0, -titleLabelWidth - 6);
    [self addSubview:self.textButton];
    
    int index = totalCount - 1;
    for (int i=0; i < disCount; i += 1) {
        SCDynamicModel *s = [dynamicModel.chains objectAtIndex:(index - i)];
        
        SYStatusTextview *content = [[SYStatusTextview alloc] init];
        content.tag = index - i;
        content.frame = ((SCDynamicChainStatusCellFrame *)[dynamicStatusFrame.dynamicChainFrame.chains objectAtIndex:i]).frame;
        NSMutableDictionary *intro = [JsonTool dictionaryFromString:s.intro];
        [content fillContentText:s.intro];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChainCellView:)];
        [content addGestureRecognizer:tap];
        NSString *leadingText = [NSString stringWithFormat:@"%@楼 %@: ", s.genNum, s.characterName];
        [content insertPointedTextWithText:leadingText atIndex:0];
        [self addSubview: content];
    }
}

- (void)expandAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(chainViewTapExpandChains)]) {
        [self.delegate chainViewTapExpandChains];
    }
}

- (void)tapChainCellView:(UITapGestureRecognizer *)tap {
    int index = tap.view.tag;
    if ([self.delegate respondsToSelector:@selector(chainViewTapChainCellWithIndex:)]) {
        [self.delegate chainViewTapChainCellWithIndex:index];
    }
}

@end
