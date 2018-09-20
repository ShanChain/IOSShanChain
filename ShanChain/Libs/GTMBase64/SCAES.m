//
//  SCAES.m
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCAES.h"
#import <CommonCrypto/CommonCryptor.h>

NSString *const kInitVector = @"shanchain1848000";
size_t const kKeySize = kCCKeySizeAES128;

@implementation SCAES

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}

+ (NSString *)encryptShanChainWithPaddingString:(NSString *)paddingText withContent:(NSString *)content {
    NSString *baseEncodeString = [SCBase64 encodeBase64String:paddingText];
    NSString *subString = [baseEncodeString substringToIndex:16];
    NSString *cipherText = [SCAES encryptAES:content key:subString];
    NSString *urlString = [cipherText URLEncodedString];
    return [SCBase64 encodeBase64String:urlString];
}

@end
