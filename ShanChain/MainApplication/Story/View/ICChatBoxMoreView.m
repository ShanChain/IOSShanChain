//
//  ICChatBoxMoreView.m
//  XZ_WeChat
//
//  Created by zhang on 16/3/11.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICChatBoxMoreView.h"
#import "ICChatBoxMoreViewItem.h"

#define topLineH  0.5
#define bottomH  18

@interface ICChatBoxMoreView() <UIScrollViewDelegate>

@property (nonatomic, weak)UIView *topLine;
@property (nonatomic, weak)UIScrollView *scrollView;
//@property (nonatomic, weak)UIPageControl *pageControl;

@end

@implementation ICChatBoxMoreView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(255, 255, 255);
        
        [self scrollView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, topLineH, frame.size.width,216)];
//    self.scrollView.backgroundColor = [UIColor redColor];
}

#pragma mark - Public Methods
- (void)setItems:(NSMutableArray *)items{
    _items = items;
    
    
//    float space = w / 4;
//    float h = (self.height - 2 * space) / 2;
//    float x = space, y = space;
//    int i = 0;
    
//    int count = (int)self.view.subviews.count ;
//    CGFloat buttonW = (200.0/375*SCREEN_WIDTH) /count ;
//    CGFloat buttonH = 20.0;
//    for (int i = 0; i<count ; i++) {
//        UIButton *button = self.view.subviews[i];
//        button.y = 12;
//        button.width = 20;
//        button.height = buttonH;
//        button.x = i * buttonW + 30;
//    }
    //总共列数
    int totalColumns = 3;
    
    //每一格的尺寸
    float cellW = 40;
    float cellH = 40;
    
    CGFloat margin = (self.scrollView.size.width - totalColumns * cellW)/(totalColumns + 1);
    CGFloat margin2 = 50.0/375*SCREEN_WIDTH;
    CGFloat margin1 = 90.0/375*SCREEN_WIDTH;
    
    for (int i = 0; i < items.count; i ++ ) {
        UIButton *button = items[i];
//        button.backgroundColor = [UIColor redColor];
        //计算行号和列号
        int row = i / totalColumns;
        int col = i % totalColumns;
        
        CGFloat cellX = margin2 + col * (cellW + margin1);
        CGFloat cellY = row * (cellH + margin) +30;

        button.tag = i;
        button.frame = CGRectMake(cellX, cellY, cellW, cellH);
        [button addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
    }

}

// 点击了某个Item
- (void) didSelectedItem:(ICChatBoxMoreViewItem *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxMoreView:didSelectItem:)]) {
        [_delegate chatBoxMoreView:self didSelectItem:(int)sender.tag];
    }
}

#pragma mark - Getter and Setter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}
#pragma mark - Privite Method 

@end
