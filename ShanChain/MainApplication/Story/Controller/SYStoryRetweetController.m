//
//  SYStoryRetweetController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/5.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYStoryRetweetController.h"
#import "SCDynamicStatusFrame.h"

@implementation SYStoryRetweetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.title = @"转发链条";
}

- (void)requestDataHandler {
    [self.tableView mj_endRefreshing];
    for (SCDynamicStatusFrame *frame in self.dynamicFrames) {
        frame.dynamicModel.showFloor = YES;
        frame.dynamicModel.showChain = NO;
        frame.dynamicModel = frame.dynamicModel;
    }
    [self.tableView reloadData];
}

@end
