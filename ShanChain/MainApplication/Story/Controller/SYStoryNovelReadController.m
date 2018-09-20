//
//  SYStoryNovelReadController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/9.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYStoryNovelReadController.h"
#import "SYWordReadView.h"

@interface SYStoryNovelReadController()

@property (strong, nonatomic) SYWordReadView *readView;

@end

@implementation SYStoryNovelReadController

- (NSMutableArray *)imageArray {
    if(!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (SYWordReadView *)readView {
    if(!_readView) {
        _readView = [[SYWordReadView alloc] init];
        _readView.frame = CGRectMake(0, 0, self.view.width, self.view.height - kNavStatusBarHeight);
        [self.view addSubview:_readView];
    }
    
    return _readView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阅读模式";
    [self readView];
    
    if (self.content) {
        self.contentArray = [JsonTool arrayFromString:self.content];
        if (!self.contentArray || !self.contentArray.count) {
            [SYProgressHUD showError:@"故事内容出错"];
            return;
        }
    }
    
    if (_isLocal) {
        [self.readView fillContentWithJsonArray:self.contentArray withImageArray:self.imageArray];
    } else {
        [self.readView fillContentWithJsonArray:self.contentArray];
    }
}

@end
