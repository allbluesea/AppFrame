//
//  EncryptTool.m
//
//  Created by stary on 2017/11/8.
//  Copyright © 2017年 Firebrk. All rights reserved.
//

#import "CrypticTool.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation CrypticTool

+ (NSString *)MD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output copy];
}


+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;

    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];

    size_t bufferSize = 0;
    bufferSize = ([textData length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);

    uint8_t *buffer = NULL;
    buffer = malloc(bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x00, bufferSize);

    const Byte iv[] = {1,2,3,4,5,6,7,8};

    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],
                                          kCCKeySizeDES,
                                          iv,
                                          [textData bytes],
                                          [textData length],
                                          (void *)buffer,
                                          bufferSize,
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:numBytesEncrypted];

        ciphertext = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
    }

    free(buffer);

    return ciphertext;
}

+ (NSString *)encryptUse3DES:(NSString *)plainText key:(NSString *)key {
    // fujica 密钥需要base64解码
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t plainTextBufferSize = [textData length];
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t moveByTes = 0;
    
    bufferPtrSize = (plainTextBufferSize * kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const Byte iv[] = {1,2,3,4,5,6,7,8};
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       [keyData bytes],
                       kCCKeySize3DES,
                       iv,
                       [textData bytes],
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &moveByTes);
    
    NSString *resultString = nil;
    
    if (ccStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytes:bufferPtr length:(NSUInteger)moveByTes];
        
        resultString = [[NSString alloc] initWithData:[resultData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
    }
    
    
    return resultString;


}

// 解密方法
+ (NSString*)decryptUse3DES:(NSString *)encryptText key:(NSString *)key {
    // fujica 密钥需要base64解码
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:encryptText  options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    size_t plainTextBufferSize = [encryptData length];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
//    const void *vkey = (const void *) [key UTF8String];
    const Byte iv[] = {1,2,3,4,5,6,7,8};
    
    NSString *result = nil;
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       [keyData bytes],
                       kCCKeySize3DES,
                       iv,
                       [encryptData bytes],
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    }
    
    
    return result;
}





@end
