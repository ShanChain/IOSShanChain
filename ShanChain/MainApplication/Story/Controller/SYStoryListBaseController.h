//
//  SYStoryListBaseController.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/4.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYStoryListDelegate <NSObject>

- (NSInteger)storyListNumberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)storyListTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)storyListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)storyListTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (UIView *)storyListTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

@end

@interface SYStoryListBaseController : SCBaseVC

@property (assign, nonatomic) int pageIndex;
// for main page request
@property (copy, nonatomic) NSString *requestURL;

@property (strong, nonatomic) NSMutableArray *dynamicFrames;//数组

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) id<SYStoryListDelegate> delegate;

@property (nonatomic,assign)   BOOL     isRow;

// 刷新数据的处理接口
- (void)requestData:(BOOL)isReload;

// 具体请求数据接口的定制化
- (void)requestDataHandler;

#pragma mark ---------------- SCDynamicModel To SCDynamicStatusFrame -------------------
- (NSArray *)dynamicFramesWithModels:(NSArray *)models;
// default indexPath.section
- (int)getTableDataIndexWith:(NSIndexPath *)indexPath;

@end
