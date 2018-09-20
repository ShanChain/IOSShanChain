//
//  SYComposePhotosView.m
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYComposePhotosView.h"
#import "SYComposePhotoViewCell.h"

static const NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

@interface SYComposePhotosView()<UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , retain) UICollectionView *collectionView;

@property (nonatomic , strong) NSMutableArray *selectedPhotos;

@end

@implementation SYComposePhotosView


- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self collectionView];
    }
    
    return self;
}

#pragma mark -----------  UICollectionViewDataSource ---------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYComposePhotoViewCell *cell = (SYComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.deleteButton.tag = indexPath.row;
    cell.image = self.selectedPhotos[indexPath.row];
    cell.indexpath = indexPath;
    [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)deleteAction:(UIButton *)button {
    [self.selectedPhotos removeObjectAtIndex:button.tag];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:button.tag inSection:0]]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SYComposePhotoViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(80);
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    
    return _selectedPhotos;
}


- (void)addImage:(UIImage *)image {
    [self.selectedPhotos addObject:image];
    // 注意这里的NSIndexPath 是数组
    [self.collectionView reloadData];
}

- (NSArray *)images {
    NSMutableArray *array = [NSMutableArray array];
    for (UIImage *i in self.selectedPhotos) {
        [array addObject:i];
    }
    return array;
}

@end
