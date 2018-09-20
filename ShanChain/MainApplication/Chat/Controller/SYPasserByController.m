//
//  SYPasserByController.m
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYPasserByController.h"
#import "SYChatListCell.h"

static NSString * const KSYChatListCellID = @"SYChatListCell";

@interface SYPasserByController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArr;

@end

@implementation SYPasserByController
#pragma mark -懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView{
    if (! _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYChatListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSYChatListCellID];
    }
    return _tableView;
}

#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"路人";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self defaultData];
    
    [self.view addSubview:self.tableView];

}

#pragma mark -构造方法
- (void)defaultData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"hello5.jpeg" forKey:@"icon"];
    [dict setObject:@"10" forKey:@"messageCount"];
    [dict setObject:@"0" forKey:@"isSelected"];
    [dict setObject:@"[自然选择号NO.3]" forKey:@"screen"];
    [dict setObject:@"云天明" forKey:@"name"];
    [dict setObject:@"08-30  09:00" forKey:@"time"];
    [dict setObject:@"关一凡：章北海！你在干什么呀，为什么这样" forKey:@"content"];
    [self.dataArr addObject:dict];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"mine_bg_fall_default.jpg" forKey:@"icon"];
    [dict1 setObject:@"8" forKey:@"messageCount"];
    [dict1 setObject:@"1" forKey:@"isSelected"];
    [dict1 setObject:@"" forKey:@"screen"];
    [dict1 setObject:@"路人" forKey:@"name"];
    [dict1 setObject:@"08-30  09:00" forKey:@"time"];
    [dict1 setObject:@"关一凡：章北海！你在干什么呀，为什么这样" forKey:@"content"];
    [self.dataArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"hello10.jpeg" forKey:@"icon"];
    [dict2 setObject:@"9" forKey:@"messageCount"];
    [dict2 setObject:@"1" forKey:@"isSelected"];
    [dict2 setObject:@"[时空管理局]" forKey:@"screen"];
    [dict2 setObject:@"穿越向导" forKey:@"name"];
    [dict2 setObject:@"前天" forKey:@"time"];
    [dict2 setObject:@"你好，我是你的专属向导，有问题的可以找我哦！" forKey:@"content"];
    [self.dataArr addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"hello10.jpeg" forKey:@"icon"];
    [dict3 setObject:@"9" forKey:@"messageCount"];
    [dict3 setObject:@"1" forKey:@"isSelected"];
    [dict3 setObject:@"" forKey:@"screen"];
    [dict3 setObject:@"缘分" forKey:@"name"];
    [dict3 setObject:@"昨天" forKey:@"time"];
    [dict3 setObject:@"逻辑在故事里提到了你，你遇到他了吗" forKey:@"content"];
    [self.dataArr addObject:dict3];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"hello5.jpeg" forKey:@"icon"];
    [dict4 setObject:@"10" forKey:@"messageCount"];
    [dict4 setObject:@"1" forKey:@"isSelected"];
    [dict4 setObject:@"[自然选择号NO.3]" forKey:@"screen"];
    [dict4 setObject:@"云天明" forKey:@"name"];
    [dict4 setObject:@"昨天" forKey:@"time"];
    [dict4 setObject:@"关一凡：章北海！你在干什么呀，为什么这样" forKey:@"content"];
    [self.dataArr addObject:dict4];
    
}

#pragma mark -UITableViewDataSource
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYChatListCell *cell = (SYChatListCell *)[tableView dequeueReusableCellWithIdentifier:KSYChatListCellID forIndexPath:indexPath];
    cell.dic = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//让tableView可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        SCLog(@"点击了删除");
    }];
    deleteRowAction.backgroundColor = RGB(254, 56, 36);
    
    //详情
    UITableViewRowAction *detailRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"详情" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SCLog(@"点击了标记为详情");
    }];
    detailRowAction.backgroundColor = RGB(143, 142, 148);
    
    //置顶
    UITableViewRowAction *firstRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SCLog(@"点击了置顶");
    }];
    firstRowAction.backgroundColor = RGB(139, 219, 84);
    return @[deleteRowAction, detailRowAction,firstRowAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
