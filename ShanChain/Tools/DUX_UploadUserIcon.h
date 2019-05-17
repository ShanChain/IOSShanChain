//
//  DUX_UploadUserIcon.h
//  BusinessHaiNan
//
//  Created by 黄宏盛 on 16/1/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  ============================================================  */
// ** 宏定义单例模式方便外界调用
#define UPLOAD_IMAGE [DUX_UploadUserIcon shareUploadImage]

// ** 代理方法
@protocol DUX_UploadUserIconDelegate <NSObject>

@optional
// ** 处理图片的方法
- (void)uploadImageToServerWithImage:(UIImage *)image Tag:(NSInteger)tag imageData:(NSData *)data;
- (void)uploadImageToServerWithImage:(UIImage *)image FileUrl:(NSString*)fileUrl;

@end

/*  ============================================================  */
@interface DUX_UploadUserIcon : NSObject <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id <DUX_UploadUserIconDelegate> uploadImageDelegate;
@property(nonatomic,strong) UIViewController * fatherViewController;
@property(nonatomic,copy)  void (^DUX_cancelBlock)(void);
// ** 记录当前imageViewTag值
@property(nonatomic,assign) NSInteger        tag;

// ** 单例方法
+ (DUX_UploadUserIcon *)shareUploadImage;

// ** 弹出选项窗口的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC imageTag:(NSInteger)tag delegate:(id<DUX_UploadUserIconDelegate>)aDelegate;



@end
