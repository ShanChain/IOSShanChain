//
//  DUX_UploadUserIcon.m
//  BusinessHaiNan
//
//  Created by 黄宏盛 on 16/1/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DUX_UploadUserIcon.h"

static DUX_UploadUserIcon *uploadUserIcon = nil;



@implementation DUX_UploadUserIcon

/*  ============================================================  */
#pragma mark - 单利方法
+ (DUX_UploadUserIcon *)shareUploadImage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadUserIcon = [[DUX_UploadUserIcon alloc] init];
    });
    return uploadUserIcon;
}

/*  ============================================================  */
#pragma mark - 显示ActionSheet方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC imageTag:(NSInteger)tag delegate:(id<DUX_UploadUserIconDelegate>)aDelegate{
    
    uploadUserIcon.uploadImageDelegate = aDelegate;
    uploadUserIcon.tag = tag;
    self.fatherViewController = fatherVC;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"sc_cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"sc_Album", nil), NSLocalizedString(@"sc_takePhoto", nil), nil];
    [sheet showInView:fatherVC.view];
    
    
    
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self fromPhotos];
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//         [self createPhotoView];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        //跳到创建alertview的方法，一般在点击删除这里按钮之后，都需要一个提示框，提醒用户是否真的删除
//        [self creatAlertController_alert];
//    }];
//
//    //把action添加到actionSheet里
//    [actionSheet addAction:action1];
//    [actionSheet addAction:action2];
//    [actionSheet addAction:action3];
    
    //相当于之前的[actionSheet show];
    
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self fromPhotos];
    }else if (buttonIndex == 1) {
        [self createPhotoView];
    }
  
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    BLOCK_EXEC(self.DUX_cancelBlock);
}

/*  ============================================================  */
#pragma mark - 头像图片(从相机中选择得到)
- (void)createPhotoView {
    // ** 设置相机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.sourceType  = UIImagePickerControllerSourceTypeCamera;
        imagePC.delegate = self;
        imagePC.allowsEditing = YES;
        [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"该设备没有照相机"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

/*  ============================================================  */
#pragma mark - 图片库方法(从手机的图片库中查找图片)
- (void)fromPhotos {
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // ** 上传用户头像
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:Tag:)]) {
        [self.uploadImageDelegate uploadImageToServerWithImage:image Tag:self.tag];
    }
    
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:FileUrl:)]) {
        if (@available(iOS 11.0, *)) {
            NSString  *url = [info objectForKey:UIImagePickerControllerImageURL];
            [self.uploadImageDelegate uploadImageToServerWithImage:image FileUrl:[NSString stringWithFormat:@"%@",url]];
        } else {
            [self.uploadImageDelegate uploadImageToServerWithImage:image FileUrl:[NSString stringWithFormat:@"%@",info[UIImagePickerControllerReferenceURL]]];
            
        }
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:Tag:)]) {
//        [self.uploadImageDelegate uploadImageToServerWithImage:nil Tag:self.tag];
//    }
    
}



@end
