//
//  SCAES.h
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAES : NSObject

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key ;

+ (NSString *)encryptShanChainWithPaddingString:(NSString *)paddingText withContent:(NSString *)content;

@end
