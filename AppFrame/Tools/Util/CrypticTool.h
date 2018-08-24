//
//  EncryptTool.h
//  XYIOT
//
//  Created by stary on 2017/11/8.
//  Copyright © 2017年 XYWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrypticTool : NSObject

/**
 MD5加密
 */
+ (NSString *)MD5:(NSString *)plainStr;

+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *)encryptUse3DES:(NSString *)plainText key:(NSString *)key;
+ (NSString*)decryptUse3DES:(NSString *)encryptText key:(NSString *)key;

@end
