//
//  SCAlertModule.m
//  ShanChain
//
//  Created by krew on 2017/10/25.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCAlertModule.h"
#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>
#import "SCAppManager.h"
#import "SYUIFactory.h"
#import "SYProgressHUD.h"


@implementation SCAlertModule


RCT_EXPORT_MODULE(SCAlertMention);

RCT_EXPORT_METHOD(alert
                  : (NSDictionary *)options successCallback
                  : (RCTResponseSenderBlock)successCallback errorCallBack
                  : (RCTResponseErrorBlock)errorCallBack){
//    SCLog(@"open alert with options:%@",options);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    self.options = options;
    NSArray *dictKeysArray = [options allKeys];
    NSString *cancel = [options objectForKey:[NSString stringWithFormat:@"%d",options.allKeys.count - 1]];
    [self addActionTarget:alert titles:options successCallback:successCallback errorCallBack:errorCallBack];
    [self addCancelActionTarget:alert title:cancel];
    
    [[[SCAppManager shareInstance] visibleViewController] presentViewController:alert animated:YES completion:nil];
};

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSDictionary *)titles successCallback:(RCTResponseSenderBlock)successCallback errorCallBack: (RCTResponseErrorBlock)errorCallBack{
    NSMutableArray *allKeys = [[titles allKeys] mutableCopy];
    [allKeys removeObject:[NSString stringWithFormat:@"%d",allKeys.count - 1]];
    for (int i = 0;i < allKeys.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[titles objectForKey:[NSString stringWithFormat:@"%d",i]]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           successCallback(@[[NSString stringWithFormat:@"%d",i]]);
                                                           return ;
                                                       }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [action setValue:RGB(0, 118,255) forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

RCT_EXPORT_METHOD(showInputDialog
                  : (NSDictionary *)options successCallback
                  : (RCTResponseSenderBlock)successCallback errorCallBack
                  : (RCTResponseErrorBlock)errorCallBack){
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SYUIFactory popViewWithTitle:options[@"title"] withSecondTitle:@"" withPlaceholder:options[@"placeHolder"] withCallback:^(NSString *text) {
            NSDictionary *value = @{@"input":text};
            successCallback(@[value]);
        }];
        
    });

}

 RCT_EXPORT_METHOD(showMessage:(NSString *)msg){
     [YYHud showError:msg];
 }



@end
