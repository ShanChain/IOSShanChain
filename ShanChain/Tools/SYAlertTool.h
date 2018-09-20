//
//  SYAlertTool.h
//  ShanChain
//
//  Created by krew on 2017/10/26.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYAlertTool : NSObject

+ (void)keyGetDictionary:(NSDictionary *)dic ;

+ (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles;

+ (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title;

+ (void)willPresentActionSheet:(UIActionSheet *)actionSheet;

@end
