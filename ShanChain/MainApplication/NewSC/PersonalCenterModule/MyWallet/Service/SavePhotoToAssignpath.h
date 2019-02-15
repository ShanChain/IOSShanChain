//
//  SavePhotoToAssignpath.h
//  ShanChain
//
//  Created by 千千世界 on 2019/1/30.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class NSData;
@class PHAsset;


@interface SavePhotoToAssignpath : NSObject



/**
 保存完成回调
 
 @param success YES:保存成功；NO:保存失败
 @param asset PHAsset,通过其可获取到已保存到相册中的图片
 */
typedef void (^SaveCompletion)(BOOL success,PHAsset *asset);


/**
 *  初始化方法
 *
 *  @param folderName 操作的目录文件
 *
 *  @return 操作对象
 */
- (instancetype)initWithFolderName:(NSString *)folderName;

/**
 *  保存图片到系统相册
 *
 *  @param imagePath  保存的图片路径
 */
- (void)saveImagePath:(NSString *)imagePath;
- (void)saveDataWithPhtotoKit:(id)data completion:(SaveCompletion)completion;

/**
 *  保存视频到系统相册
 *
 *  @param videoPath  保存的视频路径
 */
- (void)saveVideoPath:(NSString *)videoPath;

/**
 *  删除系统相册中的文件
 *
 *  @param filePath   文件的路径
 */
- (void)deleteFile:(NSString *)filePath;


@end
