//
//  SYStoryRoleController.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleController.h"
#import "SYStoryRoleReusableView.h"
#import "SYStoryRoleCollectionCell.h"
#import "SYStoryRoleHeadView.h"
#import "SYAuxiliaryAddController.h"
#import "SYStoryRoleSelectController.h"
#import "SYCharacterModel.h"
#import "SCTabbarController.h"
#import "SCCacheTool.h"

static NSString * const SYStoryRoleReusableViewID = @"SYStoryRoleReusableView";
static NSString * const SYStoryRoleCollectionCellID = @"SYStoryRoleCollectionCell";

@interface SYStoryRoleController ()<SYStoryRoleHeadViewDelegate>

@property(nonatomic,strong)UIImageView  *imageView;
@property(nonatomic,strong)UIView       *bgView;
@property(nonatomic,strong)UIButton     *collectionBtn;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UILabel      *despritionLabel1;
@property(nonatomic,strong)UILabel      *despritionLabel2;
@property(nonatomic,strong)UIView       *lineView;


@property (nonatomic,strong)UICollectionView *scrolCollectionView;
@property (nonatomic,strong) NSMutableArray *itemShowArray;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIButton             *btn;

@property(nonatomic,strong)UIImageView *selectImg;
@property(nonatomic,strong)UILabel *selectLab;

@property(nonatomic,strong)NSIndexPath *curIndexPath;

@property(nonatomic,strong)NSMutableDictionary    *characterInfo;

@end

@implementation SYStoryRoleController
#pragma mark -懒加载
- (NSMutableDictionary *)characterInfo{
    if (!_characterInfo) {
        _characterInfo = [NSMutableDictionary dictionary];
    }
    return _characterInfo;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0/667*SCREEN_HEIGHT)];
         [_imageView sd_setImageWithURL:[NSURL URLWithString:self.bgPic] placeholderImage:[UIImage imageNamed:@"run4.jpg"]];
//        _imageView.backgroundColor = RGBA(0, 0, 0, 0.4);
    }
    return _imageView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.imageView.bounds];
        _bgView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [_bgView addSubview:self.nameLabel];
        [_bgView addSubview:self.collectionBtn];
        [_bgView addSubview:self.contentLabel];
        
    }
    return _bgView;
}

-(UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(340.0/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, 20.0/667*SCREEN_HEIGHT, 20.0/667*SCREEN_HEIGHT);
        if (self.isFavorite) {
            [_collectionBtn setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_selected"] forState:UIControlStateNormal];
        } else {
            [_collectionBtn setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_default"] forState:UIControlStateNormal];
        }
        
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectionBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCMargin/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, SCREEN_WIDTH/2, 20.0/667*SCREEN_HEIGHT)];
        _nameLabel.text = self.name;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = self.slogan;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH /2 -KSCMargin, MAXFLOAT);
        CGSize textSize = [_contentLabel.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _contentLabel.frame = (CGRect){{KSCMargin , CGRectGetMaxY(self.nameLabel.frame) + 5} , textSize };
    }
    return _contentLabel;
}

-(UILabel *)despritionLabel1{
    if (!_despritionLabel1) {
        _despritionLabel1 = [[UILabel alloc]init];
        _despritionLabel1.frame = CGRectMake(KSCMargin/375*SCREEN_WIDTH, 225.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 20.0/667*SCREEN_WIDTH);
        _despritionLabel1.text = @"简介";
        _despritionLabel1.textAlignment = NSTextAlignmentLeft;
        _despritionLabel1.textColor = RGB(51, 51, 51);
        _despritionLabel1.font = [UIFont systemFontOfSize:14];
    }
    return _despritionLabel1;
}

-(UILabel *)despritionLabel2{
    if (!_despritionLabel2) {
        _despritionLabel2 = [[UILabel alloc]init];
        _despritionLabel2.textAlignment = NSTextAlignmentLeft;
        _despritionLabel2.textColor = RGB(102, 102, 102);
        _despritionLabel2.font = [UIFont systemFontOfSize:12];
        _despritionLabel2.numberOfLines = 0;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 2 * KSCMargin, MAXFLOAT);
        _despritionLabel2.text = self.intro;
        CGSize textSize = [_despritionLabel2.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _despritionLabel2.frame = (CGRect){{KSCMargin , 250.0/667*SCREEN_HEIGHT} , textSize };
        
    }
    return _despritionLabel2;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(238, 238, 238);
        _lineView.frame = CGRectMake(0, 360.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 5);
    }
    return _lineView;
}

- (NSMutableArray *)itemShowArray{
    if (_itemShowArray == nil) {
        _itemShowArray = [NSMutableArray array];
//        for (int i = 0; i < 20; i ++) {
//            [_itemShowArray addObject:[NSString stringWithFormat:@"%d",i]];
//        }
    }
    return _itemShowArray;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 365.0/667*SCREEN_HEIGHT)];

        [_headView addSubview:self.imageView];
        [_headView addSubview:self.bgView];
        [_headView addSubview:self.despritionLabel1];
        [_headView addSubview:self.despritionLabel2];
        [_headView addSubview:self.lineView];
    }
    return _headView;
}

- (UICollectionView *)scrolCollectionView{
    if (_scrolCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(50, 80);
        
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _scrolCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 385.0/667*SCREEN_HEIGHT, SCREEN_WIDTH,80.0/667*SCREEN_HEIGHT) collectionViewLayout:layout];
        _scrolCollectionView.backgroundColor = [UIColor whiteColor];
        _scrolCollectionView.delegate = self;
        _scrolCollectionView.dataSource = self;
        
        _scrolCollectionView.showsVerticalScrollIndicator = false;
        _scrolCollectionView.showsHorizontalScrollIndicator = true;
        _scrolCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_scrolCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYStoryRoleCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:SYStoryRoleCollectionCellID];
    }
    return _scrolCollectionView;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(KSCMargin, 560.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 2 * KSCMargin, 40.0/667*SCREEN_HEIGHT);
        [_btn setTitle:@"我们穿越吧" forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 8.0;
        [_btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_rectangle_default"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(readyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIImageView *)selectImg {
    if (!_selectImg) {
        _selectImg = [[UIImageView alloc]initWithFrame:CGRectMake((App_Frame_Width-50)/2, CGRectGetMaxY(self.scrolCollectionView.frame)+10, 50, 50)];
        _selectImg.image = [UIImage imageNamed:@"abs_roleselection_btn_through_default"];
        _selectImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAction)];
        [_selectImg addGestureRecognizer:gesture];
        _selectImg.layer.masksToBounds = YES;
        _selectImg.layer.cornerRadius = 25.0;
    }
    return _selectImg;
}
- (UILabel *)selectLab {
    if (!_selectLab) {
        _selectLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectImg.frame)+10, App_Frame_Width, 15)];
        _selectLab.textAlignment = NSTextAlignmentCenter;
        _selectLab.text = @"添加角色";
        _selectLab.font = [UIFont systemFontOfSize:12.0f];
        _selectLab.textColor = RGB(102, 102, 102);
    }
    return _selectLab;
}

#pragma mark -系统方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self requestSpaceCharacterList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"角色选择";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.scrolCollectionView];
    
    [self.view addSubview:self.selectImg];
    
    [self.view addSubview:self.selectLab];
    
    [self.view addSubview:self.btn];
}

#pragma mark -构造方法

- (void)selectAction{
    SYStoryRoleSelectController *selectVC = [[SYStoryRoleSelectController alloc]init];
    selectVC.spaceId = self.spaceId;
    [self.navigationController pushViewController:selectVC animated:YES];
    
    return;
}

- (void)requestSpaceCharacterList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.spaceId) forKey:@"spaceId"];
    
    [[SCNetwork shareInstance]postWithUrl:STORYCHARACTERMODELQUERYSPACEID parameters:params success:^(id responseObject) {
        [self.itemShowArray removeAllObjects];
        
        NSDictionary *data = responseObject[@"data"];
        NSMutableArray *content = data[@"content"];
        
        for(NSDictionary *dic in content){
            SYCharacterModel *characterModel=[[SYCharacterModel alloc]init];
            [characterModel setValuesForKeysWithDictionary:dic];
            [_itemShowArray addObject:characterModel];
        }
        [self.scrolCollectionView reloadData];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

- (void)readyBtnClick {
    SYCharacterModel *m = self.itemShowArray[self.curIndexPath.item];
    [[SCAppManager shareInstance] switchRoleWithSpaceId:@(self.spaceId) modelId:@(m.modelId)];
}

- (void)collectionBtnClick:(UIButton *)btn{

    UIButton *btn1 = btn;
    btn1.selected = !btn1.selected;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.spaceId) forKey:@"spaceId"];
    [params setObject:[[SCCacheTool shareInstance] getCurrentUser] forKey:@"userId"];
    
    if (btn1.selected) {
        [[SCNetwork shareInstance] postWithUrl:STORYFAVORITE parameters:params success:^(id responseObject) {
            [btn1 setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_selected"] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
        }];
    } else {
        [[SCNetwork shareInstance] postWithUrl:STORYSPACEUNFAVORITE parameters:params success:^(id responseObject) {
            [btn1 setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_default"] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
        }];
    }
}

#pragma mark -UICollectionView的数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemShowArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYStoryRoleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYStoryRoleCollectionCellID forIndexPath:indexPath];
    cell.model = self.itemShowArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SYCharacterModel *model = self.itemShowArray[indexPath.item];
    self.curIndexPath = indexPath;
    [self.selectImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    self.selectLab.text = model.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
