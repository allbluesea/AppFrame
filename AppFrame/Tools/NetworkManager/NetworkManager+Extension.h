//
//  NetworkManager+Extension.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Extension)

+ (void)GETWithAPIName:(NSString *)name
            parameters:(NSDictionary *)parameters
       completionBlock:(void (^)(NSInteger code, NSString *message, id responseData))completionBlock
          failureBlock:(void (^)(NSInteger code, NSString *errorString))failureBlock;

+ (void)POSTWithAPIName:(NSString *)name
             parameters:(NSDictionary *)parameters
        completionBlock:(void (^)(NSInteger code, NSString *message, id responseData))completionBlock
           failureBlock:(void (^)(NSInteger code, NSString *errorString))failureBlock;

@end
