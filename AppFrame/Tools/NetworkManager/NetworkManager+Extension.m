//
//  NetworkManager+Extension.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "NetworkManager+Extension.h"

static NSString * const SIGN_KEY = @"xxxxxx";

@implementation NetworkManager (Extension)

/**
 配置 HTTP Header
 
 @return HTTP Header
 */
static NSDictionary *HTTPHeaders(NSDictionary *parms) {
    NSString *sign = signedParms(parms);
    NSString *userAgent = [NSString stringWithFormat:@"iOS/%@/%@/%@/%@", [UIDevice deviceType], [UIDevice systemVersion], [UIDevice UUID], [UIDevice appVersion]];
    NSDictionary *header = sign ? @{@"sign": sign, @"User-Agent": userAgent,@"XX-Device-Type": @1004} : nil;
    return header;
}


/**
 参数签名
 
 @param params 原始参数
 @return 已签名参数
 */
static NSString *signedParms(NSDictionary *params) {
    if (params) {
        NSArray *keys = [params.allKeys sortedArrayUsingSelector:@selector(compare:)];
        NSMutableString *sign = [NSMutableString string];
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSString *value = [params objectForKey:key];
            [sign appendFormat:@"%@%@", key, value];
            if (i == keys.count - 1) {
                [sign appendString:SIGN_KEY];
            }
        }
        //        NSString *encodedSign = [signWithRSA stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":#?@!/$&’()*+,;=%<>[\\]^`{|}\"]+"].invertedSet];
        return sign;
    }
    return nil;
}

+ (void)GETWithAPIName:(NSString *)name
            parameters:(NSDictionary *)parameters
       completionBlock:(void (^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
          failureBlock:(void (^)(NSInteger code, NSString *errorString))failureBlock {
    NSString *absURL = [NSString stringWithFormat:@"%@%@", HOST_URL, name];
    // TODO: 配置headers
    

    [self GETWithURLString:absURL
               HTTPHeaders:nil
                parameters:parameters
           completionBlock:completionBlock
              failureBlock:failureBlock];
}

+ (void)POSTWithAPIName:(NSString *)name
             parameters:(NSDictionary *)parameters
        completionBlock:(void (^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
           failureBlock:(void (^)(NSInteger code, NSString *errorString))failureBlock {
    NSString *absURL = [NSString stringWithFormat:@"%@%@", HOST_URL, name];
    // TODO: 配置headers
    
    [self POSTWithURLString:absURL
                HTTPHeaders:nil
                 parameters:parameters
            completionBlock:completionBlock
               failureBlock:failureBlock];
}




@end
