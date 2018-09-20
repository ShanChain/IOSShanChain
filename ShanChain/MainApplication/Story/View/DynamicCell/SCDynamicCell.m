//
//  SCDynamicCell.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicCell.h"
#import "SCDynamicDetailView.h"
#import "SCDynamicChainView.h"
#import "SCDynamicToolBar.h"
#import "SCDynamicStatusFrame.h"
#import "NSString+Addition.h"

@interface SCDynamicCell()<SCDynamicToolBarDelegate, SCDynamicChainDelegate>

@property (strong, nonatomic) SCDynamicToolBar *toolbar;

@end

@implementation SCDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //添加Feed具体内容
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.contentView.userInteractionEnabled = YES;
        self.opaque = YES;
        
        [self _layoutDetailView];
        //添加工具条
        [self _layoutToolbar];
        
        [self _layoutChainView];
    }
    
    return self;
}

- (void)_layoutDetailView {
    SCDynamicDetailView *view = [[SCDynamicDetailView alloc] init];
    [self.contentView addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalCenterAction:)];
    [view.iconView addGestureRecognizer:tap];
    self.dynamicDetailView = view;
    
}

- (void)_layoutToolbar {
    SCDynamicToolBar *toolbar = [[SCDynamicToolBar alloc] init];
    toolbar.delegate = self;
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)_layoutChainView {
    SCDynamicChainView *view = [[SCDynamicChainView alloc] init];
    view.delegate = self;
    [self.contentView addSubview:view];
    self.dynamicChainView = view;
}

#pragma mark ------------------ Toolbar delegate ----------------------
- (void)toolbarButtonShare {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapButtonShareWithIndexPath:)]){
        [self.delegate dynamicCellTapButtonShareWithIndexPath:self.indexPath];
    }
}

- (void)toolbarButtonSupportWith:(BOOL)isSupport {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapButtonSupportWithIndexPath:withSupported:)]){
        [self.delegate dynamicCellTapButtonSupportWithIndexPath:self.indexPath withSupported:isSupport];
    }
}

- (void)toolbarButtonComment {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapButtonCommentWithIndexPath:)]){
        [self.delegate dynamicCellTapButtonCommentWithIndexPath:self.indexPath];
    }
}

#pragma mark ----------------------- ChainView delegate -------------------------
- (void)chainViewTapExpandChains {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapButtonExpandWithIndexPath:)]){
        [self.delegate dynamicCellTapButtonExpandWithIndexPath:self.indexPath];
    }
}

- (void)chainViewTapChainCellWithIndex:(int)index {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapChainCellWithIndexPath:withIndex:)]){
        [self.delegate dynamicCellTapChainCellWithIndexPath:self.indexPath withIndex:index];
    }
}

- (void)personalCenterAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(dynamicCellTapButtonIconWithIndexPath:)]){
        [self.delegate dynamicCellTapButtonIconWithIndexPath:self.indexPath];
    }
}

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame {
    _dynamicStatusFrame = dynamicStatusFrame;
    
    [self.dynamicDetailView setDynamicStatusFrame:dynamicStatusFrame];
    
    self.toolbar.hidden = !dynamicStatusFrame.dynamicModel.showToolBar;
    self.toolbar.frame = dynamicStatusFrame.dynamicToolBarFrame;
    
    [self.toolbar setDynamicStatusFrame:dynamicStatusFrame];

    self.dynamicChainView.frame = dynamicStatusFrame.dynamicChainFrame.frame;
    [self.dynamicChainView setDynamicStatusFrame:dynamicStatusFrame];
}

@end
