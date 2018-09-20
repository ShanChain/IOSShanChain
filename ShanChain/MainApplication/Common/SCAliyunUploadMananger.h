//
//  SCAliyunUploadMananger.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/11/30.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAliyunUploadManangerDelegate<NSObject>

- (void)aliyunUploadManagerFinishdWithImageURLArray:(NSArray *)array;

- (void)aliyunUploadManagerError:(NSError *)error;
@end

@interface SCAliyunUploadMananger : NSObject

+ (SCAliyunUploadMananger *)shareInstance;

+ (void)uploadImage:(UIImage *)image withCompressionQuality:(CGFloat)cq withCallBack:(void(^)(NSString *))cb withErrorCallBack:(void(^)(NSError *))ecb;

@property (strong, nonatomic) id <SCAliyunUploadManangerDelegate> delegate;

- (void)uploadImageArray:(NSArray *)imageArray;

@end
