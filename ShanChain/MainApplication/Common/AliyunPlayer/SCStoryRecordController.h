//
//  SCStoryRecordController.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/20.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCBaseVC.h"

@protocol SCStoryRecordDelegate<NSObject>

- (void)storyRecordSuccessWithVideoPath:(NSString *)videoPath andImagePath:(NSString *)imagePath;

@end

@interface SCStoryRecordController : UIImagePickerController

@property (strong, nonatomic) id<SCStoryRecordDelegate> reocodDelegate;

@end
