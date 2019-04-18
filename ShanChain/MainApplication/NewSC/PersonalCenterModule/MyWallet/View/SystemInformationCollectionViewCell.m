//
//  SystemInformationCollectionViewCell.m
//  ShanChain
//
//  Created by 千千世界 on 2019/4/15.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import "SystemInformationCollectionViewCell.h"
#import "TYAttributedLabel.h"

NSString *const systemInformationCollectionViewCell = @"SystemInformationCollectionViewCell";

@interface SystemInformationCollectionViewCell()
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) TYAttributedLabel *decLabel;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SystemInformationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {

        [self configurationUI];
        self.backgroundColor = [UIColor clearColor];

        
        
    }
    
    return self;
}

- (void)configurationUI {
    
    _timeLabel = ({
        
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"2019-4-15";
        lab.font = Font(14.0);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor lightTextColor];
        lab.backgroundColor = [UIColor lightGrayColor];
        lab.layer.cornerRadius = 5;
        lab.layer.masksToBounds = YES;
        [self.contentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        lab;
    });
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    // 设置阴影颜色
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    // 设置阴影的偏移量，默认是（0， -3）
    view.layer.shadowOffset = CGSizeMake(0, 3);
    // 设置阴影不透明度，默认是0
    view.layer.shadowOpacity = 0.3;
    // 设置阴影的半径，默认是3
    view.layer.shadowRadius = 2;
    [self.contentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    _decLabel = ({
        
        TYAttributedLabel *lab = [[TYAttributedLabel alloc]init];
        // 文字间隙
        lab.characterSpacing = 2;
        // 文本行间隙
        lab.linesSpacing = 6;

        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 0, 15));
        }];
        lab;
    });
    
    
    _imgView = ({
        
        UIImageView *imgView =[[UIImageView alloc]init];
        [imgView setImage:[UIImage imageNamed:@"sc_MJ"]];
        [self.contentView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.right.bottom.mas_equalTo(self);
        }];
        
        imgView;
        
    });
}
- (void)setInfo:(NSDictionary *)info {
    _info = info;
    _timeLabel.text = info[@"time"];
    if ([info[@"type"] isEqualToString:@"Text"]) {
        _imgView.hidden = YES;
        _decLabel.hidden = NO;
        _decLabel.text = info[@"extra"];
        
    }else {
        _imgView.hidden = NO;
        _decLabel.hidden = YES;
        NSString *url = info[@"extra"];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sc_MJ"]];
        
    }
}
@end
