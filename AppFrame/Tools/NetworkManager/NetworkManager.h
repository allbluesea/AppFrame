//
//  NetworkManager.h
//


#import <Foundation/Foundation.h>
#import <AFNetworking.h>

// 上传文件参数
static NSString * const kUploadField = @"uploadfile";
static NSString * const kMutableUploadField = @"uploadfile[]";

// mimeType
static NSString * const kMimeTypeImagePNG = @"image/png";
static NSString * const kMimeTypeImageJPX = @"image/jpx";
static NSString * const kMimeTypeAudioAMR = @"audio/amr";

@interface NetworkManager : NSObject


// MARK: GET

/**
 GET网络请求
 
 @param URL             URL
 @param parameters      请求参数
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock    失败block
 */
+ (void)GETWithURLString:(NSString *)URL
              parameters:(NSDictionary *)parameters
         completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
            failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;


/**
 GET网络请求(请求头配置)

 @param URL URL
 @param HTTPHeaders 请求头
 @param parameters 请求参数
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock 失败block
 */
+ (void)GETWithURLString:(NSString *)URL
             HTTPHeaders:(NSDictionary *)HTTPHeaders
              parameters:(NSDictionary *)parameters
         completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
            failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;

// MARK: POST

/**
 POST网络请求
 
 @param URL             URL
 @param parameters      请求参数
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock    失败block
 */
+ (void)POSTWithURLString:(NSString *)URL
               parameters:(NSDictionary *)parameters
          completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
             failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;



/**
 POST网络请求(请求头配置)

 @param URL URL
 @param HTTPHeaders 请求头
 @param parameters 请求参数
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock 失败block
 */
+ (void)POSTWithURLString:(NSString *)URL
              HTTPHeaders:(NSDictionary *)HTTPHeaders
               parameters:(NSDictionary *)parameters
          completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
             failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;

// MARK: Other


/**
 网络请求(请求头配置)
 
 @param method          请求方法
 @param URL             URL
 @param HTTPHeaders     请求头
 @param parameters      请求参数
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock    失败block
 */
+ (void)requestWithMethod:(NSString *)method
                URLString:(NSString *)URL
              HTTPHeaders:(NSDictionary *)HTTPHeaders
               parameters:(NSDictionary *)parameters
          completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
             failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;


/**
 上传文件
 
 @param URL             URL
 @param parameters      请求参数
 @param fileData        二进制文件
 @param field           服务器所需字段名
 @param fileName        文件名字
 @param mimeType        多用途互联网邮件扩展类型(文件格式)(参考类型http://www.iana.org/assignments/media-types/. )
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock    失败block
 */
+ (void)uploadFileWithURLString:(NSString *)URL
                     parameters:(NSDictionary *)parameters
                       fileData:(NSData *)fileData
                          field:(NSString *)field
                       fileName:(NSString *)fileName
                       mimeType:(NSString *)mimeType
                completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
                   failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;

/**
 上传多个文件
 
 @param URL             URL
 @param parameters      请求参数
 @param fileArr         待上传数组(字典(存放文件的二进制形式以及文件名,形如{@"data": NSData *, @"fileName": NSString *}))
 @param field           服务器所需字段名
 @param mimeType        多用途互联网邮件扩展类型(文件格式)(参考类型http://www.iana.org/assignments/media-types/. )
 @param completionBlock 完成block(服务器返回code)
 @param failureBlock    失败block
 */
+ (void)uploadMultiFilesWithURLString:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                            fileArray:(NSArray<NSDictionary *> *)fileArr
                                field:(NSString *)field
                             mimeType:(NSString *)mimeType
                      completionBlock:(void(^)(BOOL isSuccessful, NSInteger code, NSString *message, id responseData))completionBlock
                         failureBlock:(void(^)(NSInteger code, NSString *errorString))failureBlock;



/**
 监控网络状态
 */
+ (void)monitorNetworkStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;

@end
