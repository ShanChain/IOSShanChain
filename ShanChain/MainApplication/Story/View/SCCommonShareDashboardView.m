//
//  SCCommonShareDashboardView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/21.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCCommonShareDashboardView.h"
#import <ShareSDK/ShareSDK.h>

@interface SCCommonShareDashboardView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *contentArray;

@end

@implementation SCCommonShareDashboardView

- (NSArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [[NSArray alloc] initWithArray:@[
                                                         @{@"icon":@"com_share_wechat", @"type":[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeWechat], @"name":@"wechat"},
                                                         @{@"icon":@"com_share_friend", @"type":[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatTimeline], @"name":@"friend"},
                                                         @{@"icon":@"com_share_qq", @"type":[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeQQ], @"name":@"qq"},
                                                         @{@"icon":@"com_share_qzone", @"type":[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeQZone], @"name":@"qzone"},
                                                         @{@"icon":@"com_share_sina", @"type":[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeSinaWeibo], @"name":@"sina"},]];
    }
    
    return _contentArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(52, 52);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 16;
        layout.minimumLineSpacing = 20;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 160) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = RGB_HEX(0xFFFFFF);
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(16, 32, 16, 32);
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    
    return _collectionView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        
    }
    return self;
}

- (void)presentView {
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = RGB_Hex(0xCACAC9, 0.5);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    UIView *popView = [[UIView alloc] init];
    popView.backgroundColor = RGB_HEX(0xFFFFFF);
    [self addSubview:popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(240);
    }];
    
    [popView addSubview: self.collectionView];
    [self.collectionView reloadData];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel makeTextStyleWithTitle:@"分享" withColor:RGB_HEX(0x333333) withFont:[UIFont systemFontOfSize:18] withAlignment:UITextAlignmentCenter];
    [popView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"取消" forState:UIControlStateNormal];
    closeButton.opaque = YES;
    closeButton.backgroundColor = RGB_HEX(0xF4F4F4);
    closeButton.font = [UIFont systemFontOfSize:18];
    [closeButton setTitleColor:RGB_HEX(0x333333) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    NSDictionary *content = self.contentArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:content[@"icon"]]];
    imageView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSDictionary *content = self.contentArray[indexPath.row];
    
    // share action
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)shareContentWith {
    
}

@end
