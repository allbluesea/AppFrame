//
//  NetworkManager.m
//  


#import "NetworkManager.h"

/*
 接口返回字段
 */
static NSString * CODE_KEY = @"code";
static NSString * MSG_KEY = @"msg";
static NSString * DATA_KEY = @"data";


@implementation NetworkManager

// MARK: GET

+ (void)GETWithURLString:(NSString *)URL
              parameters:(NSDictionary *)parameters
         completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
            failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    [self GETWithURLString:URL
               HTTPHeaders:nil
                parameters:parameters
           completionBlock:completionBlock
              failureBlock:failureBlock];
    
}

+ (void)GETWithURLString:(NSString *)URL
             HTTPHeaders:(NSDictionary *)HTTPHeaders
              parameters:(NSDictionary *)parameters
         completionBlock:(void(^)(NSInteger code, NSString *message, id responseData))completionBlock
            failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock {
    [self requestWithMethod:@"GET"
                  URLString:URL
                HTTPHeaders:HTTPHeaders
                 parameters:parameters
            completionBlock:completionBlock
               failureBlock:failureBlock];
}

// MARK: POST

+ (void)POSTWithURLString:(NSString *)URL
               parameters:(NSDictionary *)parameters
          completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
             failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    [self POSTWithURLString:URL
                HTTPHeaders:nil
                 parameters:parameters
            completionBlock:completionBlock
               failureBlock:failureBlock];
}

+ (void)POSTWithURLString:(NSString *)URL
              HTTPHeaders:(NSDictionary *)HTTPHeaders
               parameters:(NSDictionary *)parameters
          completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
             failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    [self requestWithMethod:@"POST"
                  URLString:URL
                HTTPHeaders:HTTPHeaders
                 parameters:parameters
            completionBlock:completionBlock
               failureBlock:failureBlock];
}


// MARK: Other


+ (void)requestWithMethod:(NSString *)method
                URLString:(NSString *)URL
              HTTPHeaders:(NSDictionary *)HTTPHeaders
               parameters:(NSDictionary *)parameters
          completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
             failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    
    
#if DEBUG_URL_MODE
    
    // print the request url
    NSMutableString *url = [[NSMutableString alloc] initWithString:URL];
    
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:parameters];
    if (dict.allKeys.count > 0) {
        if ([url containsString:@"?"]) {
            [url appendString:@"&"];
        } else {
            [url appendString:@"?"];
        }
        NSArray *allKey = [dict allKeys];
        for (int i = 0; i < allKey.count; i++) {
            NSString *key = [allKey objectAtIndex:i];
            NSString *value = [dict objectForKey:key];
            if (i == allKey.count - 1) {
                [url appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{
                [url appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
            }
        }
    }
    NSLog(@"url --> %@\n", url);
    
#endif
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [manager setResponseSerializer:serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    // 配置请求头
    if (HTTPHeaders) {
        for (NSString *field in HTTPHeaders) {
            [manager.requestSerializer setValue:HTTPHeaders[field] forHTTPHeaderField:field];
        }
    }
    
    // 设置Session
    NSData *cookieData = [USER_DEFAULTS objectForKey:kSession];
    if ([cookieData length]) {
        NSHTTPCookie *sessionCookie = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sessionCookie];
    }
    
    if ([method isEqualToString:@"GET"]) {
        [manager GET:URL
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 [self handleSuccessResponse:responseObject forSuccessBlock:completionBlock failureBlock:failureBlock];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failureBlock(error.code, error.localizedDescription);
                 if (ONLINE == 0) {
                     [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@(%ld)", error.localizedDescription, error.code]];
                 }
             }
         ];
    } else {
        [manager POST:URL
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  [self handleSuccessResponse:responseObject forSuccessBlock:completionBlock failureBlock:failureBlock];
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failureBlock(error.code, error.localizedDescription);
                  if (ONLINE == 0) {
                      [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@(%ld)", error.localizedDescription, error.code]];
                  }
              }
         ];
    }
}


+ (void)uploadFileWithURLString:(NSString *)URL
                     parameters:(NSDictionary *)parameters
                       fileData:(NSData *)fileData
                          field:(NSString *)field
                       fileName:(NSString *)fileName
                       mimeType:(NSString *)mimeType
                completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
                   failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [manager setResponseSerializer:serializer];
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //将得到的二进制图片拼接到表单中
        /**
         data,指定上传的二进制流;
         name,服务器端所需参数名;
         fileName,指定文件名;
         mimeType（多用途互联网邮件扩展，Multipurpose Internet Mail Extensions）,指定文件格式
         */
        [formData appendPartWithFileData:fileData
                                    name:field
                                fileName:fileName
                                mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessResponse:responseObject forSuccessBlock:completionBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error.code, error.localizedDescription);
    }];
}

+ (void)uploadMultiFilesWithURLString:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                            fileArray:(NSArray<NSDictionary *> *)fileArr
                                field:(NSString *)field
                             mimeType:(NSString *)mimeType
                      completionBlock:(void (^)(NSInteger, NSString *, id))completionBlock
                         failureBlock:(void (^)(NSInteger, NSString *))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [manager setResponseSerializer:serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *dict in fileArr) {
            //将得到的二进制图片拼接到表单中
            /**
             data,指定上传的二进制流;
             name,服务器端所需参数名;
             fileName,指定文件名;
             mimeType（多用途互联网邮件扩展，Multipurpose Internet Mail Extensions）,指定文件格式
             */
            [formData appendPartWithFileData:[dict objectForKey:@"data"]
                                        name:field
                                    fileName:[dict objectForKey:@"fileName"]
                                    mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessResponse:responseObject forSuccessBlock:completionBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error.code, error.localizedDescription);
    }];
    
}

/**
 response handler - can be overriden in subclass if needed
 */
+ (void)handleSuccessResponse:(id)responseObj
              forSuccessBlock:(void(^)(NSInteger, NSString *, id))successBlock
                 failureBlock:(void(^)(NSInteger, NSString *))failureBlock {
    
    NSDictionary *objectDict = (NSDictionary *)responseObj;
    NSInteger code = [self codeFromObject:[objectDict objectForKey:CODE_KEY]];
    
    NSString *msg = nil;
    if ([objectDict.allKeys containsObject:MSG_KEY]) {
        msg = [objectDict objectForKey:MSG_KEY];
    }
    
    id data = nil;
    if ([objectDict.allKeys containsObject:DATA_KEY]) {
        data = [objectDict objectForKey:DATA_KEY];
    }
    if (code == ResponseStatusCodeSuccess) {
        successBlock(code, msg, data);
    } else if (code == ResponseStatusCodeInvalidLoginStatus) {
        failureBlock(code, msg);
        [self handleInvalidLoginStatus];
    } else {
        failureBlock(code, msg);
    }
}

+ (void)monitorNetworkStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:block];
    [mgr startMonitoring];
}

+ (NSInteger)codeFromObject:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@"0000"]) {
            return ResponseStatusCodeSuccess;
        }
    }
    return [obj integerValue];
}

// 处理登录失效
+ (void)handleInvalidLoginStatus {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *topVC = [Util topmostViewController];
        if ([topVC isKindOfClass:NSClassFromString(@"ICELoginViewController")]) {
            return;
        }
        // 跳转登录
        [SeekAppDelegate() goToLogin];
    });
    
}

@end
