//
//  SYStoryRoleHeadView.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleHeadView.h"

@interface SYStoryRoleHeadView()

@property(nonatomic,strong)UIImageView  *imageView;
@property(nonatomic,strong)UIButton     *collectionBtn;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UILabel      *despritionLabel1;
@property(nonatomic,strong)UILabel      *despritionLabel2;
@property(nonatomic,strong)UIView       *lineView;


@end

@implementation SYStoryRoleHeadView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0/667*SCREEN_HEIGHT)];
    }
    return _imageView;
}

-(UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(340.0/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, 20.0/667*SCREEN_HEIGHT, 20.0/667*SCREEN_HEIGHT) ;
        [_collectionBtn setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_default"] forState:UIControlStateNormal];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectionBtn;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KSCMargin/375*SCREEN_WIDTH, 15.0/667*SCREEN_HEIGHT, SCREEN_WIDTH/2, 20.0/667*SCREEN_HEIGHT)];
        _nameLabel.text = self.name;
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

-(void)collectionBtnClick:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(storyRoleHeadCollectionBtnClicked)]) {
        [_delegate storyRoleHeadCollectionBtnClicked];
    }
    UIButton *btn1 = btn;
    btn1.selected = !btn1.selected;
    if (btn1.selected) {
        [btn1 setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_selected"] forState:UIControlStateNormal];
    }else{
        [btn1 setImage:[UIImage imageNamed:@"abs_roleselection_btn_collect_default"] forState:UIControlStateNormal]; 
    }
}
@end
