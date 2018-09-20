//
//  SYWordReadVIew.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYWordReadView : UITextView

- (void)fillNovelTitle:(NSString *)titleText;

- (void)fillContentWithJsonArray:(NSArray *)jsonArray;

- (void)fillContentWithJsonArray:(NSArray *)jsonArray withImageArray:(NSArray *)imageArray;

@end
