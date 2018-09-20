////
////  SCPhotoLibrary.m
////  ShanChain
////
////  Created by krew on 2017/11/2.
////  Copyright © 2017年 ShanChain. All rights reserved.
////
//
//#import "SCPhotoLibrary.h"
//#import <React/RCTBridgeModule.h>
//#import <Foundation/Foundation.h>
//#import "SCAppManager.h"
//
//
//@interface SCPhotoLibrary()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//
////@property (strong, nonatomic) HXPhotoManager *manager;
//
////图片数组
//@property(nonatomic,strong)NSMutableArray *pictureArr;
//
////阿里云参数
//@property(nonatomic,strong)NSDictionary *aliDict;
//
//@end
//
//@implementation SCPhotoLibrary
//
//- (NSMutableArray *)pictureArr{
//    if (!_pictureArr) {
//        _pictureArr = [NSMutableArray array];
//    }
//    return _pictureArr;
//}
//
//
//RCT_EXPORT_MODULE(SCPhotoLibraryMention);
//
//RCT_EXPORT_METHOD(photoString:(NSString *)photo successCallback: (RCTResponseSenderBlock)successCallback errorCallBack  : (RCTResponseErrorBlock)errorCallBack){
//
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
//
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    ipc.delegate = self;
//    [[SCAppManager shareInstance]pushViewController:ipc animated:YES];
//
////    HXPhotoManager *manager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
////    HXPhotoViewController *vc = [[HXPhotoViewController alloc]init];
////    self.manager.photoMaxNum = 3;
////    [[SCAppManager shareInstance] pushViewController:vc animated:YES];
//
//}
//
//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    [picker dismissViewControllerAnimated:YES completion:nil];//销毁modal控制器
//
//    // 1.取出选中的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//
//    if ([APIClient networkType] > 0) {
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//        [self updateImg: imageData image:image];//接口
//    }else{
//        [SYProgressHUD showError:kNotReachableTip];
//    }
//
////    // 2.添加图片到相册中
////    [self.photosView addImage:image];
//}
//
//
//- (void)updateImg:(NSData *)imageData image:(UIImage *)image {
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    if (image) {
//        if ([APIClient networkType] > 0) {
//            [params setObject:@(1) forKey:@"num"];
////            //   [params setObject:@"hello" forKey:@"token"];
//            [[SCNetwork shareInstance]postWithUrl:STORYUPLOADAPP parameters:params success:^(id responseObject) {
//                if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
//                    self.aliDict = responseObject[@"data"];
//                    [self updateImg:imageData image:image cb:^(NSString *str) {
//
//                    }];
//                }
//            } failure:^(NSError *error) {
//                NSLog(@"%@",error);
//            }];
//        }
//    }
//}
//
////上传阿里云 拿到地址
//- (void)updateImg:(NSData *)imageData image:(UIImage *)image cb:(void(^)(NSString *))cb {
//    //    NSString *uuid = [Util uuid];
//    NSString *uuid = self.aliDict[@"uuidList"][0];
//    NSString *kAliFileAccessKeyId = self.aliDict[@"accessKeyId"];
//    NSString *kAliFileAccessKeySecret = self.aliDict[@"accessKeySecret"];
//    NSString *kAliFileSecurityToken = self.aliDict[@"securityToken"];
//    //  'project' + "/" + self.projectId + "/" + self.updateTypeName + "/" + uuid + ".jpg";
//    //  'project/' + self.projectId + "/" + self.updateTypeName + "/" + uuid + ".jpg";
//    NSString *updateUri = [NSString stringWithFormat:@"%@/%@.jpg?x-oss-process=image/resize,m_fixed,h_1100,w_733",kAliFileHost,uuid];
//    [self.pictureArr addObject:updateUri];
//    NSString *endpoint = kEndPoint;
//
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:kAliFileAccessKeyId secretKeyId:kAliFileAccessKeySecret securityToken:kAliFileSecurityToken];
//    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
//    //
//    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
//    put.bucketName = kAliFileBucketName;
//    put.objectKey = updateUri;
//    put.uploadingData = imageData;
//    put.contentType = @"image/jpeg";
//
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        //        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//    };
//
//    OSSTask *putTask = [client putObject:put];
//    [putTask continueWithBlock:^id(OSSTask *task) {
//        if (!task.error) {
//            LOG(@"阿里云上传成功!");
//            //GCD 写主线程
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//            if (cb) {
//                cb(uuid);
//            }
//        } else {
//            LOG(@"阿里云上传失败, error: %@" , task.error);
//            if (cb) {
//                cb(nil);
//            }
//        }
//        return nil;
//    }];
//}
//
////- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original{
////
////
////
////}
//
//@end

