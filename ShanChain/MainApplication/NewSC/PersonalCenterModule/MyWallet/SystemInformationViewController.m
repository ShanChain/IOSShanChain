//
//  SystemInformationViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2019/4/15.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import "SystemInformationViewController.h"
#import "SystemInformationCollectionViewCell.h"
#import "NSString+Addition.h"
#import "SCCacheChatRecord.h"

@interface SystemInformationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contenView;

@end

@implementation SystemInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    self.systemInfo = [NSMutableArray arrayWithArray:[[SCCacheChatRecord shareInstance] selectSystemInformationData]];

    
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
//    flowLayout.minimumInteritemSpacing =15; //cell间距
    flowLayout.minimumLineSpacing = 30;//行间距
    flowLayout.sectionInset =UIEdgeInsetsMake(20, 15, 20, 15);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = RGB(245, 245, 245);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[SystemInformationCollectionViewCell class] forCellWithReuseIdentifier:systemInformationCollectionViewCell];

    self.contenView = collectionView;
    
    
//    self.systemInfo = @[@{@"type":@"text",@"content":@"\n用户不得利用马甲服务发布、传播或者转载如下内容\n\n1、反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n2、 含有法律、行政法规禁止的其他内容的信息；\n3、 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n4、煽动民族仇恨、民族歧视，破坏民族团结的；\n5、侮辱、滥用英烈形象，否定英烈事迹，美化粉饰侵略战争行为的；\n6、 散布谣言，扰乱社会秩序，破坏社会稳定的；\n7、破坏国家宗教政策，宣扬邪教和封建迷信的；\n马甲有权对用户使用马甲的情况下进行审查和监督，如用户在使用马甲时违反任何上述规定，马甲或其授权的人有权要求用户改正或直接采取一切必要的措施（包括但不限于改正或删除用户发布的信息内容、暂停或终止用户使用马甲的权利）以减轻用户不当行为造成的影响。",@"url":@""},
//                        @{@"type":@"text",@"content":@"\n用户不得利用马甲服务发布、传播或者转载如下内容\n\n1、反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n2、 含有法律、行政法规禁止的其他内容的信息；\n3、 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n",@"url":@""},
//                        @{@"type":@"text",@"content":@"\n用户不得利用马甲服务发布、传播或者转载如下内容\n\n1、反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n2、 含有法律、行政法规禁止的其他内容的信息；\n3、 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n4、煽动民族仇恨、民族歧视，破坏民族团结的；\n5、侮辱、滥用英烈形象，否定英烈事迹，美化粉饰侵略战争行为的；\n6、 散布谣言，扰乱社会秩序，破坏社会稳定的；",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        @{@"type":@"image",@"content":@"",@"url":@""},
//                        ];
    
//    NSIndexPath *idx = [NSIndexPath indexPathForItem:self.systemInfo.count - 1 inSection:0];
//    [collectionView scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    [collectionView setContentOffset:CGPointMake(0, 1000000)];

    
}





#pragma  mark -- RequestNetwork



#pragma  mark -- Event


- (void)reloadViewWithNewObj:(NSDictionary *)obj {
    
    [self.systemInfo addObject:obj];
    [self.contenView setContentOffset:CGPointMake(0, 1000000)];
    [self.contenView reloadData];
}


#pragma  mark -- Delegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.systemInfo.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:systemInformationCollectionViewCell forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SystemInformationCollectionViewCell *item = (SystemInformationCollectionViewCell *)cell;
    NSDictionary *info = self.systemInfo[indexPath.item];
    item.info = info;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.systemInfo[indexPath.item];
    NSString *type = info[@"type"];
    if ([type isEqualToString:@"Text"]) {
        NSString *content = info[@"extra"];
        CGFloat h = [content heightForFont:Font(20.5) width:self.view.width - 60] + 25;
        h = h < 100 ? 100:h;
        return CGSizeMake(self.view.frame.size.width - 30, h);
    }else {
        return CGSizeMake(self.view.frame.size.width - 30, 225);
    }
    
}


#pragma  mark -- UI

#pragma - mark      ---------- 创建本类UI ----------


#pragma  mark -- Setter and Getter


@end
