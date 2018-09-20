//
//  SYAlertTool.m
//  ShanChain
//
//  Created by krew on 2017/10/26.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYAlertTool.h"
#import "SCAppManager.h"

@interface SYAlertTool()

@property(nonatomic,strong)NSDictionary * dic;

@end

@implementation SYAlertTool

+ (void)keyGetDictionary:(NSDictionary *)dic{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *titles = [NSMutableArray array];//存储前n-1的数据
    NSMutableArray *keys = [NSMutableArray array]; //存储前n-1的key数据
    
    NSArray *dictKeysArray = [dic allKeys];
    
    for(int i = 0; i < dictKeysArray.count - 1; i++){
        NSString *key = dictKeysArray[i];
        [keys addObject:key];
        
        NSString *obj = [dic objectForKey:key];
        [titles addObject:obj];
    }
    
    NSString *key = dictKeysArray[dictKeysArray.count - 1];
    NSString *cancel = [dic objectForKey:key];
    
    [self addActionTarget:alert titles:titles option:dic];
    [self addCancelActionTarget:alert title:cancel];
    
    [[[SCAppManager shareInstance] visibleViewController] presentViewController:alert animated:YES completion:nil];
    
    
}

+ (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles option:(NSDictionary *)dic{
    NSString *keyId;
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                       }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isEqualToString: title]) {
                key = keyId;
                SCLog(@"----------%@",keyId);
            }
        }];
        
        [alertController addAction:action];
    }
}

// 取消按钮
+ (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [action setValue:RGB(0, 118,255) forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

+ (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:RGB(212, 0, 0) forState:UIControlStateNormal];
        }
    }
}


@end
