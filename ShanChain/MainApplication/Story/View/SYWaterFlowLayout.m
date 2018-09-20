//
//  SYWaterFlowLayout.m
//  ShanChain
//
//  Created by krew on 2017/8/25.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYWaterFlowLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>


//默认的列数
static const NSInteger DefaultColumnCount = 2;
//每一列之间的间距
static const CGFloat DefaultColumnMargin = 10;
//每一行之间的间距
static const CGFloat DefaultRowMargin = 10;
//边缘间距
static const UIEdgeInsets DefaultEdgeInsets = {10,10,10,10};

@interface SYWaterFlowLayout()

//存放所有cell的布局属性
@property(nonatomic,strong)NSMutableArray *attrsArray;
//存放所有列的当前高度
@property(nonatomic,strong)NSMutableArray *collumnHeights;
//内容的高度
@property (nonatomic, assign) CGFloat     contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount:(NSInteger )section;
- (UIEdgeInsets)edgeInsets;

@end

@implementation SYWaterFlowLayout

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return DefaultRowMargin;
    }
}

- (NSInteger)columnCount:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:::section:)]) {
        return [self.delegate columnCountInWaterflowLayout:self section:section];
    } else {
        return DefaultColumnCount;
    }
}



-(CGFloat )columnMargin{
    if ( _delegate && [_delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [_delegate columnMarginInWaterflowLayout:self ];
    } else {
        return DefaultColumnMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if (_delegate && [_delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [_delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return DefaultEdgeInsets;
    }
}

-(NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

-(NSMutableArray *)collumnHeights{
    if (!_collumnHeights) {
        _collumnHeights = [NSMutableArray array];
    }
    return _collumnHeights;
}

-(void)prepareLayout{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    //清除之前计算的所有高度
    [self.collumnHeights removeAllObjects];
    
    for (NSInteger i = 0; i < DefaultColumnCount; i++) {
        [self.collumnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //把初始化的操作放在这里
    [self.attrsArray removeAllObjects];
    
    //开始创建每一个cell对应的布局
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat w = 0;
    CGFloat h = 0;

    if (indexPath.section == 0) {
        w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - 3 * self.columnMargin ) / 4;
        h = 30;
    }else{
         w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - 1 * self.columnMargin ) / 2;
        h = [self.delegate SYWaterFlowLayout:self heightForRowAtIndexPath:indexPath.item itemWidth:w section:indexPath.section];
    }
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.collumnHeights[0] doubleValue];

    if (indexPath.section == 0) {
        
    }else{
        for (NSInteger i = 0; i < 2 ; i++) {
            CGFloat columnHeight = [self.collumnHeights[i] doubleValue];
            if (minColumnHeight > columnHeight) {
                minColumnHeight = columnHeight;
                destColumn = i;
            }
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    self.collumnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    CGFloat columnHeight = [self.collumnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
    
}

-(CGSize )collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
