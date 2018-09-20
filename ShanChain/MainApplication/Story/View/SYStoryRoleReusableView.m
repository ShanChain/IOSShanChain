//
//  SYStoryRoleReusableView.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleReusableView.h"

@interface SYStoryRoleReusableView()

@property(nonatomic,strong)UIImageView  *imageView;
@property(nonatomic,strong)UIButton     *collectionBtn;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UILabel      *despritionLabel1;
@property(nonatomic,strong)UILabel      *despritionLabel2;
@property(nonatomic,strong)UIView       *lineView;

@end

@implementation SYStoryRoleReusableView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0/667*SCREEN_HEIGHT)];
        _imageView.image = [UIImage imageNamed:@"hello5.jpg"];
    }
    return _imageView;
}

-(UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(340.0/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, 20, 20) ;
        [_collectionBtn setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_default"] forState:UIControlStateNormal];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectionBtn;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCMargin/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, SCREEN_WIDTH/2, 20)];
        NSString *userId = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_CUR_USER];
        NSString *spaceName = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:CACHE_SPACE_NAME];
        _nameLabel.text = spaceName;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _nameLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"给岁月文明，给时光以生命，今后，我们是同志啦";
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH /2 -KSCMargin, MAXFLOAT);
        CGSize textSize = [_contentLabel.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _contentLabel.frame = (CGRect){{KSCMargin , CGRectGetMaxY(self.nameLabel.frame) + 5} , textSize };
    }
    return _contentLabel;
}

-(UILabel *)despritionLabel1{
    if (!_despritionLabel1) {
        _despritionLabel1 = [[UILabel alloc]init];
        _despritionLabel1.frame = CGRectMake(KSCMargin/375*SCREEN_WIDTH, CGRectGetMaxY(self.imageView.frame) + 25, SCREEN_WIDTH, 20);
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
        _despritionLabel2.text = @"给岁月文明，给时光以生命，今后，我们是同志啦,给岁月文明，给时光以生命，今后，我们是同志啦,给岁月文明，给时光以生命，今后，我们是同志啦";
        CGSize textSize = [_despritionLabel2.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _despritionLabel2.frame = (CGRect){{KSCMargin , CGRectGetMaxY(self.despritionLabel1.frame) + 5} , textSize };
        
    }
    return _despritionLabel2;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(238, 238, 238);
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.despritionLabel2.frame) + 25, SCREEN_WIDTH, 5);
    }
    return _lineView;
}
-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        [self createBasicView];
    }
    return self;
    
}

-(void)createBasicView{
    [self addSubview:self.imageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.collectionBtn];
    [self addSubview:self.contentLabel];
    [self addSubview:self.despritionLabel1];
    [self addSubview:self.despritionLabel2];
    [self addSubview:self.lineView];
}

@end
