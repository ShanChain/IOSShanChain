//
//  SCDynamicDetailView.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicDetailView.h"
#import "UIImageView+WebCache.h"
#import "DSStatusPhotosView.h"
#import "SYStatusTextview.h"
#import "SCDynamicStatusFrame.h"

@interface SCDynamicDetailView()
// 昵称
@property (weak, nonatomic) UILabel *nameLabel;
// 标题
@property (weak, nonatomic) SYStatusTextview *titleView;
// 正文
@property (weak, nonatomic) SYStatusTextview *bodyView;
// 来源
@property (weak, nonatomic) UILabel *sourceLabel;
// 时间
@property (weak, nonatomic) UILabel *timeLabel;
// 楼数
@property (weak, nonatomic) UILabel *floorLabel;
// 更多图标
@property (weak, nonatomic) UIButton *moreBtn;
// 配图
@property (weak, nonatomic) DSStatusPhotosView *photosView;

@end

@implementation SCDynamicDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        // 1.昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // title in topic
        SYStatusTextview *titleView = [[SYStatusTextview alloc] init];
        titleView.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleView];
        self.titleView = titleView;
        
        SYStatusTextview *bodyView = [[SYStatusTextview alloc] init];
        bodyView.textColor = RGB(83, 83, 83);
        bodyView.font = [UIFont systemFontOfSize:12];
        [self addSubview:bodyView];
        self.bodyView = bodyView;
        
        // 3.时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGB(179, 179, 179);
        timeLabel.font = DSStatusOriginalTimeFont;
        [self addSubview:timeLabel];
        timeLabel.text = @"";
        self.timeLabel = timeLabel;
        
        //楼数
        UILabel *floorLabel = [[UILabel alloc]init];
        floorLabel.textColor = RGB(179, 179, 179);
        floorLabel.font = DSStatusOriginalTimeFont;
        [self addSubview:floorLabel];
        self.floorLabel = floorLabel;
        
        // 4.来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = RGB(59, 186, 200);
        sourceLabel.font = DSStatusOriginalSourceFont;
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 5.头像
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 20.0;
        iconView.userInteractionEnabled = YES;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 7.显示更多按钮
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setImageNormal:@"abs_home_btn_more_default" withImageHighlighted:@"abs_home_btn_more_default"];
        [moreBtn addTarget:self action:@selector(moreBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn = moreBtn;
        moreBtn.adjustsImageWhenDisabled = NO;
        [self addSubview:moreBtn];
        
        // 8.配图
        DSStatusPhotosView *photosView = [[DSStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
    
}

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame {

    self.frame = dynamicStatusFrame.frame;
    
    //取出数据
    SCDynamicModel *dynamicModel = dynamicStatusFrame.dynamicModel;
    
    NSString *intro = dynamicModel.intro;
    // 1.昵称
    self.nameLabel.text = dynamicModel.characterName;
    
    self.nameLabel.frame = dynamicStatusFrame.dynamicDetailFrame.name;
    if (dynamicModel.title && [dynamicModel.title isNotBlank]) {
        if (dynamicModel.type == 3) {
            NSDictionary *titleDict = @{
                                        @"content": [[@"#" stringByAppendingString:dynamicModel.title] stringByAppendingString:@"#"],
                                        @"spanBeanList": @[@{@"beanId":dynamicModel.detailId,@"spaceId":dynamicModel.spaceId,@"str":dynamicModel.title,@"type":[NSNumber numberWithInt:2]}]
                                        };
            [self.titleView fillContentText:[JsonTool stringFromDictionary:titleDict]];
        } else {
            [self.titleView fillContentText:dynamicModel.title];
        }
        self.titleView.frame = dynamicStatusFrame.dynamicDetailFrame.title;
    }
    // 2.正文
    [self.bodyView fillContentText:dynamicModel.intro];
    self.bodyView.frame = dynamicStatusFrame.dynamicDetailFrame.content;
    self.bodyView.userInteractionEnabled = dynamicModel.type != 2;

    
    // 3.时间
    NSString *time = [Util dynamicDisplayTime:dynamicModel.createTime];
    self.timeLabel.text = time;
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + DSStatusCellInset * 0.5;
    CGSize timeSize = [time sizeWithFont:DSStatusOriginalTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    //楼数
    NSString *genNum = [dynamicModel.genNum stringByAppendingString:@"楼"];
    self.floorLabel.text = genNum;
    CGFloat floorX = CGRectGetMaxX(self.timeLabel.frame) +KSCMargin;
    CGFloat floorY = timeY;
    CGSize floorSize = [genNum sizeWithFont:DSStatusOriginalTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.floorLabel.frame = (CGRect){{floorX, floorY}, floorSize};
    
    // 4.来源
    NSDictionary *tail = dynamicModel.tail;
    NSString *tailName= @"";
    if ([tail[@"name"] isNotBlank]) {
        tailName= [@"来自 " stringByAppendingString:tail[@"name"]];
    }
    self.sourceLabel.text = tailName;
    CGFloat sourceX = CGRectGetMaxX(self.floorLabel.frame) + 20;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [tailName sizeWithFont:DSStatusOriginalSourceFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 5.头像
    self.iconView.frame = dynamicStatusFrame.dynamicDetailFrame.icon;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dynamicModel.characterImg] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    [self.iconView preventImageViewExtrudeDeformation];
    self.moreBtn.frame = dynamicStatusFrame.dynamicDetailFrame.more;
    self.photosView.hidden = YES;
    
    switch (dynamicModel.type) {
        case 1:
        case 2: {
            if ([intro rangeOfString:@"content"].location != NSNotFound) {
                NSDictionary *intro = [JsonTool dictionaryFromString:dynamicModel.intro];
                NSArray *images = intro[@"imgs"];
                // 7.配图
                if (images && images.count) {
                    self.photosView.picUrls = images;
                    self.photosView.frame = dynamicStatusFrame.dynamicDetailFrame.photos;
                    self.photosView.hidden = NO;
                }
            }
            break;
        }
        case 3: {
            NSArray *images = @[dynamicModel.background];
            self.photosView.picUrls = images;
            self.photosView.frame = dynamicStatusFrame.dynamicDetailFrame.photos;
            self.photosView.hidden = NO;
            break;
        }
    }
    
    self.moreBtn.hidden     = dynamicModel.type == 3?YES:NO;
    self.floorLabel.hidden  = !dynamicModel.showFloor;
}

- (void)moreBtnOnClick {
    //利用通知发送更多按钮被点击：挣对于多层次需要传递数据
    [[NSNotificationCenter defaultCenter] postNotificationName:SYStoryDidReportNotication object:nil];
}

@end
