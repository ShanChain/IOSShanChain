//
//  SCDynamicDetailStatusFrame.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDynamicDetailStatusFrame.h"
#import "SCDynamicModel.h"
#import "DSStatusPhotosView.h"

@implementation SCDynamicDetailStatusFrame

- (void)setDynamicModel:(SCDynamicModel *)dynamicModel {
    // 1.头像
    CGFloat leftEdge = DSStatusCellInset;
    CGFloat topEdge = DSStatusCellInset;

    self.icon = CGRectMake(leftEdge, topEdge, DSStatusCellIconEdge, DSStatusCellIconEdge);
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(self.icon) + DSStatusCellInset;
    CGSize nameSize = [dynamicModel.characterName sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.name = (CGRect){ {nameX , topEdge} , nameSize };
    
    // 4.更多计算
    UIImage *moreImage = [UIImage imageNamed:@"abs_home_btn_more_default"];
    CGFloat moreW = moreImage.size.width + 20;
    CGFloat moreX = SCREEN_WIDTH - 20 * 2 - DSStatusCellInset;
    CGFloat moreH = moreImage.size.height + 20;
    self.more = CGRectMake(moreX, topEdge, moreW, moreH);
    
    CGFloat h = 0;
    switch (dynamicModel.type) {
        case 1:
        case 2: {
            // 小说和动态
            if (dynamicModel.title && [dynamicModel.title isNotBlank]) {
                self.title = CGRectMake(leftEdge, CGRectGetMaxY(self.icon) + DSStatusCellInset, SCREEN_WIDTH - 2 * leftEdge, 15);
            } else {
                self.title = CGRectMake(leftEdge, CGRectGetMaxY(self.icon), SCREEN_WIDTH - 2 * leftEdge, 0);
            }
            // 3.正文
            CGFloat textY = CGRectGetMaxY(self.title) + DSStatusCellInset;
            CGFloat maxW = SCREEN_WIDTH - 2 * leftEdge ;
            CGSize maxSize = CGSizeMake(maxW - 10, MAXFLOAT);
            
            h = textY;
            if ([dynamicModel.intro rangeOfString:@"content"].location !=NSNotFound) {
                NSDictionary *contentDictionary = [JsonTool dictionaryFromString:dynamicModel.intro];
                NSString *text = contentDictionary[@"content"];
                if (text) {
                    CGSize textSize = [text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
                    if (!dynamicModel.showTextAll && textSize.height > 100) {
                        textSize.height = 100;
                    }
                    self.content = (CGRect){{leftEdge , textY} , {maxW, textSize.height}};
                }
                h = CGRectGetMaxY(self.content) + DSStatusCellInset;
                // 5.配图相册
                NSArray *imageArray = contentDictionary[@"imgs"];
                if (imageArray != [NSNull null] && imageArray.count) {
                    CGFloat photosX = DSStatusCellInset;
                    CGFloat photosY = CGRectGetMaxY(self.content) + DSStatusCellInset;
                    CGSize photosSize = [DSStatusPhotosView sizeWithPhotosCount:(int)imageArray.count type:1];
                    self.photos = (CGRect){{leftEdge, photosY}, photosSize};
                    h = CGRectGetMaxY(self.photos) + DSStatusCellInset;
                }
            } else if ([dynamicModel.intro isNotBlank]) {
                CGSize textSize = [dynamicModel.intro sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
                if (!dynamicModel.showTextAll && textSize.height > 100) {
                    textSize.height = 100;
                }
                self.content = (CGRect){{leftEdge , textY} , {maxW, textSize.height}};
                h = CGRectGetMaxY(self.content) + DSStatusCellInset;
            } else {
                self.content = (CGRect){{leftEdge , textY} , {maxW, 0}};
                h = CGRectGetMaxY(self.content) + DSStatusCellInset;
            }
            
            break;
        }
        case 3: {
            self.title = CGRectMake(leftEdge, CGRectGetMaxY(self.icon) + DSStatusCellInset, SCREEN_WIDTH - 2 * leftEdge, 15);
            
            CGFloat backgroudY = CGRectGetMaxY(self.title) + DSStatusCellInset;
            CGSize backgroudSize = [DSStatusPhotosView sizeWithPhotosCount:1 type:3];
            self.photos = (CGRect){{leftEdge, backgroudY}, backgroudSize};
            
            // 3.正文
            CGFloat textY = CGRectGetMaxY(self.photos) + 10;
            CGFloat maxW = SCREEN_WIDTH - 2 * leftEdge ;
            CGSize maxSize = CGSizeMake(maxW - 10, MAXFLOAT);
            if ([dynamicModel.intro isNotBlank]) {
                CGSize textSize = [dynamicModel.intro sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
                if (!dynamicModel.showTextAll && textSize.height > 100) {
                    textSize.height = 100;
                }
                self.content = (CGRect){{leftEdge , textY} , {maxW, textSize.height}};
                h = CGRectGetMaxY(self.content) + DSStatusCellInset;
            } else {
                h = CGRectGetMaxY(self.photos) + DSStatusCellInset;
            }
            
            break;
        }
        case 4: {
            self.title = CGRectMake(leftEdge, CGRectGetMaxY(self.icon) + DSStatusCellInset, SCREEN_WIDTH - 2 * leftEdge, 15);
            
            CGFloat textY = CGRectGetMaxY(self.title) + 10;
            CGFloat maxW = SCREEN_WIDTH - 2 * leftEdge ;
            CGSize maxSize = CGSizeMake(maxW - 10, MAXFLOAT);
            if ([dynamicModel.intro isNotBlank]) {
                CGSize textSize = [dynamicModel.intro sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
                if (!dynamicModel.showTextAll && textSize.height > 100) {
                    textSize.height = 100;
                }
                self.content = (CGRect){{leftEdge , textY} , {maxW, textSize.height}};
            }
            
            CGFloat backgroudY = CGRectGetMaxY(self.content) + DSStatusCellInset;
            CGSize backgroudSize = [DSStatusPhotosView sizeWithPhotosCount:1 type:3];
            self.photos = (CGRect){{leftEdge, backgroudY}, backgroudSize};
            
            h = CGRectGetMaxY(self.photos) + DSStatusCellInset;
            break;
        }
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
}

@end
