//
//  DUX_UploadUserIcon.m
//  BusinessHaiNan
//
//  Created by 黄宏盛 on 16/1/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DUX_UploadUserIcon.h"
#import <Photos/Photos.h>

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
    

    
    
    if (tag == 214 || tag == 215) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sc_cancel", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"sc_Album", nil), nil];
        [sheet showInView:fatherVC.view];
    }else {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sc_cancel", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"sc_Album", nil), NSLocalizedString(@"sc_takePhoto", nil), nil];
        [sheet showInView:fatherVC.view];
    }
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
//        [self createPhotoView];
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取到这个图片的原始像素数据
//    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//    SCLog(@"%@",rawData);
//    __block NSString *referenceUrlString;
//    __block NSData *imagePickedData;
//    NSURL *imageExtenstion = info[UIImagePickerControllerReferenceURL];
//    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageExtenstion] options:nil];
//    PHAsset *asset = result.firstObject;
//    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        //获取实际路径
//        imagePickedData = imageData;
//        NSURL *tmp = info[@"PHImageFileURLKey"];
//        referenceUrlString = [tmp absoluteString];
//        SCLog(@"路径：%@--文件名：%@",tmp,tmp.lastPathComponent);
//    }];
    
//    if (UIImagePNGRepresentation(image) != nil) {
//        imagePickedData = UIImagePNGRepresentation(image);
//
//    }else{
//        imagePickedData = UIImageJPEGRepresentation(image, 1.0);
//
//    }
    
    //获取选择的原图
//    UIImage *originaliImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    NSURL *imageExtenstion = info[UIImagePickerControllerReferenceURL];
//    NSData *imagePickedData;
//    if ([[imageExtenstion absoluteString] containsString:@"PNG"]) {
//        imagePickedData = UIImagePNGRepresentation(originaliImage);
//    }else {
//        imagePickedData = UIImageJPEGRepresentation(originaliImage, 1);
//    }
//    //将选择的图片保存到Document目录下
//    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imagePickedData attributes:nil];
//    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//    NSURL *tmp = [NSURL fileURLWithPath:filePath];
    NSURL *imageExtenstion = info[UIImagePickerControllerReferenceURL];
    NSData *imagePickedData;
    if ([[imageExtenstion absoluteString] containsString:@"PNG"]) {
        imagePickedData = UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]);
    }else {
        imagePickedData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1);
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imagePickedData attributes:nil];
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    NSURL *tmp = [NSURL fileURLWithPath:filePath];
    // ** 上传用户头像
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:Tag:imageData:)]) {
        [self.uploadImageDelegate uploadImageToServerWithImage:image Tag:self.tag imageData:nil];
    }
    
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:FileUrl:)]) {
        if (@available(iOS 11.0, *)) {
            NSString  *url = [info objectForKey:UIImagePickerControllerImageURL];
            [self.uploadImageDelegate uploadImageToServerWithImage:image FileUrl:[NSString stringWithFormat:@"%@",url]];
        } else {
            [self.uploadImageDelegate uploadImageToServerWithImage:image FileUrl:[NSString stringWithFormat:@"%@",[tmp absoluteString]]];
            
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
