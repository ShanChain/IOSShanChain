//
//  SCStoryRecordController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/20.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCStoryRecordController.h"

@interface SCStoryRecordController()<UIImagePickerControllerDelegate>

@end

@implementation SCStoryRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![self _isAvailableRecord]) {
            return self;
        }
        
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.mediaTypes = @[(NSString *)kUTTypeMovie];
        
        self.videoQuality = UIImagePickerControllerQualityTypeMedium;
                
        self.videoMaximumDuration = 60;

//        self.showsCameraControls = NO;
        
        self.delegate = self;
        
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        [self _swithCameraDeviceDirection:NO];
    }
    return self;
}

- (BOOL)_isAvailableRecord {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (void)_swithCameraDeviceDirection:(BOOL)isFront {
    if (isFront) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else {
            [SYProgressHUD showError:@"前置摄像头不可用"];
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            [SYProgressHUD showError:@"前置摄像头不可用"];
        }
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    if (info[UIImagePickerControllerMediaType] == (NSString *)kUTTypeMovie && info[UIImagePickerControllerMediaURL]) {
//        [SYProgressHUD showMessage:@"生成视频中..."];
//        NSURL *mediaUrl = info[UIImagePickerControllerMediaURL];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yy_MM_dd_hh_mm";
//        NSString *identity = [[Util uuid] stringByAppendingString: [formatter stringFromDate:[NSDate date]]];
//        NSString *destinationImageName = [SCFileSessionManager getImagePathWithIdentity:identity];
//        NSString *destinationVideoName = [SCFileSessionManager getVideoPathWithIdentity:identity];
//        UIImage *thumbnailImage = [self getVideoThumbnailWithVideoURL:mediaUrl];
//        if (thumbnailImage) {
//            NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 1.0f);
//            if (thumbnailImageData) {
//                [thumbnailImageData writeToURL:[NSURL fileURLWithPath:destinationImageName] atomically:YES];
//                SCLog(@"thumbnail image write success。  filePath:%@", destinationImageName);
//            }
//        }
//        
//        WS(WeakSelf);
//        [self convertVideoToMp4:mediaUrl withExportURL:[NSURL fileURLWithPath:destinationVideoName] withCallback:^{
//            if ([WeakSelf.reocodDelegate respondsToSelector:@selector(storyRecordSuccessWithVideoPath:andImagePath:)]) {
//                [WeakSelf.reocodDelegate storyRecordSuccessWithVideoPath:destinationVideoName andImagePath:destinationImageName];
//            }
//            [SYProgressHUD hideHUD];
//            [WeakSelf dismissViewControllerAnimated:YES completion:nil];
//        }];
//    }
//}

//- (void)convertVideoToMp4:(NSURL *)sourceUrl withExportURL:(NSURL *)destinationUrl withCallback:(void(^)())callback {
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
//    AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
//    exportSession.outputURL = destinationUrl;
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    exportSession.shouldOptimizeForNetworkUse = YES;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
//        switch (exportSession.status) {
//            case AVAssetExportSessionStatusCancelled:
//                SCLog(@"AVAssetExportSessionStatusCancelled");
//                break;
//            case AVAssetExportSessionStatusUnknown:
//                SCLog(@"AVAssetExportSessionStatusUnknown");
//                break;
//            case AVAssetExportSessionStatusWaiting:
//                SCLog(@"AVAssetExportSessionStatusWaiting");
//                break;
//            case AVAssetExportSessionStatusExporting:
//                SCLog(@"AVAssetExportSessionStatusExporting");
//                break;
//            case AVAssetExportSessionStatusCompleted: {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    callback();
//                });
//                break;
//            }
//            case AVAssetExportSessionStatusFailed:
//                SCLog(@"AVAssetExportSessionStatusFailed");
//                break;
//        }
//    }];
//}
//
//- (UIImage *)getVideoThumbnailWithVideoURL:(NSURL *)url {
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef imageRef = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//
//    return thumbnail;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
