//
//  SYCommonRoleView.m
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYCommonRoleView.h"
#import "SCPersonalCollectionCell.h"

static NSString * const KSCPersonalCollectionCellID = @"SCPersonalCollectionCell";

@interface SYCommonRoleView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView           *head2View;
@property(nonatomic,strong)UIView           *roleView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel          *storyLabel;
@property(nonatomic,strong)UIImageView      *arrowImgView;
@property(nonatomic,strong)UIView           *line3View;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SYCommonRoleView

#pragma mark -懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)updateDataArray:(NSArray *)array {
    self.dataArray = array;
    
    self.storyLabel.text = [NSString stringWithFormat: @"角色（%d）", self.dataArray.count];
    
    [self.collectionView reloadData];
}

-(UIView *)head2View{
    if (!_head2View) {
        _head2View = [UIView new];
    }
    return _head2View;
}

- (UIView *)roleView{
    if (!_roleView) {
        _roleView = [UIView new];
        _roleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        tapAction.delegate = self;
        [_roleView addGestureRecognizer:tapAction];
        
    }
    return _roleView;
}

-(UILabel *)storyLabel{
    if (!_storyLabel) {
        _storyLabel = [UILabel new];
        _storyLabel.text = [NSString stringWithFormat: @"角色（%@）", self.dataArray.count];
        _storyLabel.textAlignment = NSTextAlignmentLeft;
        _storyLabel.textColor = RGB(102, 102, 102);
        _storyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _storyLabel;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]init];
        _arrowImgView.image = [UIImage imageNamed:@"abs_meet_btn_enter_default"];
        _arrowImgView.userInteractionEnabled = YES;
        
    }
    return _arrowImgView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(50, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 20;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,30, SCREEN_WIDTH,50) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"SCPersonalCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KSCPersonalCollectionCellID];
    }
    return _collectionView;
}

-(UIView * )line3View{
    if (!_line3View) {
        _line3View = [UIView new];
        _line3View.backgroundColor = RGB(246, 246, 246);
    }
    return _line3View;
}

#pragma mark -系统方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}

#pragma mark - 构造方法
-(void)setupViews{
    
    [self addSubview:self.head2View];
    [self addSubview:self.line3View];
    
    [self.head2View addSubview:self.roleView];
    [self.roleView addSubview:self.storyLabel];
    [self.roleView addSubview:self.arrowImgView];
    [self.head2View addSubview:self.collectionView];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.head2View.frame = CGRectMake(0, 0, SCREEN_WIDTH, (90.0/667)*SCREEN_HEIGHT);
    self.roleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20.0/667*SCREEN_HEIGHT);
    self.storyLabel.frame = CGRectMake(DSStatusCellInset, 5, SCREEN_WIDTH-30, 20);
    self.arrowImgView.frame = CGRectMake(SCREEN_WIDTH-15-6, 10, 6, 12);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.storyLabel.frame) + 10, SCREEN_WIDTH, 50);
    
    self.line3View.frame = CGRectMake(0,CGRectGetMaxY(self.collectionView.frame) + 10, SCREEN_WIDTH, 5);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCPersonalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSCPersonalCollectionCellID forIndexPath:indexPath];
    NSString *headImg = self.dataArray[indexPath.row][@"head_img"];
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:headImg]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)tapAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:SYScreenInsideDidArrowClickBtnActionNotication object:nil];
}

@end
