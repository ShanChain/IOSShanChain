//
//  CWTableViewInfo.m
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import "CWTableViewInfo.h"
#import "CWTableViewCell.h"
#import "LeftWalletTableViewCell.h"

#define CellID @"LeftWalletTableViewCell"

@interface CWTableViewInfo ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CWTableViewInfo
{
    UITableView *_tableView;
    NSMutableArray *_cellInfoArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        [self setupTableViewWithFrame:frame style:style];
        _cellInfoArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellReuseIdentifier:CellID];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - Setter方法
- (void)setBackGroudColor:(UIColor *)backGroudColor {
    _backGroudColor = backGroudColor;
    _tableView.backgroundColor = backGroudColor;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    _tableView.separatorStyle = separatorStyle;
}

#pragma mark - public Method
- (NSUInteger)getDataArrayCount {
    return _cellInfoArray.count;
}

- (UITableView *)getTableView {
    return _tableView;
}


- (void)addCell:(CWTableViewCellInfo *)cellInfo {
    [_cellInfoArray addObject:cellInfo];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%zd",_cellInfoArray.count);
    return _cellInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = 0;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LeftWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    cell.cellInfo = cellInfo;
    cell.seatMoneyLb.text  = @"";
    cell.contentLb.text = @"";
    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    
    id target = cellInfo.actionTarget;
    SEL selector = cellInfo.actionSel;
    
    if (cellInfo.selectionStyle) {
        if ([target respondsToSelector:selector]) {
            IMP imp = [target methodForSelector:selector];
            void (*func)(id, SEL, CWTableViewCellInfo *, NSIndexPath *) = (void *)imp;
            func(target, selector, cellInfo, indexPath);
        }
    }
    
}


@end
