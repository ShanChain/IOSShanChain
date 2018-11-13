//
//  ShowSelectTableView.m
//  TYWithHHSProject
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#import "ShowSelectTableView.h"

static NSString  *const  Identifier = @"cell";

@interface ShowSelectTableView ()<UITableViewDataSource,UITableViewDelegate>

@property  (nonatomic,copy)  NSArray  <ShowSelectEntity*>  *models;
@property (nonatomic,strong)  UITableView  *tableView;

@end


@implementation ShowSelectTableView


- (instancetype)initWithFrame:(CGRect)frame ModelsArray:(NSArray<ShowSelectEntity*>*)modelsAry
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [ShowSelectTableView instanceWithView];
        self.frame = frame;
        [modelsAry enumerateObjectsUsingBlock:^(ShowSelectEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        
        NSArray* sortedAry = [modelsAry sortedArrayUsingComparator:^NSComparisonResult(ShowSelectEntity *  _Nonnull obj1, ShowSelectEntity *  _Nonnull obj2) {
            return obj1.key > obj2.key ? NSOrderedDescending : (obj1.key == obj2.key ? NSOrderedSame : NSOrderedAscending);
        }];

        self.models = sortedAry;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
//        [_tableView registerNib:[UINib nibWithNibName:HFlightCommunityShowCell bundle:nil] forCellReuseIdentifier:HFlightCommunityShowCell];
        _tableView.dataSource =self;
        _tableView.delegate =self;
        if (frame.size.height + 40*modelsAry.count > SCREEN_HEIGHT - IPHONE_NAVIGATIONBAR_HEIGHT - IPHONE_TOOL_HEIGHT) {
            _tableView.scrollEnabled = YES;
        }else{
            _tableView.scrollEnabled = NO;
        }
        _tableView.contentSize = CGSizeMake(frame.size.width, 40*modelsAry.count);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MIN(frame.size.height, 40*modelsAry.count));
        }];
        
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    ShowSelectEntity  *entity =  self.models[indexPath.section];
    cell.textLabel.text = entity.value;
    cell.textLabel.font = Font(13);
    cell.textLabel.textColor = entity.isSelect ? Theme_MainThemeColor:[UIColor lightGrayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowSelectEntity  *entity =  self.models[indexPath.section];
    [self.models enumerateObjectsUsingBlock:^(ShowSelectEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    entity.isSelect = YES;
    BLOCK_EXEC(self.selectEntityBlock,entity);
    [self tb_removeSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tb_removeSuperview];
}

-(void)tb_removeSuperview{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, 0.01);
    } completion:^(BOOL finished) {
        BLOCK_EXEC(self.selectEntityBlock,nil);
        [self removeFromSuperview];
    }];
}

@end


@implementation ShowSelectEntity

MJExtensionCodingImplementation

+(instancetype)newInitializationWithValue:(NSString *)value Key:(NSString *)key{
    
    ShowSelectEntity  *entity = [[ShowSelectEntity alloc]init];
    entity.value = value;
    entity.key = key;
    if ([value isEqualToString:@"全部任务"]) {
        entity.isSelect = YES;
    }
    return entity;
}


@end
