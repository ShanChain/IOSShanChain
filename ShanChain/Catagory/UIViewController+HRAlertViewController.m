//
//  UIViewController+HRAlertViewController.m
//  HireRussians
//
//  Created by Ivan Shevelev on 10/11/15.
//  Copyright © 2015 Sibers. All rights reserved.
//

#import "UIViewController+HRAlertViewController.h"



@implementation UIViewController (HRAlertView)

//-(nonnull UIAlertController *)pn_hrAlertWithTitle:(nullable NSString *)title
//                                       message:(nullable NSString *)message
//                                 buttonsTitles:(nullable NSArray<NSString *> *)buttonTitles
//                                    andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
//                                                                             message:message
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    if (title && title != nil && ![title isKindOfClass:[NSNull class]]) {
//        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
//        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Theme_MainThemeColor range:NSMakeRange(0, title.length)];
//        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
//        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
//    }
//
//
//    if (message && message != nil && ![message isKindOfClass:[NSNull class]]) {
//        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
////        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, message.length)];
//        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
//        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
//    }
//
//    UIView *subView1 = alertController.view.subviews[0];
//    UIView *subView2 = subView1.subviews[0];
//    UIView *subView3 = subView2.subviews[0];
//    UIView *subView4 = subView3.subviews[0];
//    UIView *subView5 = subView4.subviews[0];
//    if ([subView5.subviews[1] isKindOfClass:[UILabel class]]) {
//        UILabel *messageLB = subView5.subviews[1];
//        messageLB.textAlignment = 1;
//    }
//
//
//    for (NSString *btnTitle in buttonTitles) {
//        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) {
//                                                           if (handler) {
//                                                               handler(action, [alertController.actions indexOfObject:action]);
//                                                           }
//                                                       }];
////        if ([action.title isEqualToString:@"确定"]) {
////            [action setValue:Theme_MainThemeColor forKey:@"_titleTextColor"];
////        }else if ([action.title isEqualToString:@"取消"] || [action.title isEqualToString:@"稍后再说"]){
////            [action setValue:Theme_MainAssociatedTextStyle.color forKey:@"_titleTextColor"];
////        }
//         [alertController addAction:action];
//    }
//    return alertController;
//}


-(nonnull UIAlertController *)hrAlertWithTitle:(nullable NSString *)title
                                       message:(nullable NSString *)message
                                 buttonsTitles:(nullable NSArray<NSString *> *)buttonTitles
                                    andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *btnTitle in buttonTitles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if (handler) {
                                                               handler(action, [alertController.actions indexOfObject:action]);
                                                           }
                                                       }];
        [alertController addAction:action];
    }
    return alertController;
}


//-(void)pn_hrShowAlertWithTitle:(nullable NSString *)title
//                    message:(nullable NSString *)message
//              buttonsTitles:(NSArray<NSString *> *)buttonTitles
//                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler {
//    UIAlertController *alertController = [self pn_hrAlertWithTitle:title
//                                                        message:message
//                                                  buttonsTitles:buttonTitles
//                                                     andHandler:handler];
//    [self presentViewController:alertController animated:YES completion:nil];
//}


-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
              buttonsTitles:(NSArray<NSString *> *)buttonTitles
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler {
    UIAlertController *alertController = [self hrAlertWithTitle:title
                                                        message:message
                                                  buttonsTitles:buttonTitles
                                                     andHandler:handler];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler {
    [self hrShowAlertWithTitle:title
                       message:message
                 buttonsTitles:@[NSLocalizedString(@"OK", nil)]
                    andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
                        if (handler) {
                            handler(action);
                        }
                    }];
}

-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message {
    [self hrShowAlertWithTitle:title
                       message:message
                    andHandler:nil];
}

-(void)hrShowErrorAlertWithMessage:(nullable NSString *)message {
    [self hrShowAlertWithTitle:NSLocalizedString(@"Error!", nil)
                       message:message];
}

-(void)hrShowErrorAlertWithMessage:(nullable NSString *)message
                        andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler {
    [self hrShowAlertWithTitle:NSLocalizedString(@"Error!", nil)
                       message:message
                    andHandler:handler];
}

-(void)hrShowSuccessAlertWithMessage:(nullable NSString *)message {
    [self hrShowAlertWithTitle:NSLocalizedString(@"Success!", nil)
                       message:message];
}

-(void)hrShowSuccessAlertWithMessage:(nullable NSString *)message
                          andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler {
    [self hrShowAlertWithTitle:NSLocalizedString(@"Success!", nil)
                       message:message
                    andHandler:handler];
}

-(void)hrShowAlertWithError:(nullable NSError *)error {
    [self hrShowErrorAlertWithMessage:error.localizedDescription];
}

-(void)hrShowAlertWithError:(nullable NSError *)error
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler {
    [self hrShowAlertWithTitle:NSLocalizedString(@"Error!", nil)
                       message:error.localizedDescription
                    andHandler:handler];
}

@end

@implementation UIViewController (HRActionSheet)

-(void)hrShowActionSheetWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                     buttonTitles:(nullable NSArray<NSString *> *)titles
                    actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
           andCancelActionHandler:(nullable void(^)())cancelActionHandler {
    UIAlertController *alertController = [self hrAlertControllerWithTitle:title
                                                                  message:message
                                                            buttonsTitles:titles
                                                         andActionHandler:handler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (cancelActionHandler) {
                                                                 cancelActionHandler();
                                                             }
                                                         }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

-(void)hrShowActionSheetWithTitle:(nullable NSString *)title
                     buttonTitles:(nullable NSArray<NSString *> *)titles
                    actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
           andCancelActionHandler:(nullable void(^)())cancelActionHandler {
    [self hrShowActionSheetWithTitle:title
                             message:nil
                        buttonTitles:titles
                       actionHandler:handler
              andCancelActionHandler:cancelActionHandler];
}

-(void)hrShowActionSheetWithMessage:(nullable NSString *)message
                       buttonTitles:(nullable NSArray<NSString *> *)titles
                      actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
             andCancelActionHandler:(nullable void(^)())cancelActionHandler {
    [self hrShowActionSheetWithTitle:nil
                             message:message
                        buttonTitles:titles
                       actionHandler:handler
              andCancelActionHandler:cancelActionHandler];
}


-(void)hrShowActionSheetWithTitles:(nullable NSArray<NSString *> *)titles
                     actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
            andCancelActionHandler:(nullable void(^)())cancelActionHandler {
    UIAlertController *alertController = [self hrAlertControllerWithTitles:titles andActionHandler:handler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (cancelActionHandler) {
                                                                 cancelActionHandler();
                                                             }
                                                         }];
   
    [alertController addAction:cancelAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

-(void)hrShowActionSheetWithTitles:(nullable NSArray<NSString *> *)titles
                     actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    [self hrShowActionSheetWithTitles:titles
                        actionHandler:handler
               andCancelActionHandler:nil];
}

-(void)hrShowActionSheetWithoutCancelWithTitles:(nullable NSArray<NSString *> *)titles
                                  actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    UIAlertController *alertController = [self hrAlertControllerWithTitles:titles andActionHandler:handler];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

-(void)hrShowActionSheetWithoutCancelWithTitles:(nullable NSArray<NSString *> *)titles
                          popoverArrowDirection:(UIPopoverArrowDirection)direction
                                     sourceView:(nullable UIView *)sourceView
                                     sourceRect:(CGRect)rect
                                  actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    UIAlertController *alertController = [self hrAlertControllerWithTitle:nil
                                                                  message:nil
                                                            buttonsTitles:titles
                                                    popoverArrowDirection:direction
                                                               sourceView:sourceView
                                                               sourceRect:rect
                                                         andActionHandler:handler];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

-(UIAlertController *)hrAlertControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                                   buttonsTitles:(NSArray *)titles
                           popoverArrowDirection:(UIPopoverArrowDirection)direction
                                      sourceView:(UIView *)sourceView
                                      sourceRect:(CGRect)sourceRect
                                andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *title in titles) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:title
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (handler) {
                                                                      handler([alertController.actions indexOfObject:action], action.title);
                                                                  }
                                                              }];
//        if ([alertAction.title isEqualToString:@"退出账号"] || [alertAction.title isEqualToString:@"清除缓存"]){
//            [alertAction setValue:Theme_MainAssociatedTextStyle.color forKey:@"_titleTextColor"];
//        }
        [alertController addAction:alertAction];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        if (popPresenter) {
            popPresenter.sourceView = sourceView;
            popPresenter.sourceRect = sourceRect;
            popPresenter.permittedArrowDirections = direction;
        }
    }
    return alertController;
}

#pragma mark - Private

-(UIAlertController *)hrAlertControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                                   buttonsTitles:(NSArray *)titles
                                 andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    CGRect rect = CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 100, 200, 200);
    return [self hrAlertControllerWithTitle:title
                                    message:message
                              buttonsTitles:titles
                      popoverArrowDirection:0 //Apple. WTF with u?
                                 sourceView:self.view
                                 sourceRect:rect
                           andActionHandler:handler];
}

-(UIAlertController *)hrAlertControllerWithTitle:(NSString *)title
                                   buttonsTitles:(NSArray *)titles
                                andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    return [self hrAlertControllerWithTitle:title
                                    message:nil
                              buttonsTitles:titles
                           andActionHandler:handler];
}

-(UIAlertController *)hrAlertControllerWithMessage:(NSString *)message
                                   buttonsTitles:(NSArray *)titles
                                andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    return [self hrAlertControllerWithTitle:nil
                                    message:message
                              buttonsTitles:titles
                           andActionHandler:handler];
}

-(UIAlertController *)hrAlertControllerWithTitles:(NSArray *)titles
                               andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler {
    return [self hrAlertControllerWithTitle:nil
                                    message:nil
                              buttonsTitles:titles
                           andActionHandler:handler];
}

@end
