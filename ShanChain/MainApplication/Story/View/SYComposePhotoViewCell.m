//
//  SYComposePhotoViewCell.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/11/30.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYComposePhotoViewCell.h"

@interface SYComposePhotoViewCell()

@property (nonatomic , strong) UIImageView *imageView;

@end

@implementation SYComposePhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        [self imageView];
        
        [self deleteButton];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 6.0f;
        _imageView.layer.borderColor = [UIColor clearColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [self.contentView addSubview:_deleteButton];
        [_deleteButton setImage:[UIImage imageNamed:@"abs_findthestars_btn_delete_selected"] forState:UIControlStateNormal];
        _deleteButton.backgroundColor = [UIColor lightGrayColor];
        [_deleteButton makeLayerWithRadius:10 withBorderColor:[UIColor lightGrayColor] withBorderWidth:0];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(5);
            make.right.equalTo(self.contentView).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    
    return _deleteButton;
}

@end

